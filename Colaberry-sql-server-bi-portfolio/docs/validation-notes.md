# Validation Notes

## Structural Review

All SQL scripts have been reviewed against the published AdventureWorks schema:

- Table and column references verified
- Join keys confirmed
- Computed column usage (`LineTotal`) handled correctly
- Discount range and other business-rule checks strengthened
- Consistent script headers and schema-qualified names applied

## Execution Readiness

Scripts are written for SQL Server and Azure SQL. They are ready to execute in:

- SQL Server Management Studio (SSMS)
- Azure Data Studio
- Azure SQL Query Editor

Recommended execution order: `01` → `07`.

## Quality Checks Included

`sql/05_data_quality_checks.sql` and the procedure `dbo.usp_DataQualitySummary` provide a ready-to-run set of data-quality validations covering:

- Discount percentage bounds
- Order quantity validity
- Orphan detection
- Date logic
- Price anomalies

## Notes for Reviewers

The project structure, documentation, and scripts are organised for direct review and demonstration. Views and stored procedures can be used immediately as a lightweight semantic layer once the scripts have been executed against an AdventureWorks database.
