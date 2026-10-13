/*
================================================================================
06_views.sql
SQL Server & BI Portfolio — AdventureWorks Analytics Foundation
Target: SQL Server / Azure SQL
Purpose: Clean, documented views for a lightweight semantic / reporting layer.
Ready for execution in SSMS or Azure SQL Query Editor.
================================================================================
*/

-- View 1: Sales order header enriched with territory and channel
IF OBJECT_ID('Sales.vSalesOrderSummary', 'V') IS NOT NULL
    DROP VIEW Sales.vSalesOrderSummary;
GO

CREATE VIEW Sales.vSalesOrderSummary
AS
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.DueDate,
    soh.ShipDate,
    soh.Status,
    soh.OnlineOrderFlag,
    CASE WHEN soh.OnlineOrderFlag = 1 THEN 'Online' ELSE 'Sales Person' END AS OrderChannel,
    soh.CustomerID,
    soh.SalesPersonID,
    soh.TerritoryID,
    st.Name AS TerritoryName,
    st.[Group] AS TerritoryGroup,
    soh.SubTotal,
    soh.TaxAmt,
    soh.Freight,
    soh.TotalDue
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID;
GO

-- View 2: Order line detail with product and category
IF OBJECT_ID('Sales.vSalesOrderDetailEnriched', 'V') IS NOT NULL
    DROP VIEW Sales.vSalesOrderDetailEnriched;
GO

CREATE VIEW Sales.vSalesOrderDetailEnriched
AS
SELECT 
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    soh.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    pc.Name AS CategoryName,
    psc.Name AS SubcategoryName,
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal,
    soh.TerritoryID,
    st.Name AS TerritoryName
FROM Sales.SalesOrderDetail sod
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
LEFT JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID;
GO

-- View 3: Product dimension-style view
IF OBJECT_ID('Production.vProductDim', 'V') IS NOT NULL
    DROP VIEW Production.vProductDim;
GO

CREATE VIEW Production.vProductDim
AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.Color,
    p.Size,
    p.ListPrice,
    p.StandardCost,
    p.SellStartDate,
    p.SellEndDate,
    p.DiscontinuedDate,
    p.FinishedGoodsFlag,
    psc.Name AS SubcategoryName,
    pc.Name AS CategoryName
FROM Production.Product p
LEFT JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID;
GO
