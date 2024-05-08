USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[sub_sample_result]    Script Date: 5/1/2024 1:16:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[sub_sample_result](
	[food_nutrient_id] [int] NOT NULL,
	[adjusted_amount] [float] NULL,
	[lab_method_id] [smallint] NULL,
	[nutrient_name] [nvarchar](255) NULL,
	[SSMA_TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [sub_sample_result$food_nutrient_id] PRIMARY KEY CLUSTERED 
(
	[food_nutrient_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sub_sample_result].[food_nutrient_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sub_sample_result', @level2type=N'COLUMN',@level2name=N'food_nutrient_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sub_sample_result].[adjusted_amount]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sub_sample_result', @level2type=N'COLUMN',@level2name=N'adjusted_amount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sub_sample_result].[lab_method_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sub_sample_result', @level2type=N'COLUMN',@level2name=N'lab_method_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sub_sample_result].[nutrient_name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sub_sample_result', @level2type=N'COLUMN',@level2name=N'nutrient_name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sub_sample_result].[food_nutrient_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sub_sample_result', @level2type=N'CONSTRAINT',@level2name=N'sub_sample_result$food_nutrient_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sub_sample_result]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sub_sample_result'
GO


