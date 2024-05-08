USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[fndds_ingredient_nutrient_value]    Script Date: 5/1/2024 1:32:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[fndds_ingredient_nutrient_value](
	[ingredient code] [int] NULL,
	[Ingredient description] [nvarchar](max) NULL,
	[Nutrient code] [int] NULL,
	[Nutrient value] [float] NULL,
	[Nutrient value source] [nvarchar](max) NULL,
	[FDC ID] [int] NULL,
	[Derivation code] [nvarchar](255) NULL,
	[SR AddMod year] [int] NULL,
	[Foundation year acquired] [int] NULL,
	[Start date] [datetime2](0) NULL,
	[End date] [datetime2](0) NULL,
	[SSMA_TimeStamp] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[ingredient code]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'ingredient code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[Ingredient description]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'Ingredient description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[Nutrient code]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'Nutrient code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[Nutrient value]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'Nutrient value'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[Nutrient value source]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'Nutrient value source'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[FDC ID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'FDC ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[Derivation code]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'Derivation code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[SR AddMod year]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'SR AddMod year'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[Foundation year acquired]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'Foundation year acquired'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[Start date]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'Start date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value].[End date]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value', @level2type=N'COLUMN',@level2name=N'End date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[fndds_ingredient_nutrient_value]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'fndds_ingredient_nutrient_value'
GO


