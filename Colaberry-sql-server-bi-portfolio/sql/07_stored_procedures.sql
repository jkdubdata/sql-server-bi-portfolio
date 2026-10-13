/*
================================================================================
07_stored_procedures.sql
SQL Server & BI Portfolio — AdventureWorks Analytics Foundation
Target: SQL Server / Azure SQL
Purpose: Parameterized procedures for common analytical requests.
Ready for execution in SSMS or Azure SQL Query Editor.
================================================================================
*/

-- Procedure 1: Sales by territory for a given date range
IF OBJECT_ID('Sales.usp_SalesByTerritory', 'P') IS NOT NULL
    DROP PROCEDURE Sales.usp_SalesByTerritory;
GO

CREATE PROCEDURE Sales.usp_SalesByTerritory
    @StartDate DATE,
    @EndDate   DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        st.Name AS TerritoryName,
        st.[Group] AS TerritoryGroup,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalRevenue,
        AVG(soh.TotalDue) AS AvgOrderValue
    FROM Sales.SalesOrderHeader soh
    INNER JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
    WHERE soh.OrderDate >= @StartDate
      AND soh.OrderDate < DATEADD(DAY, 1, @EndDate)
    GROUP BY st.Name, st.[Group]
    ORDER BY TotalRevenue DESC;
END;
GO

-- Example:
-- EXEC Sales.usp_SalesByTerritory @StartDate = '2013-01-01', @EndDate = '2013-12-31';
-- GO

-- Procedure 2: Top N products by revenue in a date range
IF OBJECT_ID('Sales.usp_TopProductsByRevenue', 'P') IS NOT NULL
    DROP PROCEDURE Sales.usp_TopProductsByRevenue;
GO

CREATE PROCEDURE Sales.usp_TopProductsByRevenue
    @StartDate DATE,
    @EndDate   DATE,
    @TopN      INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopN)
        p.ProductID,
        p.Name AS ProductName,
        p.ProductNumber,
        SUM(sod.OrderQty) AS UnitsSold,
        SUM(sod.LineTotal) AS Revenue
    FROM Sales.SalesOrderHeader soh
    INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE soh.OrderDate >= @StartDate
      AND soh.OrderDate < DATEADD(DAY, 1, @EndDate)
    GROUP BY p.ProductID, p.Name, p.ProductNumber
    ORDER BY Revenue DESC;
END;
GO

-- Example:
-- EXEC Sales.usp_TopProductsByRevenue @StartDate = '2013-01-01', @EndDate = '2013-12-31', @TopN = 15;
-- GO

-- Procedure 3: Data-quality summary
IF OBJECT_ID('dbo.usp_DataQualitySummary', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_DataQualitySummary;
GO

CREATE PROCEDURE dbo.usp_DataQualitySummary
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CheckName, ViolationCount
    FROM (
        SELECT 'UnitPriceDiscount out of range [0,1]' AS CheckName,
               COUNT(*) AS ViolationCount
        FROM Sales.SalesOrderDetail
        WHERE UnitPriceDiscount < 0 OR UnitPriceDiscount > 1

        UNION ALL

        SELECT 'OrderQty <= 0', COUNT(*)
        FROM Sales.SalesOrderDetail
        WHERE OrderQty <= 0

        UNION ALL

        SELECT 'Orphan SalesOrderDetail', COUNT(*)
        FROM Sales.SalesOrderDetail sod
        LEFT JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
        WHERE soh.SalesOrderID IS NULL

        UNION ALL

        SELECT 'ShipDate < OrderDate', COUNT(*)
        FROM Sales.SalesOrderHeader
        WHERE ShipDate IS NOT NULL AND ShipDate < OrderDate

        UNION ALL

        SELECT 'DueDate < OrderDate', COUNT(*)
        FROM Sales.SalesOrderHeader
        WHERE DueDate < OrderDate
    ) q
    ORDER BY ViolationCount DESC;
END;
GO
