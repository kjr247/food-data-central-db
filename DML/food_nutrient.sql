USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[food_nutrient]    Script Date: 5/6/2024 5:49:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS food_nutrient;
CREATE TABLE [dbo].[food_nutrient](
	[id] [int] NOT NULL,
	[fdc_id] [int] NULL,
	[nutrient_id] [smallint] NULL,
	[amount] [float] NULL,
	[data_points] [smallint] NULL,
	[derivation_id] [int] NULL,
	[min] [float] NULL,
	[max] [float] NULL,
	[median] [float] NULL,
	[loq] VARCHAR(50) NULL,								-- NEW/UPDATED April 2024
	[footnote] VARCHAR(50) NULL,						-- NEW/UPDATED April 2024
	[min_year_acquired] [smallint] NULL,
	[percent_daily_value] VARCHAR(50) NULL,				-- NEW/UPDATED April 2024
	[SSMA_TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [food_nutrient$id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[fdc_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'fdc_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[nutrient_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'nutrient_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[amount]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'amount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[data_points]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'data_points'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[derivation_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'derivation_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[min]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'min'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[max]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'max'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[median]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'median'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[min_year_acquired]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'COLUMN',@level2name=N'min_year_acquired'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient].[id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient', @level2type=N'CONSTRAINT',@level2name=N'food_nutrient$id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_nutrient]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_nutrient'
GO


