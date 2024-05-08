use FoodData_Central;
declare @beforeChecksum int = 0;
declare @afterChecksum int = 0;
declare @migrationName Nvarchar(40) = N'2024 April Full from 2021 - ';	
declare @pathToInputFolder Nvarchar(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
declare @tableName Nvarchar(40);
declare @startTime datetime2 = GETDATE();

BEGIN TRY  
	set @tableName = 'food_portion';
	
	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;

	TRUNCATE TABLE food_portion;
	-- Mapping
	DROP TABLE IF EXISTS #tmp;
	create table #tmp(
		id VARCHAR(MAX) NOT NULL
		, fdc_id VARCHAR(MAX) NULL
		, seq_num VARCHAR(MAX) NULL
		, amount VARCHAR(MAX) NULL
		, measure_unit_id VARCHAR(MAX) NULL
		, portion_description VARCHAR(MAX) NULL
		, modifier VARCHAR(MAX) NULL
		, gram_weight VARCHAR(MAX) NULL
		, data_points VARCHAR(MAX) NULL
		, footnote VARCHAR(MAX) NULL
		, min_year_acquired VARCHAR(MAX) NULL)

	bulk insert #tmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\food_portion.csv' -- update file name, (!sometimes the file names are different <crosses eyes>)
	WITH
		(
			CODEPAGE = '65001'
			,FIRSTROW = 2
			,FIELDTERMINATOR = '\",\"'
			,ROWTERMINATOR = '0x0A'   --Use to shift the control to next row
			,batchsize=100
			--,FORMATFILE='C:\Users\kjr24\source\repos\MineralMateAPI\Scripts\FormatFiles\level_2.fmt'
			--,MAXERRORS=3
			--,ERRORFILE = 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\errors\ErrorFile.csv'
			,TABLOCK
		);
	-- DDL
	insert into food_portion(id, fdc_id, seq_num, amount, measure_unit_id, portion_description, modifier, gram_weight, data_points, footnote, min_year_acquired) -- UPDATE file name, and columns
		select
			--SELECT CHAR(69) AS [69], CHAR(53) AS [53],   CHAR(51) AS [51], CHAR(50) AS [50],   CHAR(52) AS [52], CHAR(51) AS [51];
			--UNICODE(RIGHT(gram_weight, 1)) AS BOOP
			CAST(REPLACE(t.id,'"','') AS INT) AS id
			, CAST(t.fdc_id AS INT) AS fdc_id
			, CAST(t.seq_num AS INT) AS seq_num
			, CAST(t.amount AS FLOAT) AS amount
			, CAST(t.measure_unit_id AS INT) AS measure_unit_id
			, t.portion_description AS portion_description
			, t.modifier AS modifier
			, CAST(t.gram_weight AS FLOAT) AS gram_weight
			, CAST(t.data_points as float) AS data_points
			, t.footnote AS footnote
			, NULLIF(CAST(REPLACE(REPLACE(t.min_year_acquired, '"', ''), CHAR(13), '') AS INT), 0) AS min_year_acquired -- char(13) - carriage return
		from #tmp t
		WHERE NOT EXISTS ( -- skip duplicates
			SELECT 1 FROM food_portion AS d --UPDATE
			WHERE d.id = CAST(REPLACE(t.id,'"','') AS INT)
		)
	
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