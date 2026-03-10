# Contoso Retail — End-to-End SQL Analysis

**Tool:** MySQL Workbench  
**Dataset:** Contoso Retail Data Warehouse  
**Period:** 2007–2009  
**Author:** Bushra Khan | [thedataalchemist.co](https://thedataalchemist.co)

---

## Project Overview

Contoso Retail is a Microsoft sample data warehouse simulating a global retail business. This project performs a full end-to-end SQL analysis across sales trends, product performance, customer behaviour, and regional contribution — including advanced analytics: RFM segmentation, Customer Lifetime Value, Cohort Retention, and ABC product classification.

---

## Database Schema

| Table | Description |
|---|---|
| `factsales` | In-store, catalog & reseller transactions |
| `factonlinesales` | Online channel transactions |
| `dimcustomer` | Customer profiles (B2B & B2C) |
| `dimproduct` | Product details |
| `dimproductsubcategory` | Product subcategories |
| `dimproductcategory` | Product categories |
| `dimchannel` | Sales channels |
| `dimstore` | Store details |
| `dimgeography` | Geographic data |

---

## Analysis Structure

| File | Analysis |
|---|---|
| `01_sales_profit_trends.sql` | Monthly revenue & profit trends by channel |
| `02_product_category_analysis.sql` | Revenue, profit & margin by product category |
| `03_customer_segmentation.sql` | Top customers & B2B vs B2C comparison |
| `04_channel_analysis.sql` | Performance across Store, Online, Reseller, Catalog |
| `05_regional_analysis.sql` | Country-level revenue & profit breakdown |
| `06_rfm_analysis.sql` | RFM segmentation for B2C customers |
| `07_clv_analysis.sql` | Customer Lifetime Value estimation |
| `08_customer_demographics.sql` | Revenue by age group & gender |
| `09_cohort_analysis.sql` | Monthly cohort retention analysis |
| `10_abc_analysis.sql` | ABC product classification by revenue contribution |

---

## Key Findings

### Sales & Channels
- **Store channel leads** at $6.9bn revenue — 2.5× larger than Online ($2.7bn)
- All 4 channels maintain nearly identical profit margins (~56.6–56.9%) — pricing consistency across the business
- Online drives higher order volume; physical channels drive higher revenue per transaction

### Products
- **Home Appliances & Computers** are the top revenue categories
- **Cameras & Camcorders** have the highest margin at 57.3%
- **Games & Toys** are the weakest at 48.7% margin
- ABC Analysis: 26% of products (A tier) drive 70% of all revenue — textbook Pareto

### Customers
- **B2B dominates:** Company customers generate 3× more revenue than Person customers ($2.03bn vs $686M)
- Top B2C customer CLV: $664K over 8.45 years
- RFM reveals Contoso's B2C base is largely transactional — only 4.1% qualify as Loyal Customers, no Champions segment

### Retention
- **Cohort retention is exceptional:** Jan 2007 cohort retained 96.4% in month 1 and 77.3% at month 12
- Senior age group dominates B2C spending — strong demographic skew

### Regional
- **USA is the clear leader** at $7bn revenue, followed by China ($1.7bn) and Germany ($811M)

---

## SQL Concepts Used
- CTEs (Common Table Expressions)
- Window Functions (`NTILE`, `SUM OVER`, `TIMESTAMPDIFF`)
- Multi-table JOINs across fact and dimension tables
- UNION ALL across multiple fact tables
- Cohort Analysis with self-joins
- RFM Scoring with NTILE bucketing
- ABC Classification with cumulative revenue calculation

---

## Blog Post
Read the full analysis with findings and commentary:  
[thedataalchemist.co](https://thedataalchemist.co)
