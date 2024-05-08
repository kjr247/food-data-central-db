use FoodData_Central;
declare @beforeChecksum int = 0;
declare @afterChecksum int = 0;
declare @migrationName Nvarchar(40) = N'2024 April Full from 2021 - ';	
declare @pathToInputFolder Nvarchar(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
declare @tableName Nvarchar(40);
declare @startTime datetime2 = GETDATE();

BEGIN TRY  
	set @tableName = 'food_component';

	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;
	
	TRUNCATE TABLE food_component;

	DROP TABLE IF EXISTS #tmp; 
	-- Mapping
	create table #tmp(id VARCHAR(MAX) NOT NULL, fdc_id VARCHAR(MAX) NULL, name VARCHAR(MAX) NULL, pct_weight VARCHAR(MAX) NULL, is_refuse VARCHAR(MAX) NULL, gram_weight VARCHAR(MAX) NULL, data_points VARCHAR(MAX) NULL, min_year_acquired VARCHAR(MAX) NULL) 	

	bulk insert #tmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\food_component.csv' -- UPDATE FILE name, (!sometimes the file names are different <crosses eyes>)
	WITH
		(
			CODEPAGE = '65001'
			,FIRSTROW = 2
			,FIELDTERMINATOR = '\",'
			,ROWTERMINATOR = '0x0A'
			,batchsize=10
			--,MAXERRORS=3
			--,ERRORFILE = 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\errors\ErrorFile.csv'
			,TABLOCK
		);
	-- DDL
	insert into food_component(id, fdc_id, name, pct_weight, is_refuse, gram_weight, data_points, min_year_acquired) -- UPDATE file name, and columns
		select 
			 CAST(REPLACE(t.id, '"', '') AS INT) AS id
			, CAST(REPLACE(t.fdc_id, '"', '') AS INT) AS fdc_id
			, REPLACE(t.name, '"', '') AS name
			--, REPLACE(t.pct_weight, '"', '') AS pct_weight
			, CASE WHEN REPLACE(t.pct_weight, '"', '') <> '' 
					THEN CAST(REPLACE(t.pct_weight, '"', '') AS DECIMAL(4,1))
					ELSE null 
			  END AS pct_weight
			, REPLACE(t.is_refuse, '"', '') AS is_refuse
			, CASE WHEN REPLACE(t.gram_weight, '"', '') <> '' 
					THEN CAST(REPLACE(t.gram_weight, '"', '') AS DECIMAL(6,1))
					ELSE null 
			  END AS gram_weight
			, CAST(REPLACE(t.data_points, '"', '') AS SMALLINT) AS data_points
			--,  REPLACE(t.min_year_acquired, '"', '')
			--, COALESCE(CAST(REPLACE(t.min_year_acquired, '"', '') AS INT), NULLIF(REPLACE(t.min_year_acquired, '"', ''), ''))
			, CASE WHEN LEN(REPLACE(t.min_year_acquired, '"', '')) > 3 
					THEN CAST(substring(t.min_year_acquired,2,len(t.min_year_acquired)-3) AS INT)
					ELSE null 
			  END AS min_year_acquired
		from #tmp t
		WHERE NOT EXISTS ( -- skip duplicates
			SELECT 1 FROM food_component AS d -- UPDATE NAME
			WHERE d.fdc_id = CAST(substring(t.fdc_id,2,len(t.fdc_id)-3) AS INT)
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
