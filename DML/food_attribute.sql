USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[food_attribute]    Script Date: 5/1/2024 2:24:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS food_attribute;
CREATE TABLE [dbo].[food_attribute](
	[id] [int] NOT NULL,
	[fdc_id] [int] NULL,
	[seq_num] [smallint] NULL,
	[food_attribute_type_id] [int] NULL,
	[name] [nvarchar](255) NULL,
	[value] [nvarchar](300) NULL, -- UPDATED
 CONSTRAINT [food_attribute$id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_attribute].[id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_attribute', @level2type=N'COLUMN',@level2name=N'id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_attribute].[fdc_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_attribute', @level2type=N'COLUMN',@level2name=N'fdc_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_attribute].[seq_num]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_attribute', @level2type=N'COLUMN',@level2name=N'seq_num'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_attribute].[food_attribute_type_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_attribute', @level2type=N'COLUMN',@level2name=N'food_attribute_type_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_attribute].[name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_attribute', @level2type=N'COLUMN',@level2name=N'name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_attribute].[value]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_attribute', @level2type=N'COLUMN',@level2name=N'value'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_attribute].[id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_attribute', @level2type=N'CONSTRAINT',@level2name=N'food_attribute$id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[food_attribute]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'food_attribute'
GO


