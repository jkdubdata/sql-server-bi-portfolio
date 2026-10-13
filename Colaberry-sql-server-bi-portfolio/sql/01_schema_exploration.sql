/*
================================================================================
01_schema_exploration.sql
SQL Server & BI Portfolio — AdventureWorks Analytics Foundation
Target: SQL Server / Azure SQL
Purpose: Discover schemas, tables, columns, and relationships.
Ready for execution in SSMS or Azure SQL Query Editor.
================================================================================
*/

-- List all user schemas
SELECT s.name AS SchemaName,
       s.schema_id
FROM sys.schemas s
WHERE s.name NOT IN ('sys', 'INFORMATION_SCHEMA', 'guest', 'db_owner', 'db_accessadmin',
                     'db_securityadmin', 'db_ddladmin', 'db_backupoperator',
                     'db_datareader', 'db_datawriter', 'db_denydatareader', 'db_denydatawriter')
ORDER BY s.name;
GO

-- Tables in the main business schemas
SELECT t.TABLE_SCHEMA,
       t.TABLE_NAME,
       t.TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES t
WHERE t.TABLE_SCHEMA IN ('Sales', 'Person', 'Production', 'HumanResources', 'Purchasing')
ORDER BY t.TABLE_SCHEMA, t.TABLE_NAME;
GO

-- Column inventory for key Sales tables
SELECT c.TABLE_SCHEMA,
       c.TABLE_NAME,
       c.COLUMN_NAME,
       c.DATA_TYPE,
       c.CHARACTER_MAXIMUM_LENGTH,
       c.IS_NULLABLE,
       c.COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_SCHEMA = 'Sales'
  AND c.TABLE_NAME IN ('SalesOrderHeader', 'SalesOrderDetail', 'Customer', 'SalesPerson', 'SalesTerritory')
ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION;
GO

-- Primary key and foreign key overview (Sales schema)
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) AS ParentSchema,
    OBJECT_NAME(fk.parent_object_id) AS ParentTable,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ParentColumn,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS ReferencedSchema,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumn
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc 
    ON fk.object_id = fkc.constraint_object_id
WHERE OBJECT_SCHEMA_NAME(fk.parent_object_id) = 'Sales'
ORDER BY ParentTable, ForeignKeyName;
GO

-- Approximate row counts for major tables
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    SUM(p.rows) AS ApproximateRowCount
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
  AND SCHEMA_NAME(t.schema_id) IN ('Sales', 'Production', 'Person')
GROUP BY t.schema_id, t.name
ORDER BY ApproximateRowCount DESC;
GO
