# Project Notes

## Execution

Scripts are designed for SQL Server and Azure SQL. Recommended tools:

- SQL Server Management Studio (SSMS)
- Azure Data Studio
- Azure SQL Query Editor

Execute the scripts in numerical order (`01` through `07`).

## Views and Procedures

After running `06_views.sql` and `07_stored_procedures.sql`, the following objects are available:

**Views**
- `Sales.vSalesOrderSummary`
- `Sales.vSalesOrderDetailEnriched`
- `Production.vProductDim`

**Stored Procedures**
- `Sales.usp_SalesByTerritory`
- `Sales.usp_TopProductsByRevenue`
- `dbo.usp_DataQualitySummary`

These form a lightweight semantic layer that can be consumed by reporting tools or ad-hoc analysis.
