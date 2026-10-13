# Dataset Guide — AdventureWorks

## Overview

This project uses the Microsoft AdventureWorks sample OLTP database. AdventureWorks is the standard reference dataset for SQL Server training and demonstration work. All scripts follow the published Microsoft schema.

## Primary Schemas

| Schema | Role in this project |
|--------|----------------------|
| Sales | Orders, order details, customers, sales people, territories |
| Person | Person and address data linked to customers and employees |
| Production | Products, categories, and related attributes |
| HumanResources | Lightly referenced for sales-person context |

## Key Tables

### Sales.SalesOrderHeader
- Primary key: `SalesOrderID`
- Core columns: `OrderDate`, `DueDate`, `ShipDate`, `Status`, `OnlineOrderFlag`, `CustomerID`, `SalesPersonID`, `TerritoryID`, `SubTotal`, `TaxAmt`, `Freight`, `TotalDue`

### Sales.SalesOrderDetail
- Composite key: `SalesOrderID` + `SalesOrderDetailID`
- Core columns: `OrderQty`, `ProductID`, `SpecialOfferID`, `UnitPrice`, `UnitPriceDiscount`, `LineTotal` (computed)

### Production.Product
- Primary key: `ProductID`
- Core columns: `Name`, `ProductNumber`, `StandardCost`, `ListPrice`, `ProductSubcategoryID`, `SellStartDate`, `SellEndDate`, `FinishedGoodsFlag`

### Sales.Customer / Person.Person
- Customer links to Person for name and contact context
- Used in customer lifetime-value and demographic-style reporting queries

### Sales.SalesPerson / Sales.SalesTerritory
- Used for territory and sales-representative performance analysis

## Execution Environment

Scripts are written for SQL Server and Azure SQL. They use schema-qualified names and standard T-SQL syntax. They are ready to run in:

- SQL Server Management Studio (SSMS)
- Azure Data Studio
- Azure SQL Query Editor

No additional configuration is required beyond a restored AdventureWorks database.
