USE FoodData_Central;
DECLARE @beforeChecksum INT = 0;
DECLARE @afterChecksum INT = 0;
DECLARE @migrationName NVARCHAR(40) = N'2024 April Full from 2021 - ';	
DECLARE @pathToInputFolder NVARCHAR(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
DECLARE @tableName Nvarchar(40);
DECLARE @startTime DATETIME2 = GETDATE();

BEGIN TRY  
	set @tableName = 'food';
	
	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;

	-- TRUNCATE TABLE food; -- you can enabled this typically commented out and only truncated the first time and then use fetch next to get through the data, solving problem data along the way

	-- Mapping
	DROP TABLE IF EXISTS #preReadtmp;
	create table #preReadtmp(
		fdc_id NVARCHAR(max) NOT NULL, 
		data_type NVARCHAR(max) NULL, 
		description NVARCHAR(max) NULL,
		food_category_id NVARCHAR(max) NULL, 
		publication_date NVARCHAR(max) NULL
	);

	DROP TABLE IF EXISTS #tmp;
	create table #tmp(
		fdc_id INT IDENTITY NOT NULL, 
		data_type NVARCHAR(max) NULL, 
		description NVARCHAR(max) NULL,
		food_category_id NVARCHAR(max) NULL, 
		publication_date NVARCHAR(max) NULL
	);
	CREATE CLUSTERED INDEX ix_tempCIndextmp ON #tmp ([fdc_id]);

	bulk insert #preReadtmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\food.csv' -- update file name, (!sometimes the file names are different <crosses eyes>)
	WITH
		(
			CODEPAGE = '65001'
			,FIRSTROW = 2
			,FIELDTERMINATOR = '\",\"'
			,ROWTERMINATOR = '0x0A'   --Use to shift the control to next row
			,batchsize=500000
			--,FORMATFILE='C:\Users\kjr24\source\repos\MineralMateAPI\Scripts\FormatFiles\level_2.fmt'
			--,MAXERRORS=1000
			--,ERRORFILE = 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\errors\ErrorFile.csv'
			,TABLOCK
		);

	SET IDENTITY_INSERT #tmp ON;
	INSERT INTO #tmp(fdc_id, data_type, description, food_category_id, publication_date)
		SELECT 
			 CAST(REPLACE(P.fdc_id,'"','') AS INT) AS fdc_id
			, data_type
			, description
			, food_category_id
			, publication_date
		FROM #preReadtmp P


	IF ((SELECT COUNT(*) FROM #preReadtmp) = @beforeChecksum)
	BEGIN;
		EXEC sys.sp_addmessage  
			 @msgnum   = 65713  
			,@with_log = true
			,@severity = 16  
			,@replace = 'REPLACE'
			,@msgtext  = N'Migration skipped, - #preReadtmp (%d), and @beforeChecksum (%d).'  
			,@lang = 'us_english';   
  
		DECLARE @msg NVARCHAR(2048) = FORMATMESSAGE(65713, CHECKSUM((SELECT COUNT(*) FROM #preReadtmp)), @beforeChecksum);   
		DROP TABLE IF EXISTS #preReadtmp;		
		THROW 65713, @msg, 1; 
	END;

	DROP TABLE IF EXISTS #preReadtmp;

	DECLARE @i int = 1
	DECLARE @offsetCount int = 1;
	DECLARE @nextCount int = 50000;

	WHILE @i < 42
	BEGIN
		SET @i = @i + 1
		-- DDL
		insert into food(fdc_id, data_type, description, food_category_id, publication_date) -- UPDATE file name, and columns
			 select fdc_id, data_type, description, food_category_id, publication_date
				from (select t.fdc_id
							, t.data_type
							, t.description
							, CAST(t.food_category_id AS SMALLINT) AS food_category_id
							, CAST(REPLACE(REPLACE(t.publication_date, '"', ''), CHAR(13), '') AS DATETIME2) AS publication_date
						from #tmp t
						ORDER BY fdc_id DESC

						OFFSET @offsetCount - 1 ROWS 
						FETCH NEXT @nextCount  - @offsetCount + 1 ROWS ONLY
					) AS a
			WHERE NOT EXISTS ( -- skip duplicates
				SELECT 1 FROM food AS d --UPDATE
				WHERE d.fdc_id = a.fdc_id
			)
			ORDER BY a.fdc_id DESC
			--OFFSET @offsetCount - 1 ROWS 
			--FETCH NEXT @nextCount  - @offsetCount + 1 ROWS ONLY
			OPTION ( OPTIMIZE FOR (@offsetCount = 1, @nextCount = 2036474) ); 

		-- DISCOVER WHICH RECORDS HAVE NOT BEEN ADDED YET - PERHAPS PROBLEM DATA THAT ERRORS
		--SELECT * from #tmp t
		--WHERE NOT EXISTS ( -- skip duplicates
		--	SELECT 1 FROM food_attribute AS d --UPDATE
		--	WHERE d.id = CAST(REPLACE(t.id,'"','') AS INT)
		--)
		--ORDER BY len(value) desc -- for example the length of data may exceed 255

		PRINT CONCAT('OFFSET ', @offsetCount);
		set @offsetCount = @offsetCount + 50000;
		PRINT CONCAT('NEXT ', @nextCount);
		set @nextCount = @nextCount + 50000;
		PRINT CONCAT('last id inserted ', SCOPE_IDENTITY());
	END

	-- CHECKSUM
	SET @SQL = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @afterChecksum output;

	IF ((SELECT COUNT(*) FROM #tmp) != @afterChecksum)
	BEGIN;
		EXEC sys.sp_addmessage  
			 @msgnum   = 65713  
			,@with_log = true
			,@severity = 16  
			,@replace = 'REPLACE'
			,@msgtext  = N'Incomplete Migration, - (%d), and  (%d).'  
			,@lang = 'us_english';   
  
		DECLARE @msg2 NVARCHAR(2048) = FORMATMESSAGE(65713, CHECKSUM((SELECT COUNT(*) FROM #tmp)), @afterChecksum);   
  
		THROW 65713, @msg2, 1; 
	END;

	-- MIGRATION HISTORY
	INSERT INTO migrationHistory (MigrationName, MigrationStatus, ErrorMessage, ExecutionTimeMilliseconds, RollbackScript, ChecksumMigration, ChecksumTableBefore, ChecksumTableAfter, DatabaseVersionBefore, DatabaseVersionAfter)
								  VALUES(CONCAT(@migrationName, 'Table: ', @tableName), 'applied', null, DATEDIFF(MILLISECOND,@startTime,GETDATE()), null, CHECKSUM((SELECT COUNT(*) FROM #tmp)), @beforeChecksum, @afterChecksum, '2021 Full', '2024 April Full')
	-- CLEANUP
	DROP TABLE IF EXISTS #tmp;
END TRY  
BEGIN CATCH
	-- MIGRATION HISTORY
	INSERT INTO migrationHistory (MigrationName, MigrationStatus, ErrorMessage, ExecutionTimeMilliseconds, RollbackScript, ChecksumMigration, ChecksumTableBefore, ChecksumTableAfter, DatabaseVersionBefore, DatabaseVersionAfter)
								  VALUES(CONCAT(@migrationName, 'Table: ', @tableName), 'incomplete', CONCAT(CAST(ERROR_NUMBER() AS NVARCHAR(10)), ' - ',ERROR_MESSAGE()), DATEDIFF(MILLISECOND,@startTime,GETDATE()), null, CHECKSUM((SELECT COUNT(*) FROM #tmp)), @beforeChecksum, @afterChecksum, '2021 Full', '2024 April Full')
	PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
	-- CLEANUP
	DROP TABLE IF EXISTS #tmp;
END CATCH; 
GO  