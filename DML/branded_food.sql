USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[branded_food]    Script Date: 5/3/2024 2:01:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS [branded_food];
CREATE TABLE [dbo].[branded_food](
	[fdc_id] [int] NOT NULL,
	[brand_owner] [nvarchar](255) NULL,
	[brand_name] [nvarchar](255) NULL,
	[subbrand_name] [nvarchar](255) NULL,
	[gtin_upc] [nvarchar](255) NULL,
	[ingredients] [nvarchar](max) NULL,
	[not_a_significant_source_of] [nvarchar](max) NULL,
	[serving_size] [float] NULL,
	[serving_size_unit] [nvarchar](255) NULL,
	[household_serving_fulltext] [nvarchar](255) NULL,
	[branded_food_category] [nvarchar](MAX) NULL, -- UPDATED
	[data_source] [nvarchar](255) NULL,
	package_weight nvarchar(MAX) NULL,			  -- NEW/UPDATED
	[modified_date] [datetime2](0) NULL,
	[available_date] [datetime2](0) NULL,
	[market_country] [nvarchar](255) NULL,
	[discontinued_date] [datetime2](0) NULL,
	[preparation_state_code] nvarchar(MAX) NULL,  -- NEW/UPDATED
	[trade_channel] nvarchar(MAX) NULL,		      -- NEW/UPDATED
	[short_description] nvarchar(MAX) NULL,		  -- NEW/UPDATED
	[SSMA_TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [branded_food$fdc_id] PRIMARY KEY CLUSTERED 
(
	[fdc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[fdc_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'fdc_id'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[brand_owner]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'brand_owner'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[brand_name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'brand_name'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[subbrand_name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'subbrand_name'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[gtin_upc]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'gtin_upc'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[ingredients]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'ingredients'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[not_a_significant_source_of]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'not_a_significant_source_of'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[serving_size]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'serving_size'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[serving_size_unit]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'serving_size_unit'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[household_serving_fulltext]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'household_serving_fulltext'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[branded_food_category]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'branded_food_category'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[data_source]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'data_source'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[modified_date]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'modified_date'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[available_date]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'available_date'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[market_country]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'market_country'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[discontinued_date]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'COLUMN',@level2name=N'discontinued_date'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food].[fdc_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food', @level2type=N'CONSTRAINT',@level2name=N'branded_food$fdc_id'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[branded_food]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branded_food'
--GO


