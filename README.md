# 🛒 End-to-End Olist E-Commerce Analytics Project

## 📌 Project Overview
This project is a modern **ELT (Extract, Load, Transform)** data pipeline designed to analyze the Brazilian Olist E-Commerce dataset. The goal was to transform raw, scattered CSV files into a structured Data Warehouse to enable business intelligence reporting.

The solution leverages **Python** for initial data cleaning, **Snowflake** as a centralized Data Warehouse, and **dbt** for advanced data modeling, followed by **Power BI** for visualization.

## 🏗️ Pipeline Architecture
The data flows from raw files through a cleaning layer using Python, is loaded into Snowflake, and then transformed into a **Galaxy Schema** using dbt.

![Pipeline Architecture](./Pipeline_Architecture.png)

### 🔄 Data Flow Description:

#### 1. Ingestion & Cleaning (Python Layer)
* **Source:** Raw CSV files (Orders, Customers, Payments, etc.).
* **Processing:** **Python (Pandas)** scripts are used to:
    * Handle missing values and data types.
    * Clean string characters (e.g., city names).
    * Prepare data for loading.

#### 2. Data Warehousing (Snowflake)
* **Loading:** Cleaned data is loaded into **Snowflake** staging tables.
* **Storage:** Acts as the centralized repository for both raw and transformed data.

#### 3. Transformation & Modeling (dbt)
* **Transformation:** **dbt (Data Build Tool)** performs the "T" in ELT inside Snowflake.
* **Modeling:** Implemented a **Galaxy Schema** containing:
    * **Dimensions:** Customers, Products, Sellers, Time.
    * **Facts:** Sales, Payments, and Reviews.
* **Testing:** Applied dbt tests to ensure data quality (unique keys, not null constraints).

#### 4. Visualization (Power BI)
* **Connection:** Power BI connects directly to the Gold Layer in Snowflake.
* **Output:** Interactive dashboards for Sales, Logistics, and Seller analysis.

---

## 🛠️ Tech Stack
| Category | Technologies |
| :--- | :--- |
| **Data Cleaning** | Python (Pandas) |
| **Data Warehouse** | Snowflake |
| **Transformation** | dbt (Data Build Tool) |
| **Visualization** | Power BI |
| **Languages** | Python, SQL, DAX |

---

## 🗂️ Project Structure
```text
├── 📂 Python_Scripts/       # Python scripts for cleaning & validation
├── 📂 dbt_Project/          # dbt models, snapshots, and schema tests
├── 📂 data modeling/        # Architecture diagram 
├── 📂 power BI/             # Dashboard screenshots
└──README.md                # Project documentation

👨‍💻 Author
Ehab Farid

Role: Data Engineer

linledin : https://www.linkedin.com/in/ehab-fared-b822a6212/