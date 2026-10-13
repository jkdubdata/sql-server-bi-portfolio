/*
================================================================================
02_basic_queries.sql
SQL Server & BI Portfolio — AdventureWorks Analytics Foundation
Target: SQL Server / Azure SQL
Purpose: Core filtering, aggregation, sorting, and simple calculations.
Ready for execution in SSMS or Azure SQL Query Editor.
================================================================================
*/

-- 1. Recent orders
SELECT TOP 20
    soh.SalesOrderID,
    soh.OrderDate,
    soh.CustomerID,
    soh.TotalDue,
    soh.OnlineOrderFlag
FROM Sales.SalesOrderHeader soh
WHERE soh.OrderDate >= '2013-01-01'
ORDER BY soh.OrderDate DESC, soh.TotalDue DESC;
GO

-- 2. Monthly order volume and revenue
SELECT 
    YEAR(soh.OrderDate) AS OrderYear,
    MONTH(soh.OrderDate) AS OrderMonth,
    COUNT(*) AS OrderCount,
    SUM(soh.TotalDue) AS TotalRevenue,
    AVG(soh.TotalDue) AS AvgOrderValue
FROM Sales.SalesOrderHeader soh
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
ORDER BY OrderYear, OrderMonth;
GO

-- 3. High-value months only
SELECT 
    YEAR(soh.OrderDate) AS OrderYear,
    MONTH(soh.OrderDate) AS OrderMonth,
    COUNT(*) AS OrderCount,
    SUM(soh.TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader soh
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
HAVING SUM(soh.TotalDue) > 500000
ORDER BY TotalRevenue DESC;
GO

-- 4. Online vs offline mix
SELECT 
    soh.OnlineOrderFlag,
    COUNT(*) AS OrderCount,
    SUM(soh.TotalDue) AS TotalRevenue,
    CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS PctOfOrders
FROM Sales.SalesOrderHeader soh
GROUP BY soh.OnlineOrderFlag;
GO

-- 5. Discount impact on order lines
SELECT TOP 50
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal,
    sod.OrderQty * sod.UnitPrice AS GrossBeforeDiscount,
    sod.OrderQty * sod.UnitPrice * sod.UnitPriceDiscount AS DiscountAmount
FROM Sales.SalesOrderDetail sod
WHERE sod.UnitPriceDiscount > 0
ORDER BY DiscountAmount DESC;
GO
