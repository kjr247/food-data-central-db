use FoodData_Central;
declare @beforeChecksum int = 0;
declare @afterChecksum int = 0;
declare @migrationName Nvarchar(40) = N'2024 April Full from 2021 - ';	
declare @pathToInputFolder Nvarchar(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
declare @tableName Nvarchar(40);
declare @startTime datetime2 = GETDATE();

BEGIN TRY  
	set @tableName = 'acquisition_sample';
	TRUNCATE TABLE acquisition_sample;

	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;

	-- Mapping
	DROP TABLE IF EXISTS #tmp;
	create table #tmp(fdc_id_of_sample_food nvarchar(MAX) NULL, fdc_id_of_acquisition_food nvarchar(MAX) NULL)

	bulk insert #tmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\acquisition_samples.csv' -- update file name, (!sometimes the file names are different <crosses eyes>)
	WITH
		(
			CODEPAGE = '65001'
			,FIRSTROW = 2
			,FIELDTERMINATOR = ','
			,ROWTERMINATOR = '0x0A'   --Use to shift the control to next row
			,batchsize=10
			--,FORMATFILE='C:\Users\kjr24\source\repos\MineralMateAPI\Scripts\FormatFiles\level_2.fmt'
			--,MAXERRORS=3
			--,ERRORFILE = 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\errors\ErrorFile.csv'
			,TABLOCK
		);
	-- DDL
	insert into acquisition_sample(fdc_id_of_sample_food, fdc_id_of_acquisition_food) -- UPDATE file name, and columns
		select
			CAST(REPLACE(REPLACE(t.fdc_id_of_sample_food,'"',''), char(13), '') AS INT) AS fdc_id_of_sample_food
			, CAST(REPLACE(REPLACE(t.fdc_id_of_acquisition_food,'"',''), char(13), '') AS INT) AS fdc_id_of_acquisition_food
		from #tmp t
		WHERE NOT EXISTS ( -- skip duplicates
			SELECT 1 FROM acquisition_sample AS d --UPDATE
			WHERE d.fdc_id_of_sample_food = CAST(REPLACE(t.fdc_id_of_sample_food,'"','') AS INT)
		)
	
	-- CHECKSUM
	SET @SQL = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @afterChecksum output;

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