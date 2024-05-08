USE FoodData_Central;
DECLARE @beforeChecksum INT = 0;
DECLARE @afterChecksum INT = 0;
DECLARE @migrationName NVARCHAR(40) = N'2024 April Full from 2021 - ';	
DECLARE @pathToInputFolder NVARCHAR(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
DECLARE @tableName Nvarchar(40);
DECLARE @startTime DATETIME2 = GETDATE();

BEGIN TRY  
	set @tableName = 'sub_sample_result';
	
	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;

	TRUNCATE TABLE sub_sample_result;
	-- Mapping
	DROP TABLE IF EXISTS #tmp;
	create table #tmp(food_nutrient_id nvarchar(max) NOT NULL,	adjusted_amount nvarchar(max) NULL,	lab_method_id nvarchar(max) NULL, nutrient_name nvarchar(max) NULL)

	bulk insert #tmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\sub_sample_result.csv' -- update file name, (!sometimes the file names are different <crosses eyes>)
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
	insert into sub_sample_result(food_nutrient_id, adjusted_amount,	lab_method_id, nutrient_name) -- UPDATE file name, and columns
		select
			--SELECT CHAR(69) AS [69], CHAR(53) AS [53],   CHAR(51) AS [51], CHAR(50) AS [50],   CHAR(52) AS [52], CHAR(51) AS [51];
			--UNICODE(RIGHT(gram_weight, 1)) AS BOOP
			CAST(REPLACE(t.food_nutrient_id,'"','') AS INT) AS food_nutrient_id
			, CAST(t.adjusted_amount AS FLOAT) AS adjusted_amount
			, CAST(t.lab_method_id AS SMALLINT) AS lab_method_id
			, REPLACE(REPLACE(t.nutrient_name, '"', ''), CHAR(13), '') AS nutrient_name  -- char(13) - carriage return
			--, NULLIF(CAST(REPLACE(REPLACE(t.min_year_acquired, '"', ''), CHAR(13), '') AS INT), 0) AS min_year_acquired -- char(13) - carriage return
		from #tmp t
		--WHERE NOT EXISTS ( -- skip duplicates
		--	SELECT 1 FROM sub_sample_result AS d --UPDATE
		--	WHERE d.food_nutrient_id = CAST(REPLACE(t.food_nutrient_id,'"','') AS INT)
		--)
	
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