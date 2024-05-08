USE FoodData_Central;
DECLARE @beforeChecksum INT = 0;
DECLARE @afterChecksum INT = 0;
DECLARE @migrationName NVARCHAR(40) = N'2024 April Full from 2021 - ';	
DECLARE @pathToInputFolder NVARCHAR(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
DECLARE @tableName Nvarchar(40);
DECLARE @startTime DATETIME2 = GETDATE();

BEGIN TRY  
	set @tableName = 'food_attribute';
	
	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;

	--TRUNCATE TABLE food_attribute; --only truncated the first time and then use fetch next to get through the data, solving problem data along the way
	-- Mapping
	DROP TABLE IF EXISTS #tmp;
	create table #tmp([id] [nvarchar](MAX) NOT NULL, [fdc_id] [nvarchar](MAX) NULL,
	[seq_num] [nvarchar](MAX) NULL,	[food_attribute_type_id] [nvarchar](MAX) NULL,
	[name] [nvarchar](MAX) NULL, [value] [nvarchar](MAX) NULL)

	bulk insert #tmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\food_attribute.csv' -- update file name, (!sometimes the file names are different <crosses eyes>)
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
	-- DDL
	insert into food_attribute(id,fdc_id, seq_num, food_attribute_type_id, name, value) -- UPDATE file name, and columns

		select 
			--top 100000
	--[id] [int] NOT NULL,
	--[fdc_id] [int] NULL,
	--[seq_num] [smallint] NULL,
	--[food_attribute_type_id] [int] NULL,
	--[name] [nvarchar](255) NULL,
	--[value] [smallint] NULL
			--SELECT CHAR(69) AS [69], CHAR(53) AS [53],   CHAR(51) AS [51], CHAR(50) AS [50],   CHAR(52) AS [52], CHAR(51) AS [51];
			--UNICODE(RIGHT(gram_weight, 1)) AS BOOP
			 CAST(REPLACE(t.id,'"','') AS INT) AS id
			, CAST(t.fdc_id AS INT) AS fdc_id
			, CAST(t.seq_num AS SMALLINT) AS seq_num
			, CAST(t.food_attribute_type_id AS INT) AS food_attribute_type_id
			, t.name
			, REPLACE(REPLACE(t.value, '"', ''), CHAR(13), '') AS value -- char(13)- carriage return			
			--, NULLIF(CAST(REPLACE(REPLACE(t.min_year_acquired, '"', ''), CHAR(13), '') AS INT), 0) AS min_year_acquired -- char(13) - carriage return
		from #tmp t
		WHERE NOT EXISTS ( -- skip duplicates
			SELECT 1 FROM food_attribute AS d --UPDATE
			WHERE d.id = CAST(REPLACE(t.id,'"','') AS INT)
		)
		ORDER BY id DESC
		OFFSET 0 ROWS
		FETCH NEXT 2500000 ROWS ONLY

		-- DISCOVER WHICH RECORDS HAVE NOT BEEN ADDED YET - PERHAPS PROBLEM DATA THAT ERRORS
		--SELECT * from #tmp t
		--WHERE NOT EXISTS ( -- skip duplicates
		--	SELECT 1 FROM food_attribute AS d --UPDATE
		--	WHERE d.id = CAST(REPLACE(t.id,'"','') AS INT)
		--)
		--ORDER BY len(value) desc -- for example the length of data may exceed 255

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
  
		DECLARE @msg NVARCHAR(2048) = FORMATMESSAGE(65713, CHECKSUM((SELECT COUNT(*) FROM #tmp)), @afterChecksum);   
  
		THROW 65713, @msg, 1; 
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