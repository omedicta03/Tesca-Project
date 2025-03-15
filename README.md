# End-to-End Grocery Chain Data Warehouse Project

## **Overview**
This project involves the design and implementation of an **Enterprise Data Warehouse (EDW)** for a large grocery chain with 830 stores across 74 states. The goal was to consolidate transactional and operational data to enable advanced analytics, facilitate performance improvements, and support decision-making processes at all organizational levels.

The grocery chain manages **40 product categories** across 7 departments (e.g., Frozen Foods, Dairy). Data collected from Point of Sale (POS) systems, vendor transactions, and sales promotions were analyzed to meet business and analytical needs.

---

## **Key Features**

### **Analytical Objectives**
- **Sales Analysis:** Track daily product movement and evaluate sales impact due to promotions such as coupons, temporary price reductions, ads, and in-store campaigns.
- **Market Basket Analysis:** Understand product combinations in a customer’s basket.
- **Vendor Performance:** Determine the most efficient vendors based on order delivery times and analyze the impact of changes to vendor information on delivery services.
- **Product Insights:** Monitor the most ordered products from vendors across stores and analyze effects of product rebranding.
- **POS Device Tracking:** Record POS device changes and replacement frequency.
- **Overtime Analysis:** Evaluate the impact of salespersons’ marital status changes on overtime hours.
- **Demand Analysis:** Identify the most demanding products during various time periods of the day.

---

## **Project Deliverables**
- **Enterprise Data Warehouse Design:** 
  - Designed a comprehensive EDW using SQL Server.
  - Integrated transactional data (POS systems, vendor purchases, promotions) into a centralized repository.
- **Data Mart Development:** 
  - Built data marts for functional areas (e.g., sales, purchasing, HR).
  - Implemented cubes using SQL Server Analysis Services (SSAS) with both Multidimensional and Tabular models.
- **ETL Processes:**
  - Developed ETL pipelines using SQL Server Integration Services (SSIS) to extract, transform, and load data from multiple sources.
  - Ensured data quality and consistency through validation mechanisms.
- **Data Visualizations:**
  - Designed interactive dashboards and reports in **Tableau** and **Power BI**.
  - Delivered insights into sales trends, vendor performance, and product demand.

---

## **Technical Components**

### **Database Architecture**
- **Source Systems:** POS systems, vendor records, sales data from Excel sheets.
- **Integration Layer:** ETL processes for consolidating and transforming data.
- **Data Warehouse:** Centralized storage using SQL Server.
- **Data Marts:** Sales, Purchasing, and HR data marts optimized for querying.

### **Data Modeling**
- **Star Schema:** Fact tables (e.g., SalesFact, VendorFact) linked to dimension tables (e.g., ProductDim, StoreDim, TimeDim).
- **Slowly Changing Dimensions (SCD):** Implemented using SSIS to capture historical changes, such as vendor updates.

### **Visualization Tools**
- **Power BI:** Developed dashboards for sales analysis and vendor efficiency.
- **Tableau:** Created visualizations for market basket analysis and product movement trends.

---

## **Outcomes**
- Enabled daily sales tracking to assess product performance and promotional impacts.
- Improved understanding of customer purchasing patterns through market basket analysis.
- Provided actionable insights on vendor performance and delivery efficiency.
- Enhanced decision-making through intuitive and interactive dashboards.

---

## **Contact Information**
This project was executed by **Benedicta Odhegba**. For inquiries or contributions, feel free to reach out.

**Email:** onomeitimi@gmail.com  
**GitHub Portfolio:** [omedicta03](https://github.com/omedicta03)  
