use FoodData_Central;
drop table if exists migrationHistory;
CREATE TABLE migrationHistory (
    MigrationId INT PRIMARY KEY IDENTITY(1,1),
    MigrationName NVARCHAR(255) NOT NULL,
    MigrationStatus NVARCHAR(20) NOT NULL,
    ErrorMessage NVARCHAR(MAX) NULL,
    AppliedDateTime DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),  
    ExecutionTimeMilliseconds INT,
    RollbackScript NVARCHAR(MAX) NULL,   
	ChecksumMigration NVARCHAR(64) NOT NULL,
    ChecksumTableBefore NVARCHAR(64) NOT NULL,
    ChecksumTableAfter NVARCHAR(64) NOT NULL,    
    DatabaseVersionBefore NVARCHAR(50) NOT NULL,
    DatabaseVersionAfter NVARCHAR(50) NOT NULL,
    --AppliedBy NVARCHAR(100) NOT NULL
    --AppliedOnHost NVARCHAR(255) NOT NULL,
    --AppliedOnInstance NVARCHAR(255) NOT NULL,
    --AppliedOnDatabase NVARCHAR(255) NOT NULL,
    CONSTRAINT CK_Status CHECK (MigrationStatus IN ('Applied', 'RolledBack', 'Incomplete'))
);


EXEC sys.sp_updateextendedproperty 
    @name = N'MS_Description', @value='Differentiates between applied and rolled back migrations. A check constraint ensures only valid statuses are allowed.',
    @level0type = N'Schema', @level0name = 'dbo', 
    @level1type = N'Table',  @level1name = 'migrationHistory',
@level2type = N'Column', @level2name = 'MigrationStatus';

EXEC sys.sp_updateextendedproperty 
    @name = N'MS_Description', @value = 'Stores a hash/count value of the migration script itself. This helps in detecting any changes to the migration script content, ensuring its integrity. Stores a checksum value calculated based on the migration script content. This checksum helps ensure that the migration script has not been tampered with between application and rollback. It can also help in identifying any discrepancies between applied and expected migrations.',
    @level0type = N'Schema', @level0name = 'dbo', 
    @level1type = N'Table',  @level1name = 'migrationHistory',
    @level2type = N'Column', @level2name = 'ChecksumMigration';

EXEC sys.sp_updateextendedproperty 
    @name = N'MS_Description', @value = 'Stores a hash/count value of the table before the migration. This helps in detecting any changes to the table, ensuring its integrity. Stores a checksum value calculated based on the table content. This checksum helps ensure that the table has not been tampered with between application and rollback. It can also help in identifying any discrepancies between applied and expected migrations.',
    @level0type = N'Schema', @level0name = 'dbo', 
    @level1type = N'Table',  @level1name = 'migrationHistory',
    @level2type = N'Column', @level2name = 'ChecksumTableBefore';

EXEC sys.sp_updateextendedproperty 
    @name = N'MS_Description', @value = 'Stores a hash/count value of the table after the migration. This helps in detecting any changes to the table, ensuring its integrity. Stores a checksum value calculated based on the table content. This checksum helps ensure that the table has not been tampered with between application and rollback. It can also help in identifying any discrepancies between applied and expected migrations.',
    @level0type = N'Schema', @level0name = 'dbo', 
    @level1type = N'Table',  @level1name = 'migrationHistory',
    @level2type = N'Column', @level2name = 'DatabaseVersionAfter';