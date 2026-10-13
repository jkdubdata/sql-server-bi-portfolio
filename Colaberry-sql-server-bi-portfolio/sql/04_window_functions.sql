/*
================================================================================
04_window_functions.sql
SQL Server & BI Portfolio — AdventureWorks Analytics Foundation
Target: SQL Server / Azure SQL
Purpose: Ranking, running totals, lag/lead, and analytical window patterns.
Ready for execution in SSMS or Azure SQL Query Editor.
================================================================================
*/

-- 1. Rank products by revenue within each category
WITH ProductRevenue AS (
    SELECT 
        pc.Name AS CategoryName,
        p.ProductID,
        p.Name AS ProductName,
        SUM(sod.LineTotal) AS Revenue
    FROM Sales.SalesOrderDetail sod
    INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
    LEFT JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    LEFT JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
    GROUP BY pc.Name, p.ProductID, p.Name
)
SELECT 
    CategoryName,
    ProductName,
    Revenue,
    RANK() OVER (PARTITION BY CategoryName ORDER BY Revenue DESC) AS RankInCategory,
    DENSE_RANK() OVER (PARTITION BY CategoryName ORDER BY Revenue DESC) AS DenseRankInCategory,
    ROW_NUMBER() OVER (PARTITION BY CategoryName ORDER BY Revenue DESC) AS RowNumInCategory
FROM ProductRevenue
ORDER BY CategoryName, RankInCategory;
GO

-- 2. Running total of revenue by order date
WITH DailySales AS (
    SELECT 
        CAST(soh.OrderDate AS DATE) AS OrderDay,
        SUM(soh.TotalDue) AS DailyRevenue
    FROM Sales.SalesOrderHeader soh
    GROUP BY CAST(soh.OrderDate AS DATE)
)
SELECT 
    OrderDay,
    DailyRevenue,
    SUM(DailyRevenue) OVER (ORDER BY OrderDay 
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotalRevenue
FROM DailySales
ORDER BY OrderDay;
GO

-- 3. Month-over-month change using LAG
WITH MonthlySales AS (
    SELECT 
        YEAR(soh.OrderDate) AS OrderYear,
        MONTH(soh.OrderDate) AS OrderMonth,
        SUM(soh.TotalDue) AS MonthlyRevenue
    FROM Sales.SalesOrderHeader soh
    GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT 
    OrderYear,
    OrderMonth,
    MonthlyRevenue,
    LAG(MonthlyRevenue, 1) OVER (ORDER BY OrderYear, OrderMonth) AS PriorMonthRevenue,
    MonthlyRevenue - LAG(MonthlyRevenue, 1) OVER (ORDER BY OrderYear, OrderMonth) AS MoMChange,
    CASE 
        WHEN LAG(MonthlyRevenue, 1) OVER (ORDER BY OrderYear, OrderMonth) IS NULL THEN NULL
        WHEN LAG(MonthlyRevenue, 1) OVER (ORDER BY OrderYear, OrderMonth) = 0 THEN NULL
        ELSE CAST(100.0 * (MonthlyRevenue - LAG(MonthlyRevenue, 1) OVER (ORDER BY OrderYear, OrderMonth)) 
                  / LAG(MonthlyRevenue, 1) OVER (ORDER BY OrderYear, OrderMonth) AS DECIMAL(10,2))
    END AS MoMChangePct
FROM MonthlySales
ORDER BY OrderYear, OrderMonth;
GO

-- 4. Top 3 products per territory
WITH TerritoryProduct AS (
    SELECT 
        st.Name AS TerritoryName,
        p.Name AS ProductName,
        SUM(sod.LineTotal) AS Revenue,
        ROW_NUMBER() OVER (PARTITION BY st.Name ORDER BY SUM(sod.LineTotal) DESC) AS rn
    FROM Sales.SalesOrderHeader soh
    INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
    INNER JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
    GROUP BY st.Name, p.Name
)
SELECT TerritoryName, ProductName, Revenue
FROM TerritoryProduct
WHERE rn <= 3
ORDER BY TerritoryName, rn;
GO
