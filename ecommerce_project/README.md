# E-commerce Sales Performance Analysis

An end-to-end e-commerce sales analytics project using SQL, Python, and Excel — built on the public Superstore Sales dataset (8,399 orders, 21 columns, 2009–2012).

## Project Structure

```
ecommerce_project/
├── data/
│   ├── superstore_sales.csv      # Cleaned source dataset
│   └── superstore.db             # SQLite database
├── sql/
│   ├── 01_data_cleaning.sql      # Data quality & sanity checks
│   └── 02_business_analysis.sql  # 17 business insight queries
├── python/
│   ├── ecommerce_eda.ipynb       # Jupyter notebook with full EDA
│   └── charts/                   # 5 exported chart images
├── excel/
│   └── Ecommerce_Sales_Dashboard.xlsx  # 5-sheet pivot dashboard with charts
└── README.md
```

## Dataset

**Source**: Superstore Sales dataset — a widely-used public practice dataset (Tableau-style) covering orders, customers, products, and shipping across 2009–2012.

## Key Findings

- **Total revenue: $14.92M** across 8,399 orders, with an **overall profit margin of 10.20%**
- **Technology** is the top revenue category (**$5.98M**), narrowly ahead of Furniture ($5.18M); Office Supplies trails at $3.75M
- Sales **peaked in 2009 ($4.21M)** and had not fully recovered by 2012 ($3.72M)
- **Regional margins vary widely**: Northwest Territories leads at 12.57% margin, while **Nunavut lags at just 2.44%**
- **50.8% of all orders (4,264 of 8,399) are loss-making** — heavier discounts (30%+) are strongly associated with negative profit

## Recommendations

1. Review discounting policy, especially for discounts above 30%, which strongly correlate with losses
2. Investigate cost/pricing structure in the Nunavut region to improve thin margins
3. Prioritize retention and upsell efforts in Technology, the strongest-performing category

## Tools Used

- **SQL** (SQLite): 25 verified queries across data cleaning and business analysis
- **Python** (pandas, matplotlib, seaborn): Full EDA notebook, executed end-to-end
- **Excel**: Pivot-style dashboard with 5 sheets and embedded charts

## How to Run

```bash
# SQL
sqlite3 data/superstore.db < sql/01_data_cleaning.sql
sqlite3 data/superstore.db < sql/02_business_analysis.sql

# Python notebook
jupyter notebook python/ecommerce_eda.ipynb
```
