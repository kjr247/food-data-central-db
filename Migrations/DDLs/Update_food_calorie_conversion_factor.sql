use FoodData_Central;
declare @beforeChecksum int = 0;
declare @afterChecksum int = 0;
declare @migrationName Nvarchar(40) = N'2024 April Full from 2021 - ';	
declare @pathToInputFolder Nvarchar(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
declare @tableName Nvarchar(40);
declare @startTime datetime2 = GETDATE();

-- TO TEST, comment out the begin and the inset statement down below and run until the select from #tmp
BEGIN TRY  
	set @tableName = 'food_calorie_conversion_factor';

	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;

	TRUNCATE TABLE food_calorie_conversion_factor;
	DROP TABLE IF EXISTS #tmp; 
	-- Mapping
	create table #tmp(food_nutrient_conversion_factor_id VARCHAR(MAX) NOT NULL, protein_value VARCHAR(MAX) NULL, fat_value VARCHAR(MAX) NULL, carbohydrate_value VARCHAR(MAX) NULL)

	bulk insert #tmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\food_calorie_conversion_factor.csv' -- UPDATE FILE name, (!sometimes the file names are different <crosses eyes>)
	WITH
		(
			CODEPAGE = '65001'
			,FIRSTROW = 2
			,FIELDTERMINATOR = ','
			,ROWTERMINATOR = '0x0A'
			,batchsize=10
			--,MAXERRORS=3
			--,ERRORFILE = 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\errors\ErrorFile.csv'
			,TABLOCK
		);
	-- DDL
	insert into food_calorie_conversion_factor(food_nutrient_conversion_factor_id, protein_value, fat_value, carbohydrate_value) -- UPDATE file name, and columns
		select 
			CAST(SUBSTRING(t.food_nutrient_conversion_factor_id, 2, LEN(t.food_nutrient_conversion_factor_id)-2) AS INT) AS food_nutrient_conversion_factor_id
			, CAST(REPLACE(t.protein_value, '"', '') AS FLOAT) AS protein_value
			, CAST(REPLACE(t.fat_value, '"', '') AS FLOAT) AS fat_value
			, CAST(SUBSTRING(t.carbohydrate_value, 2, LEN(t.carbohydrate_value)-3) AS FLOAT) AS carbohydrate_value
			--, CAST(SUBSTRING(t.NDB_number, 2, LEN(t.NDB_number)-3) AS INT) AS NDB_number
		from #tmp t
		WHERE NOT EXISTS ( -- skip duplicates
			SELECT 1 FROM food_calorie_conversion_factor AS d -- UPDATE NAME
			WHERE d.food_nutrient_conversion_factor_id = CAST(SUBSTRING(t.food_nutrient_conversion_factor_id, 2, LEN(t.food_nutrient_conversion_factor_id)-3) AS INT)
		)
	
	-- CHECKSUM
	SET @SQL = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @afterChecksum output;

	-- MIGRATION HISTORY
	INSERT INTO migrationHistory (MigrationName, MigrationStatus, ErrorMessage, ExecutionTimeMilliseconds, RollbackScript, ChecksumMigration, ChecksumTableBefore, ChecksumTableAfter, DatabaseVersionBefore, DatabaseVersionAfter)
								  VALUES(CONCAT(@migrationName, 'Table:', @tableName), 'applied', null, DATEDIFF(MILLISECOND,@startTime,GETDATE()), null, CHECKSUM((SELECT COUNT(*) FROM #tmp)), @beforeChecksum, @afterChecksum, '2021 Full', '2024 April Full')
	-- CLEANUP
	DROP TABLE IF EXISTS #tmp;
END TRY  
BEGIN CATCH
	-- MIGRATION HISTORY
	INSERT INTO migrationHistory (MigrationName, MigrationStatus, ErrorMessage, ExecutionTimeMilliseconds, RollbackScript, ChecksumMigration, ChecksumTableBefore, ChecksumTableAfter, DatabaseVersionBefore, DatabaseVersionAfter)
								  VALUES(CONCAT(@migrationName, 'Table:', @tableName), 'incomplete', CONCAT(CAST(ERROR_NUMBER() AS NVARCHAR(10)), ' - ',ERROR_MESSAGE()), DATEDIFF(MILLISECOND,@startTime,GETDATE()), null, CHECKSUM((SELECT COUNT(*) FROM #tmp)), @beforeChecksum, @afterChecksum, '2021 Full', '2024 April Full')
	PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
	-- CLEANUP
	DROP TABLE IF EXISTS #tmp;
END CATCH;  
GO  
