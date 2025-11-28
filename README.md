# 🚀 SQL Data Warehouse & Analytics Project

> *Welcome to my comprehensive data warehouse portfolio project — a hands-on demonstration of end-to-end data engineering and analytics workflows using SQL Server. Built with industry best practices, this project bridges raw data ingestion to actionable business intelligence, showcasing both technical depth and strategic insight.*

---

## 📋 Project Requirements

This project is structured to reflect real-world enterprise data pipelines, divided into two core domains: **Data Engineering** and **Data Analysis**. Each stage serves a distinct purpose, ensuring scalability, maintainability, and business value.

---

### 🔧 Building the Data Warehouse (Data Engineering)

#### 🎯 Objective
To design and implement a robust, scalable, and well-documented SQL Server-based data warehouse that ingests, transforms, and models data from heterogeneous sources (CRM & ERP), enabling downstream analytics and reporting for business stakeholders.

#### 📐 Specifications

- **Data Sources**:  
  - Two source systems: `CRM` and `ERP`, each providing structured CSV files.  
  - Files are loaded directly into the Bronze layer without transformation.

- **Data Quality**:  
  - Cleanse and resolve data quality issues (e.g., nulls, duplicates, inconsistent formats) during Silver layer processing.  
  - Implement data validation rules and logging for auditability.

- **Integration**:  
  - Combine CRM and ERP datasets into a unified, user-friendly dimensional model in the Gold layer.  
  - Apply star schema design with fact and dimension tables for optimized querying.

- **Scope**:  
  - Focus on the latest dataset only — historical versioning is not required.  
  - All ETL processes are batch-driven, with full-load and truncate-insert patterns.

- **Documentation**:  
  - Clear documentation of the data model, including entity relationships, column definitions, and transformation logic.  
  - Schema diagrams and process flowcharts provided for stakeholder clarity.

---

### 📊 Generating Business Insights (Data Analysis)

#### 🎯 Objective
To extract, visualize, and communicate meaningful business insights from the curated data warehouse, empowering decision-makers through intuitive dashboards and analytical reports built on the Gold layer.

#### 📈 Visualization & Reporting

- **Tools**:  
  - Power BI / Tableau (or SQL-based reporting via SSRS) for dynamic dashboards.  
  - Custom SQL queries for ad-hoc analysis and KPI tracking.

- **Key Metrics & Dimensions**:  
  - Sales performance by region, product, and time period.  
  - Customer segmentation and retention trends.  
  - Operational efficiency metrics from ERP data.

- **Modeling Strategy**:  
  - Star Schema with `Fact_Sales`, `Dim_Customer`, `Dim_Product`, `Dim_Date`.  
  - Aggregation tables for pre-calculated KPIs to improve query performance.  
  - Views in the Gold layer expose clean, business-ready data for consumption.

- **Output**:  
  - Interactive dashboards for executives and analysts.  
  - PDF/PowerPoint summaries for monthly business reviews.  
  - Machine learning-ready datasets for future predictive modeling.

---

## 🏗️ Architecture Overview

![Data Warehouse Architecture](Docs/architecture.png)

> *Three-tiered architecture — Bronze → Silver → Gold — with source systems feeding into SQL Server, and outputs consumed by BI tools and ML platforms.*

### 🟤 Bronze Layer
- **Objective Type**: Tables  
- **Load**: Batch Processing, Full Load, Truncate & Insert  
- **Transformation**: None  
- **Data Model**: Raw, unstructured — mirrors source CSV format  

### ⚪ Silver Layer
- **Objective Type**: Tables  
- **Load**: Batch Processing, Full Load, Truncate & Insert  
- **Transformation**:  
  - Data Cleaning  
  - Data Standardization  
  - Data Normalization  
  - Derived Columns  
- **Data Model**: None — intermediate staging area  

### 🟡 Gold Layer
- **Objective Type**: Views  
- **Load**: No Load — derived from Silver  
- **Transformation**:  
  - Data Integration  
  - Aggregation  
  - Business Logic  
- **Data Model**:  
  - Star Schema  
  - Flat Table  
  - Aggregation Table  
- **Consumption**: BI & Reporting, Machine Learning  

---
## 🗂️ Repository Structure

This project follows a **layered data warehouse architecture** (Bronze → Silver → Gold), ensuring separation of concerns, data lineage, and business readiness. All components are organized for clarity, reproducibility, and team collaboration.

### 📁 `datasets/`
Contains raw source data used for ingestion:
- **`datasets/CRM/`**  
  - `cust_info.csv`, `prd_info.csv`, `sales_details.csv`  
  → Raw customer, product, and sales data from the CRM system.
- **`datasets/ERP/`**  
  - `CUST_AZ12.csv`, `LOC_A101.csv`, `PX_CAT_G1V2.csv`  
  → Demographic, geographic, and product category data from the ERP system.

> ✅ *All data is loaded into the Bronze layer without modification to preserve source fidelity.*

---

### 📁 `docs/`
Comprehensive documentation to support onboarding, review, and governance:
- `Architecture.png`, `Data_Flow.png`  
  → Visual representation of the end-to-end data pipeline and Medallion architecture.
- `Relations.drawio`  
  → Interactive entity-relationship diagram (ERD) of the Gold layer.
- `Data_Catalog.md`  
  → Business-friendly data dictionary for all Gold layer tables (dimensions and facts).

> 🎯 *Designed to accelerate team understanding and ensure consistent interpretation of metrics.*

---

### 📁 `scripts/`
Modular, idempotent SQL scripts organized by architectural layer:

#### 🔹 **Bronze Layer** (`scripts/bronze_layer/`)
- `01_DDL_Bronze_Layer.sql`  
  → Creates raw staging tables for CRM and ERP data.
- `02_load_bronze.sql`  
  → Ingests CSV files via `BULK INSERT` with logging and error handling.

#### 🔸 **Silver Layer** (`scripts/silver_layer/`)
- `03_DDL_Silver_Layer.sql`  
  → Defines cleansed and conformed tables.
- `04_loading_silver_layer.sql`  
  → Applies data quality rules, standardization, and enrichment.

#### 🔹 **Gold Layer** (`scripts/gold_layer/`)
- `05_DDL_Gold_Layer.sql`  
  → Builds business-ready views using a star schema (dimensions + facts).

#### ⚙️ **Initialization**
- `00_initialization_DB.sql`  
  → Creates the `DataWarehouse` database and `bronze`/`silver`/`gold` schemas.

> 🔄 *Scripts follow a numbered execution sequence (`00_` → `05_`) for reliable, repeatable deployment.*

---

This structure reflects **industry best practices** in data engineering—ensuring traceability from source to insight, while enabling scalability, auditability, and self-service analytics.

## 👤 About Me

I’m a passionate data professional with a strong foundation in **data engineering, SQL development, and business analytics**. This project reflects my ability to:

✅ Design scalable data architectures  
✅ Execute complex ETL pipelines in SQL Server  
✅ Translate raw data into business-ready insights  
✅ Collaborate across teams with clear documentation and visualization  

Whether you’re looking for someone who can build the pipeline or derive the insights — I bring both to the table. Let’s connect if you need a detail-oriented, results-driven data specialist to elevate your team’s data capabilities.

📩 *Contact me via [LinkedIn](https://www.linkedin.com/in/mohamed-ayman-data/) or GitHub — I’d love to discuss how I can contribute to your next data initiative.*

---
