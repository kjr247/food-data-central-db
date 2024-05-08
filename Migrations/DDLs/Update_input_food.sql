use FoodData_Central;
declare @beforeChecksum int = 0;
declare @afterChecksum int = 0;
declare @migrationName Nvarchar(40) = N'2024 April Full from 2021 - ';	
declare @pathToInputFolder Nvarchar(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
declare @tableName Nvarchar(40);
declare @startTime datetime2 = GETDATE();

BEGIN TRY  
	set @tableName = 'input_food';

	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;

	TRUNCATE TABLE input_food;
	
	-- Mapping
	DROP TABLE IF EXISTS #tmp;
	create table #tmp(id nvarchar(max) NOT NULL, fdc_id nvarchar(max) NULL,	fdc_of_input_food nvarchar(max) NULL, seq_num nvarchar(max) NULL, amount nvarchar(max) NULL, 
		sr_code nvarchar(max) NULL,	sr_description nvarchar(max) NULL, unit nvarchar(max) NULL,	portion_code nvarchar(max) NULL, portion_description nvarchar(max) NULL, 
		gram_weight nvarchar(max) NULL, retention_code nvarchar(max) NULL, survey_flag nvarchar(max) NULL)

	bulk insert #tmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\input_food.csv' -- update file name, (!sometimes the file names are different <crosses eyes>)
	WITH
		(
			CODEPAGE = '65001'
			,FIRSTROW = 2
			,FIELDTERMINATOR = '\",\"'
			,ROWTERMINATOR = '0x0A'   --Use to shift the control to next row
			,batchsize=10
			--,FORMATFILE='C:\Users\kjr24\source\repos\MineralMateAPI\Scripts\FormatFiles\level_2.fmt'
			--,MAXERRORS=3
			--,ERRORFILE = 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\errors\ErrorFile.csv'
			,TABLOCK
		);
	-- DDL
	insert into input_food(id, fdc_id, fdc_of_input_food, seq_num, amount, sr_code, sr_description, unit, portion_code, portion_description, gram_weight, retention_code, survey_flag) -- UPDATE file name, and columns
		select
			--SELECT CHAR(69) AS [69], CHAR(53) AS [53],   CHAR(51) AS [51], CHAR(50) AS [50],   CHAR(52) AS [52], CHAR(51) AS [51];
			--id, fdc_id, fdc_of_input_food, seq_num, amount, sr_code, sr_description, unit, portion_code, portion_description, 
			--UNICODE(RIGHT(gram_weight, 1)) AS BOOP
			--, gram_weight, retention_code, survey_flag
			CAST(REPLACE(t.id,'"','') AS INT) AS id
			, CAST(t.fdc_id AS INT) AS fdc_id
			, CAST(t.fdc_of_input_food AS INT) AS fdc_of_input_food
			, CAST(t.seq_num AS smallint) AS seq_num
			, CAST(t.amount AS FLOAT) AS amount
			, t.sr_code AS sr_code
			, t.sr_description AS sr_description
			, t.unit AS unit
			, t.portion_code AS portion_code
			, t.portion_description AS portion_description
			, CAST(t.gram_weight as float) AS gram_weight
			, t.retention_code AS retention_code
			, REPLACE(t.survey_flag, CHAR(13), '') AS survey_flag
		from #tmp t
		--ORDER BY t.id
		WHERE NOT EXISTS ( -- skip duplicates
			SELECT 1 FROM input_food AS d --UPDATE
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