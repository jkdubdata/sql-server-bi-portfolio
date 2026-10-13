# SQL Server & BI Portfolio Project

**AdventureWorks Analytics Foundation**

A production-oriented SQL Server / Azure SQL portfolio project demonstrating core data-analytics and business-intelligence skills. The project uses the Microsoft AdventureWorks sample database and is structured for direct use in SQL Server Management Studio (SSMS) or the Azure SQL query editor.

---

## Project Overview

This repository contains a complete set of T-SQL scripts, documentation, and design artifacts that showcase practical skills in:

- Relational schema exploration
- Analytical querying and aggregation
- Multi-table joins and window functions
- Data quality validation
- View and stored-procedure design
- ETL design thinking
- Report specification

All scripts target SQL Server / Azure SQL and follow standard AdventureWorks schema conventions. They are ready to execute in SSMS or Azure Data Studio / Azure SQL Query Editor.

---

## Repository Structure

```
sql-server-bi-portfolio/
├── README.md
├── docs/
│   ├── skills-map.md
│   ├── dataset-guide.md
│   ├── etl-design.md
│   ├── report-specs.md
│   └── validation-notes.md
├── sql/
│   ├── 01_schema_exploration.sql
│   ├── 02_basic_queries.sql
│   ├── 03_joins_and_aggregations.sql
│   ├── 04_window_functions.sql
│   ├── 05_data_quality_checks.sql
│   ├── 06_views.sql
│   └── 07_stored_procedures.sql
├── scripts/
│   └── project-notes.md
└── reports/
    └── README.md
```

---

## How to Run

1. Restore or attach the AdventureWorks sample database in SQL Server or Azure SQL.
2. Open the scripts in SSMS or Azure Data Studio.
3. Execute in numerical order (`01` → `07`).
4. Review results and use the views / stored procedures as a lightweight semantic layer for reporting.

Scripts use schema-qualified names and standard T-SQL. No additional configuration is required beyond a working AdventureWorks database.

---

## Skills Demonstrated

| Area | Evidence |
|------|----------|
| Schema exploration & metadata | `01_schema_exploration.sql` |
| Filtering, aggregation, sorting | `02_basic_queries.sql` |
| Multi-table joins & business context | `03_joins_and_aggregations.sql` |
| Window functions & ranking | `04_window_functions.sql` |
| Data quality & business rules | `05_data_quality_checks.sql` |
| View design | `06_views.sql` |
| Parameterized stored procedures | `07_stored_procedures.sql` |
| ETL conceptual design | `docs/etl-design.md` |
| Report requirements | `docs/report-specs.md` |

Full mapping: `docs/skills-map.md`

---

## Documentation

- **Dataset Guide** — AdventureWorks tables and columns used
- **ETL Design** — Staging → clean → analytical layer thinking
- **Report Specifications** — Clear requirements for sales and product reporting
- **Validation Notes** — Structural review and execution readiness

---

## Intended Use

This project is suitable for:

- Portfolio review by hiring managers and technical interviewers
- Demonstration of T-SQL and BI foundations
- Extension into Power BI or further dimensional modelling work

It is written and organised to professional standards and can be pushed directly to a public or private GitHub repository.
