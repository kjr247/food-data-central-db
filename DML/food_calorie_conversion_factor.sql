USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[food_calorie_conversion_factor]    Script Date: 4/29/2024 2:29:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS food_calorie_conversion_factor;
CREATE TABLE [dbo].[food_calorie_conversion_factor](
	[food_nutrient_conversion_factor_id] [int] NOT NULL,
	[protein_value] [float] NULL,
	[fat_value] [float] NULL,
	[carbohydrate_value] [float] NULL,
	[SSMA_TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [food_calorie_conversion_factor$food_nutrient_conversion_factor_id] PRIMARY KEY CLUSTERED 
(
	[food_nutrient_conversion_factor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_calorie_conversion_factor].[food_nutrient_conversion_factor_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_calorie_conversion_factor', @level2type=N'COLUMN',@level2name=N'food_nutrient_conversion_factor_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_calorie_conversion_factor].[protein_value]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_calorie_conversion_factor', @level2type=N'COLUMN',@level2name=N'protein_value'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_calorie_conversion_factor].[fat_value]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_calorie_conversion_factor', @level2type=N'COLUMN',@level2name=N'fat_value'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_calorie_conversion_factor].[carbohydrate_value]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_calorie_conversion_factor', @level2type=N'COLUMN',@level2name=N'carbohydrate_value'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_calorie_conversion_factor].[food_nutrient_conversion_factor_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_calorie_conversion_factor', @level2type=N'CONSTRAINT',@level2name=N'food_calorie_conversion_factor$food_nutrient_conversion_factor_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_calorie_conversion_factor]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_calorie_conversion_factor'
GO

