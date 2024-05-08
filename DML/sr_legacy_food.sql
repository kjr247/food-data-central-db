USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[sr_legacy_food]    Script Date: 4/29/2024 2:09:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS [dbo].[sr_legacy_food];
CREATE TABLE [dbo].[sr_legacy_food](
	[fdc_id] [int] NOT NULL,
	[NDB_number] [int] NULL,
 CONSTRAINT [sr_legacy_food$fdc_id] PRIMARY KEY CLUSTERED 
(
	[fdc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sr_legacy_food].[fdc_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sr_legacy_food', @level2type=N'COLUMN',@level2name=N'fdc_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sr_legacy_food].[NDB_number]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sr_legacy_food', @level2type=N'COLUMN',@level2name=N'NDB_number'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sr_legacy_food].[fdc_id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sr_legacy_food', @level2type=N'CONSTRAINT',@level2name=N'sr_legacy_food$fdc_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[sr_legacy_food]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sr_legacy_food'
GO


