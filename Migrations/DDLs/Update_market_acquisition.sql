use FoodData_Central;
declare @beforeChecksum int = 0;
declare @afterChecksum int = 0;
declare @migrationName Nvarchar(40) = N'2024 April Full from 2021 - ';	
declare @pathToInputFolder Nvarchar(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
declare @tableName Nvarchar(40);
declare @startTime datetime2 = GETDATE();

BEGIN TRY  
	set @tableName = 'market_acquisition';

	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;

	TRUNCATE TABLE market_acquisition;
	-- Mapping
	DROP TABLE IF EXISTS #tmp;
	create table #tmp( 
	fdc_id nvarchar(MAX) NOT NULL,
	brand_description nvarchar(MAX) NULL,
	expiration_date nvarchar(MAX) NULL,
	label_weight nvarchar(MAX) NULL,
	location nvarchar(MAX) NULL,
	acquisition_date nvarchar(MAX) NULL,
	sales_type nvarchar(MAX) NULL,
	sample_lot_nbr nvarchar(MAX) NULL,
	sell_by_date nvarchar(MAX) NULL,
	store_city nvarchar(MAX) NULL,
	store_name nvarchar(MAX) NULL,
	store_state nvarchar(MAX) NULL,
	upc_code nvarchar(MAX) NULL)

	bulk insert #tmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\market_acquisition.csv' -- update file name, (!sometimes the file names are different <crosses eyes>)
	WITH
		(
			CODEPAGE = '65001'
			,FIRSTROW = 2
			,FIELDTERMINATOR = '\",'
			,ROWTERMINATOR = '0x0A'   --Use to shift the control to next row
			,batchsize=10
			--,FORMATFILE='C:\Users\kjr24\source\repos\MineralMateAPI\Scripts\FormatFiles\level_2.fmt'
			--,MAXERRORS=3
			--,ERRORFILE = 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\errors\ErrorFile.csv'
			,TABLOCK
		);
	-- DDL
	insert into market_acquisition(fdc_id, brand_description, expiration_date, label_weight, location, acquisition_date, sales_type, sample_lot_nbr, sell_by_date, store_city, store_name, store_state, upc_code) -- UPDATE file name, and columns
		select
			CAST(REPLACE(t.fdc_id,'"','') AS INT) AS fdc_id
			, REPLACE(t.brand_description,'"','') AS brand_description
			, CONVERT(varchar(10), REPLACE(t.expiration_date, '"', '') ,101) AS expiration_date
			, REPLACE(t.label_weight,'"','') AS label_weight
			, REPLACE(t.location,'"','') AS location
			, CONVERT(varchar(10), REPLACE(t.acquisition_date, '"', '') ,101) AS acquisition_date
			, REPLACE(t.sales_type,'"','') AS sales_type
			, REPLACE(t.sample_lot_nbr,'"','') AS sample_lot_nbr
			, CONVERT(varchar(10), REPLACE(t.sell_by_date, '"', '') ,101) AS sell_by_date
			, REPLACE(t.store_city,'"','') AS store_city
			, REPLACE(t.store_name,'"','') AS store_name
			, REPLACE(t.store_state,'"','') AS store_state
			, REPLACE(t.upc_code,'"','') AS upc_code			
		from #tmp t
		WHERE NOT EXISTS ( -- skip duplicates
			SELECT 1 FROM market_acquisition AS d --UPDATE
			WHERE d.fdc_id = CAST(REPLACE(t.fdc_id,'"','') AS INT)
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