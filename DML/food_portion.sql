USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[food_portion]    Script Date: 4/30/2024 9:44:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[food_portion](
	[id] [int] NOT NULL,
	[fdc_id] [int] NULL,
	[seq_num] [int] NULL,
	[amount] [float] NULL,
	[measure_unit_id] [int] NULL,
	[portion_description] [nvarchar](255) NULL,
	[modifier] [nvarchar](255) NULL,
	[gram_weight] [float] NULL,
	[data_points] [int] NULL,
	[footnote] [nvarchar](255) NULL,
	[min_year_acquired] [int] NULL,
	[SSMA_TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [food_portion$id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[fdc_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'fdc_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[seq_num]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'seq_num'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[amount]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'amount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[measure_unit_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'measure_unit_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[portion_description]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'portion_description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[modifier]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'modifier'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[gram_weight]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'gram_weight'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[data_points]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'data_points'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[footnote]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'footnote'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[min_year_acquired]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'COLUMN',@level2name=N'min_year_acquired'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion].[id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion', @level2type=N'CONSTRAINT',@level2name=N'food_portion$id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_portion]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_portion'
GO


