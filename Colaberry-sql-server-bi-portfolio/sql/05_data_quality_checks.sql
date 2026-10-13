/*
================================================================================
05_data_quality_checks.sql
SQL Server & BI Portfolio — AdventureWorks Analytics Foundation
Target: SQL Server / Azure SQL
Purpose: Data-quality and business-rule checks.
Ready for execution in SSMS or Azure SQL Query Editor.
================================================================================
*/

-- 1. Discount percentage must be between 0 and 1
SELECT 
    'UnitPriceDiscount out of range [0,1]' AS CheckName,
    COUNT(*) AS ViolationCount
FROM Sales.SalesOrderDetail
WHERE UnitPriceDiscount < 0 OR UnitPriceDiscount > 1;
GO

SELECT TOP 20
    SalesOrderID,
    SalesOrderDetailID,
    UnitPrice,
    UnitPriceDiscount,
    OrderQty,
    LineTotal
FROM Sales.SalesOrderDetail
WHERE UnitPriceDiscount < 0 OR UnitPriceDiscount > 1
ORDER BY UnitPriceDiscount;
GO

-- 2. Order quantity must be positive
SELECT 
    'OrderQty <= 0' AS CheckName,
    COUNT(*) AS ViolationCount
FROM Sales.SalesOrderDetail
WHERE OrderQty <= 0;
GO

-- 3. Orphan order details
SELECT 
    'Orphan SalesOrderDetail (no header)' AS CheckName,
    COUNT(*) AS ViolationCount
FROM Sales.SalesOrderDetail sod
LEFT JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.SalesOrderID IS NULL;
GO

-- 4. ShipDate should not precede OrderDate
SELECT 
    'ShipDate < OrderDate' AS CheckName,
    COUNT(*) AS ViolationCount
FROM Sales.SalesOrderHeader
WHERE ShipDate IS NOT NULL 
  AND ShipDate < OrderDate;
GO

-- 5. DueDate should not precede OrderDate
SELECT 
    'DueDate < OrderDate' AS CheckName,
    COUNT(*) AS ViolationCount
FROM Sales.SalesOrderHeader
WHERE DueDate < OrderDate;
GO

-- 6. Products with ListPrice < StandardCost
SELECT 
    'ListPrice < StandardCost' AS CheckName,
    COUNT(*) AS ViolationCount
FROM Production.Product
WHERE ListPrice < StandardCost
  AND FinishedGoodsFlag = 1;
GO

-- 7. Summary quality dashboard
SELECT CheckName, ViolationCount
FROM (
    SELECT 'UnitPriceDiscount out of range [0,1]' AS CheckName,
           COUNT(*) AS ViolationCount
    FROM Sales.SalesOrderDetail
    WHERE UnitPriceDiscount < 0 OR UnitPriceDiscount > 1

    UNION ALL

    SELECT 'OrderQty <= 0',
           COUNT(*)
    FROM Sales.SalesOrderDetail
    WHERE OrderQty <= 0

    UNION ALL

    SELECT 'Orphan SalesOrderDetail',
           COUNT(*)
    FROM Sales.SalesOrderDetail sod
    LEFT JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    WHERE soh.SalesOrderID IS NULL

    UNION ALL

    SELECT 'ShipDate < OrderDate',
           COUNT(*)
    FROM Sales.SalesOrderHeader
    WHERE ShipDate IS NOT NULL AND ShipDate < OrderDate

    UNION ALL

    SELECT 'DueDate < OrderDate',
           COUNT(*)
    FROM Sales.SalesOrderHeader
    WHERE DueDate < OrderDate

    UNION ALL

    SELECT 'ListPrice < StandardCost (FinishedGoods)',
           COUNT(*)
    FROM Production.Product
    WHERE ListPrice < StandardCost AND FinishedGoodsFlag = 1
) q
ORDER BY ViolationCount DESC;
GO
