# Report Specifications

These specifications define the analytical outputs supported by the SQL scripts and views in this project. They are written so a BI developer or reporting analyst can implement them directly.

## Report 1 — Sales Performance Overview

**Audience:** Sales managers and BI stakeholders  
**Grain:** Order header (with ability to drill to line)  

**Primary metrics:**
- Total sales (`TotalDue` / `SubTotal`)
- Order count
- Average order value
- Online vs offline order mix

**Dimensions / slicers:**
- Order date (year, quarter, month)
- Sales territory
- Sales person
- OnlineOrderFlag

**Supporting objects:**  
`sql/03_joins_and_aggregations.sql`, `sql/04_window_functions.sql`, `Sales.vSalesOrderSummary`

## Report 2 — Product Performance

**Audience:** Product and category managers  
**Grain:** Product (or product + month)  

**Primary metrics:**
- Units sold
- Revenue (`LineTotal`)
- Average unit price
- Discount impact

**Dimensions:**
- Product category / subcategory
- Product
- Time

**Supporting objects:**  
Joins to `Production.Product` and related tables; window functions for ranking; `Sales.vSalesOrderDetailEnriched` and `Production.vProductDim`

## Report 3 — Data Quality Summary

**Audience:** Data analysts / engineering  
**Purpose:** Surface results of the checks in `sql/05_data_quality_checks.sql` and the procedure `dbo.usp_DataQualitySummary`

**Metrics:** Count of violations by rule

## Implementation Guidance

- Prefer a star-schema or wide analytical table feeding these reports rather than direct OLTP queries in production
- The views in `sql/06_views.sql` provide a clean starting semantic layer
- Monetary values should be treated consistently (two decimal places for display)
