# UK Retail Sales Analytics

An end-to-end data analytics project covering data quality assessment, exploratory analysis, customer segmentation, SQL business analysis, and a Power BI dashboard — built on a fictional UK multi-category retailer operating across 20 stores and 11 regions between January 2022 and December 2024.

---

## Dataset

| Table | Rows | Description |
|---|---|---|
| Transactions | 60,000 | Purchases, returns, and cancellations with revenue, channel, and product data |
| Customers | 8,000 | Demographics, loyalty tier, and registration date |
| Products | 76 | 8 categories with unit price and gross margin |
| Stores | 20 | 20 stores across 11 UK regions |

**Period:** January 2022 – December 2024

---

## Tools

- **Python** (Pandas, Matplotlib, Scikit-learn) — data cleaning, EDA, RFM segmentation
- **SQL Server** — business analysis queries
- **Power BI** — dashboard and visualisation
- **Jupyter Notebooks** — analysis documentation

---

## Project Structure

```
uk-retail-analytics/
│
├── 01_data_quality_assessment.ipynb   # Null investigation, data type fixes, referential integrity
├── 02_exploratory_analysis.ipynb      # Revenue, category, regional, channel, loyalty analysis
├── 03_customer_segmentation.ipynb     # RFM scoring, segment assignment, loyalty vs RFM comparison
├── 04_recommendations.ipynb           # Business recommendations grounded in findings
│
├── UK_Retail_SQL_Analysis.sql         # 12 SQL queries — core business analysis and advanced SQL
│
├── cleaned_transactions.csv           # Cleaned transactions dataset
├── cleaned_customers.csv              # Cleaned customers dataset
├── cleaned_products.csv               # Cleaned products dataset
├── cleaned_stores.csv                 # Cleaned stores dataset
├── rfm_segments.csv                   # RFM table with segment labels
```

---

## Key Findings

### Revenue
- Total revenue across 2022–2024: **£5,107,408** at a **32.6% gross margin**
- Revenue was flat in 2022–2023 before recovering **+4.4% in 2024**
- Consistent seasonality — Nov–Dec peak, Jan dip — across all three years

### Category Performance
- **Electronics** accounts for **54% of revenue** but has the **lowest margin at 27.7%**
- **Beauty & Health** has the **highest margin at 51.4%** but ranks 6th on revenue — significantly underutilised
- All top 10 products by revenue are Electronics

### Customer Segmentation (RFM)
- **1,783 Champions** — 22.3% of customers, **37.3% of revenue (£1.9M)**
- **Lost is the largest segment** at 24.9% (1,986 customers)
- **At-Risk + Lost combined: 3,523 customers, £2.07M** in historical revenue
- 20% reactivation rate = **£414,763 recovered**

### Loyalty Programme
- **Bronze customers outspend Platinum** on average (£664 vs £583)
- Platinum has the **lowest average RFM score (2.43)** — Bronze scores highest (2.52)
- **840 of 1,783 Champions hold Bronze status** — 47% of the best customers are the least recognised
- Only 122 Champions hold Platinum status

### Channel & Regional Performance
- **Mobile App** has the highest average order value at **£111.85** despite the lowest revenue share (20.5%)
- **South East** leads on revenue at **£1.04M** — nearly 20% of total business
- Return rate is consistent across all channels (11.1%–11.3%)

---

## Business Recommendations

| Priority | Recommendation | Key Finding |
|---|---|---|
| 1 | Fix the loyalty programme | Bronze outspends Platinum; 47% of Champions are Bronze |
| 2 | Win-back At-Risk customers | 1,537 customers, £1.1M revenue disengaging |
| 3 | Protect Champions | 37.3% of revenue from 22.3% of customers — under-recognised |
| 4 | Invest in Beauty & Health | 51.4% margin vs Electronics at 27.7% |
| 5 | Prioritise Mobile App | Highest AOV at £112 — lowest revenue share at 20.5% |
| 6 | Convert New Customers | 652 new buyers at risk of lapsing before second purchase |

---

## SQL Analysis

12 queries across two sections:

**Core Business Queries**
- Revenue, orders, and AOV by customer segment
- Average RFM score by loyalty tier
- Top 10 customers by total spend
- Revenue by category, region, and channel
- Monthly revenue trend (2022–2024)
- At-Risk and Lost customers with spend above £500
- Top 10 customers per segment using `RANK()` and CTEs
- Monthly revenue with running total using `SUM() OVER`
- Customer spend banding using `CASE WHEN`
- Customers above segment average using subqueries

---

## Author

**Manvendra Singh**  
manvendras2608@gmail.com  
[linkedin.com/in/manvendras2608](https://linkedin.com/in/manvendras2608)
