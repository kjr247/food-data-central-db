USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[market_acquisition]    Script Date: 4/30/2024 12:56:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--ALTER TABLE market_acquisition 
--ALTER COLUMN label_weight nvarchar(50) NULL;

DROP TABLE IF EXISTS market_acquisition;
CREATE TABLE [dbo].[market_acquisition](
	[fdc_id] [int] NOT NULL,
	[brand_description] [nvarchar](255) NULL,
	[expiration_date] [datetime2](0) NULL,
	[label_weight] nvarchar(50) NULL,
	[location] [nvarchar](255) NULL,
	[acquisition_date] [datetime2](0) NULL,
	[sales_type] [nvarchar](255) NULL,
	[sample_lot_nbr] [nvarchar](255) NULL,
	[sell_by_date] [datetime2](0) NULL,
	[store_city] [nvarchar](255) NULL,
	[store_name] [nvarchar](255) NULL,
	[store_state] [nvarchar](255) NULL,
	[upc_code] [nvarchar](255) NULL,
	[SSMA_TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [market_acquisition$fdc_id] PRIMARY KEY CLUSTERED 
(
	[fdc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[fdc_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'fdc_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[brand_description]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'brand_description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[expiration_date]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'expiration_date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[label_weight]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'label_weight'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[location]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'location'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[acquisition_date]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'acquisition_date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[sales_type]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'sales_type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[sample_lot_nbr]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'sample_lot_nbr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[sell_by_date]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'sell_by_date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[store_city]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'store_city'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[store_name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'store_name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[store_state]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'store_state'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[upc_code]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'COLUMN',@level2name=N'upc_code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition].[fdc_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition', @level2type=N'CONSTRAINT',@level2name=N'market_acquisition$fdc_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[market_acquisition]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'market_acquisition'
GO


