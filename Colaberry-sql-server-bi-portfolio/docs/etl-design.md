# ETL Design Notes

This document outlines a practical ETL design suitable for the analytical work demonstrated in this portfolio.

## Design Goals

- Separate raw, cleaned, and analytical layers
- Make transformations explicit and auditable
- Support both operational reporting and simple dimensional analysis
- Remain realistic for SQL Server / Azure SQL environments

## Logical Layers

```
Source (AdventureWorks OLTP)
        │
        ▼
  Staging (stg_*)
        │  – light cleaning, type casting, basic validation
        ▼
  Intermediate / Clean (int_*)
        │  – business-rule application, key resolution, quality flags
        ▼
  Analytical / Mart (mart_*)
        │  – denormalized or star-like structures for reporting
        ▼
  Reporting Layer (views or Power BI semantic model)
```

## Example Flows

### Sales Orders
1. Extract from `Sales.SalesOrderHeader` and `Sales.SalesOrderDetail`
2. Stage — preserve source keys, add load timestamp, apply basic null/range flags
3. Clean — resolve product and customer keys, apply status mapping, calculate derived amounts where needed
4. Mart — fact table at order-line grain with keys to product, customer, territory, and date dimensions

### Products
1. Extract from `Production.Product` (plus subcategory / category)
2. Stage and clean — handle discontinued products, standardise attributes
3. Dimension table ready for reporting

## Quality Gates

Concrete checks are implemented in `sql/05_data_quality_checks.sql`:

- Discount percentage within expected bounds
- Order quantity > 0
- Orphan detection (order details without header)
- Date logic (ShipDate and DueDate relative to OrderDate)
- ListPrice vs StandardCost anomalies

These checks form a simple, transparent data-quality foundation that can be automated or scheduled later.

## Implementation Notes

- Prefer idempotent loads (truncate-and-load or MERGE) in a practice or development environment
- Log row counts and error counts at each layer
- Views created in `sql/06_views.sql` can serve as an initial semantic layer for reporting tools
