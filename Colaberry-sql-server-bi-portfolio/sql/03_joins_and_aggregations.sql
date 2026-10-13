/*
================================================================================
03_joins_and_aggregations.sql
SQL Server & BI Portfolio — AdventureWorks Analytics Foundation
Target: SQL Server / Azure SQL
Purpose: Multi-table joins, product/customer context, territory performance.
Ready for execution in SSMS or Azure SQL Query Editor.
================================================================================
*/

-- 1. Order lines with product and category
SELECT TOP 100
    soh.SalesOrderID,
    soh.OrderDate,
    p.Name AS ProductName,
    p.ProductNumber,
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal,
    pc.Name AS CategoryName
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod 
    ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product p 
    ON sod.ProductID = p.ProductID
LEFT JOIN Production.ProductSubcategory psc 
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc 
    ON psc.ProductCategoryID = pc.ProductCategoryID
ORDER BY soh.OrderDate DESC, sod.LineTotal DESC;
GO

-- 2. Territory performance
SELECT 
    st.Name AS TerritoryName,
    st.[Group] AS TerritoryGroup,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS TotalRevenue,
    AVG(soh.TotalDue) AS AvgOrderValue
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesTerritory st 
    ON soh.TerritoryID = st.TerritoryID
GROUP BY st.Name, st.[Group]
ORDER BY TotalRevenue DESC;
GO

-- 3. Sales person performance
SELECT 
    sp.BusinessEntityID AS SalesPersonID,
    p.FirstName + ' ' + p.LastName AS SalesPersonName,
    st.Name AS TerritoryName,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS TotalRevenue,
    sp.SalesYTD AS SalesYTD_FromSalesPersonTable
FROM Sales.SalesPerson sp
INNER JOIN Person.Person p 
    ON sp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Sales.SalesTerritory st 
    ON sp.TerritoryID = st.TerritoryID
LEFT JOIN Sales.SalesOrderHeader soh 
    ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY sp.BusinessEntityID, p.FirstName, p.LastName, st.Name, sp.SalesYTD
ORDER BY TotalRevenue DESC;
GO

-- 4. Top products by revenue
SELECT TOP 20
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    SUM(sod.OrderQty) AS UnitsSold,
    SUM(sod.LineTotal) AS Revenue,
    AVG(sod.UnitPrice) AS AvgUnitPrice
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p 
    ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name, p.ProductNumber
ORDER BY Revenue DESC;
GO

-- 5. High-value customer summary
SELECT TOP 50
    c.CustomerID,
    p.FirstName + ' ' + ISNULL(p.LastName, '') AS CustomerName,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS LifetimeValue
FROM Sales.Customer c
LEFT JOIN Person.Person p 
    ON c.PersonID = p.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader soh 
    ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName
HAVING SUM(soh.TotalDue) > 10000
ORDER BY LifetimeValue DESC;
GO
