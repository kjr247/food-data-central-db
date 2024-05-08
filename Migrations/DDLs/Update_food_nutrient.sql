USE FoodData_Central;
DECLARE @beforeChecksum INT = 0;
DECLARE @afterChecksum INT = 0;
DECLARE @migrationName NVARCHAR(40) = N'2024 April Full from 2021 - ';	
DECLARE @pathToInputFolder NVARCHAR(40) = N'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\';
DECLARE @tableName Nvarchar(40);
DECLARE @startTime DATETIME2 = GETDATE();

BEGIN TRY  
	set @tableName = 'food_nutrient';
	
	-- CHECKSUM
	DECLARE @SQL NVARCHAR(MAX) = 'SELECT @ResultVariable = count(*) FROM ' + @tableName;
	EXEC sp_executesql @SQL, N'@ResultVariable INT OUTPUT', @ResultVariable = @beforeChecksum output;

	--TRUNCATE TABLE food_nutrient; --only truncated the first time and then use fetch next to get through the data, solving problem data along the way
	-- Mapping
	DROP TABLE IF EXISTS #preReadtmp;
	create table #preReadtmp(
		[id] NVARCHAR(255) NOT NULL,
		[fdc_id] NVARCHAR(255) NULL,
		[nutrient_id] NVARCHAR(255) NULL,
		[amount] NVARCHAR(255) NULL,
		[data_points] NVARCHAR(255) NULL,
		[derivation_id] NVARCHAR(255) NULL,
		[min] NVARCHAR(255) NULL,
		[max] NVARCHAR(255) NULL,
		[median] NVARCHAR(255) NULL,
		[loq] varchar(50) null, 				-- NEW/UPDATED April 2024
		[footnote] varchar(50) null,			-- NEW/UPDATED April 2024
		[min_year_acquired] NVARCHAR(255) NULL,
		[percent_daily_value] NVARCHAR(50) null	-- NEW/UPDATED April 2024
	)

	DROP TABLE IF EXISTS #tmp;
	create table #tmp(
		[id] [int] IDENTITY NOT NULL,
		[fdc_id] NVARCHAR(255) NULL,
		[nutrient_id] NVARCHAR(255) NULL,
		[amount] NVARCHAR(255) NULL,
		[data_points] NVARCHAR(255) NULL,
		[derivation_id] NVARCHAR(255) NULL,
		[min] NVARCHAR(255) NULL,
		[max] NVARCHAR(255) NULL,
		[median] NVARCHAR(255) NULL,
		[loq] NVARCHAR(50) null, 				-- NEW/UPDATED April 2024
		[footnote] NVARCHAR(50) null,			-- NEW/UPDATED April 2024
		[min_year_acquired] NVARCHAR(255) NULL,
		[percent_daily_value] NVarchar(50) null	-- NEW/UPDATED April 2024
	)
	CREATE CLUSTERED INDEX ix_tempCIndextmp ON #tmp ([fdc_id]);

	bulk insert #preReadtmp
	From 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\food_nutrient.csv' -- update file name, (!sometimes the file names are different <crosses eyes>)
	WITH
		(
			CODEPAGE = '65001'
			, FIRSTROW = 2
			, FIELDTERMINATOR = '\",\"'
			, ROWTERMINATOR = '0x0A'   --Use to shift the control to next row
			, batchsize=500000
			--, FORMATFILE='C:\Users\kjr24\source\repos\MineralMateAPI\Scripts\FormatFiles\level_2.fmt'
			, MAXERRORS=1000
			--, ERRORFILE = 'C:\Users\kjr24\Downloads\FoodData_Central_csv_2024-04-18\FoodData_Central_csv_2024-04-18\errors\ErrorFile.csv'
			, TABLOCK
		);

	SET IDENTITY_INSERT #tmp ON;
	INSERT INTO #tmp([id], [fdc_id], [nutrient_id], [amount], [data_points], [derivation_id], [min], [max], [median], [loq], [footnote], [min_year_acquired], [percent_daily_value])
		SELECT 
			 CAST(REPLACE(P.id,'"','') AS INT) AS id
			, [fdc_id], [nutrient_id], [amount], [data_points], [derivation_id], [min], [max], [median], [loq], [footnote], [min_year_acquired], [percent_daily_value]
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

	WHILE @i < 530 
	BEGIN
		SET @i = @i + 1

		insert into food_nutrient([id], [fdc_id], [nutrient_id], [amount], [data_points], [derivation_id], [min], [max], [median], [loq], [footnote], [min_year_acquired], [percent_daily_value]) -- UPDATE file name, and columns
			select [id], [fdc_id], [nutrient_id], [amount], [data_points], [derivation_id], [min], [max], [median], [loq], [footnote], [min_year_acquired], [percent_daily_value]
				from (select id
							, CAST(fdc_id AS INT) AS fdc_id
							, CAST(nutrient_id AS SMALLINT) AS nutrient_id
							, CAST(amount AS FLOAT) AS amount
							, CAST(data_points AS SMALLINT) AS data_points
							, CAST([derivation_id] AS INT) AS [derivation_id]
							, CAST([min] AS FLOAT) AS [min]
							, CAST([max] AS FLOAT) AS [max]
							, CAST(median AS FLOAT) AS median
							, loq
							, footnote
							, CAST(min_year_acquired AS SMALLINT) AS min_year_acquired
							, CAST(REPLACE(REPLACE(t.percent_daily_value, '"', ''))), CHAR(13), '') AS decimal(23,18)) AS percent_daily_value
							--, brand_owner
							--, brand_name
							--, subbrand_name
							--, gtin_upc
							--, ingredients
							--, not_a_significant_source_of
							--, CAST(t.serving_size AS FLOAT) AS serving_size
							--, serving_size_unit
							--, household_serving_fulltext
							--, food_nutrient_category
							--, data_source
							--, CAST(REPLACE(t.modified_date, '"', '') AS DATETIME2) AS modified_date
							--, CAST(REPLACE(t.available_date, '"', '') AS DATETIME2) AS available_date
							--, market_country
							--, CAST(REPLACE(t.discontinued_date, '"', '') AS DATETIME2) AS discontinued_date
							--, preparation_state_code
							--, trade_channel
							--, RTRIM(LTRIM(REPLACE(t.short_description, '"', ''))) AS short_description
						from #tmp t
						ORDER BY id DESC

						OFFSET @offsetCount - 1 ROWS 
						FETCH NEXT @nextCount  - @offsetCount + 1 ROWS ONLY
					) AS a
			
			WHERE NOT EXISTS ( -- skip duplicates
				SELECT 1 FROM food_nutrient AS d --UPDATE
				WHERE d.id = a.id
			) -- AND CAST(REPLACE(t.fdc_id,'"','') AS INT) != 501930 -- ignore bad data
			ORDER BY id DESC
			OPTION ( OPTIMIZE FOR (@offsetCount = 1, @nextCount = 2000000) ); 

		-- DISCOVER WHICH RECORDS HAVE NOT BEEN ADDED YET - PERHAPS PROBLEM DATA THAT ERRORS
		--SELECT * from #tmp t
		--WHERE NOT EXISTS ( -- skip duplicates
		--	SELECT 1 FROM food_nutrient AS d --UPDATE
		--	WHERE d.fdc_id = CAST(REPLACE(t.fdc_id,'"','') AS INT)
		--)
		--ORDER BY modified_date desc --ORDER BY len(value) desc -- for example the length of data may exceed 255

		PRINT CONCAT('OFFSET', @offsetCount);
		set @offsetCount = @offsetCount + 50000;
		PRINT CONCAT('NEXT', @nextCount);
		set @nextCount = @nextCount + 50000;
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
			,@msgtext  = N'Incomplete Migration, - #tmp (%d), and @afterChecksum (%d).'  
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
