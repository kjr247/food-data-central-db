USE [FoodData_Central]
GO

/****** Object:  Table [dbo].[nutrient]    Script Date: 4/29/2024 2:13:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
drop table if exists nutrient;
CREATE TABLE [dbo].[nutrient](
	[id] [int] NOT NULL,
	[name] [nvarchar](255) NULL,
	[unit_name] [nvarchar](255) NULL,
	[nutrient_nbr] [float] NULL,
	[rank] [float] NULL,
	[SSMA_TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [nutrient$id] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[nutrient].[id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'nutrient', @level2type=N'COLUMN',@level2name=N'id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[nutrient].[name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'nutrient', @level2type=N'COLUMN',@level2name=N'name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[nutrient].[unit_name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'nutrient', @level2type=N'COLUMN',@level2name=N'unit_name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[nutrient].[nutrient_nbr]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'nutrient', @level2type=N'COLUMN',@level2name=N'nutrient_nbr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[nutrient].[rank]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'nutrient', @level2type=N'COLUMN',@level2name=N'rank'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[nutrient].[id]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'nutrient', @level2type=N'CONSTRAINT',@level2name=N'nutrient$id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FoodData_Central_access.[nutrient]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'nutrient'
GO


