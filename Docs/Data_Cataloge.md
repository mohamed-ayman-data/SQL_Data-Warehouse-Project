# 🏆 Gold Layer Data Catalog

This document defines the structure and meaning of the **business-facing semantic model** in the Gold layer. All tables are implemented as **views** and follow a **star schema** design for optimal analytics and reporting.

---

## 🧑‍💼 `gold.dim_customer` — Customer Dimension

Unified customer profile created by integrating CRM (primary) and ERP (supplemental) data.

| Column Name         | Data Type        | Description                                                                 |
|---------------------|------------------|-----------------------------------------------------------------------------|
| `customer_key`      | `bigint`         | Surrogate key for joining with fact tables.                                |
| `customer_id`       | `int`            | Original customer ID from CRM source system.                               |
| `customer_number`   | `nvarchar(50)`   | Customer-facing identifier (e.g., `"AW00011000"`).                          |
| `first_name`        | `nvarchar(50)`   | Customer’s first name.                                                     |
| `last_name`         | `nvarchar(50)`   | Customer’s last name.                                                      |
| `country`           | `varchar(50)`    | Country of residence (e.g., `"Germany"`.                                   |
| `material_status`   | `nvarchar(50)`   | Marital status (e.g., `"Married"`, `"Single"`, `"N/A"`).                    |
| `gender`            | `nvarchar(50)`   | Gender value: `"Male"`, `"Female"`, or `"N/A"`.                            |
| `create_date`       | `date`           | Date the customer record was created in CRM.                               |
| `birth_date`        | `date`           | Customer’s date of birth.                                                  |

---

## 🛒 `gold.dim_products` — Product Dimension

Enriched product catalog with category hierarchy from ERP. Only **active products** (`prd_end_dt IS NULL`) are included.

| Column Name       | Data Type        | Description                                                                 |
|-------------------|------------------|-----------------------------------------------------------------------------|
| `product_key`     | `bigint`         | Surrogate key for joining with fact tables.                                |
| `product_id`      | `int`            | Original product ID from CRM source system.                                |
| `product_number`  | `nvarchar(50)`   | Product SKU or identifier (e.g., `"FR-R92B-58"`).                           |
| `product_name`    | `nvarchar(50)`   | Human-readable product name (e.g., `"HL Road Frame – Black, 58"`).          |
| `category_id`     | `nvarchar(50)`   | Internal category code (e.g., `"CO_RF"`).                                  |
| `Category`        | `varchar(50)`    | High-level product category (e.g., `"Components"`, `"Bikes"`, `"Clothing"`).|
| `Subcategory`     | `varchar(50)`    | Product subcategory (e.g., `"Road Frames"`, `"Socks"`).                    |
| `MAINTENANCE`     | `varchar(50)`    | Maintenance requirement: `"Yes"` or `"No"`.                                 |
| `Cost`            | `int`            | Base cost of the product (gross value).                                    |
| `product_line`    | `varchar(50)`    | Product line or family (e.g., `"Road"`, `"Mountain"`).                     |
| `start_date`      | `date`           | Date the product became active in the catalog.                             |

---

## 📈 `gold.fact_sales` — Sales Fact Table

Transactional sales records linked to conformed dimensions for consistent reporting.

| Column Name       | Data Type        | Description                                                                 |
|-------------------|------------------|-----------------------------------------------------------------------------|
| `order_number`    | `nvarchar(50)`   | Customer-facing order number (e.g., `"SO43697"`).                           |
| `product_key`     | `bigint`         | Foreign key → `gold.dim_products`.                                         |
| `customer_key`    | `bigint`         | Foreign key → `gold.dim_customer`.                                         |
| `order_date`      | `date`           | Date the order was placed.                                                 |
| `shipping_date`   | `date`           | Date the order was shipped.                                                |
| `due_date`        | `date`           | Payment due date.                                                          |
| `sales`           | `int`            | **Gross** sales amount for the line item (before discounts or taxes).       |
| `quantity`        | `int`            | Number of units sold.                                                      |
| `price`           | `int`            | **Gross** unit price per item.                                             |

> 💡 **Note**: All monetary values are **gross** (not net). This enables consistent top-line sales analysis.

---

> ✨ **Design Principle**: *The Gold layer exposes what the business understands — clean, integrated, and ready for insight.*  
> Views are optimized for consumption by Power BI, Excel, or ad-hoc SQL queries.
