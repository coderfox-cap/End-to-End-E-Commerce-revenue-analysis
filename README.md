# 🛒 E-Commerce Marketplace Analytics: From Numbers to Story

> **96,096 customers. 99,441 orders. ₹15.84M revenue.**
>
> At first glance, the business appeared healthy.
>
> But beneath the growing revenue lay a hidden story:
>
> **Nearly 97% of customers purchased only once.**
>
> This project goes beyond dashboards and KPI reporting. It follows a complete end-to-end analytics workflow to uncover not only *what happened*, but also *why it happened* and *what the business should do next*.

---

# 📌 Project Objective

The objective of this project is to perform a complete business analysis of an e-commerce marketplace using SQL and analytical techniques commonly used by real-world Data Analysts.

Instead of focusing on dashboards, the emphasis was placed on:

- Finding patterns
- Testing hypotheses
- Investigating customer behavior
- Identifying root causes
- Transforming data into business insights

---

# 🎯 Business Questions

This project aims to answer:

- Is the business growing?
- Which categories and regions drive revenue?
- Is the business dependent on a few products or customers?
- What affects customer satisfaction?
- Are customers returning?
- Why are customers not returning?
- What are the biggest risks to future growth?

---

# 🗂 Dataset Overview

The project uses the Brazilian E-Commerce Public Dataset (Olist).

### Tables Used

| Table | Description |
|---------|------------|
| Customers | Customer information |
| Orders | Order details and timestamps |
| Order_Items | Product-level transaction data |
| Products | Product category information |
| Order_Reviews | Customer review scores |
| Order_Payments | Payment information |

---

# 🏗 Data Model

```text
Customers
    ↓
Orders
    ↓
 ┌─────────────┬─────────────┬────────────┐
 ↓             ↓             ↓
Order_Items  Reviews      Payments
    ↓
Products
```

---

# 📈 Analytical Approach

This project follows a progression:

```text
What Happened?
        ↓
Trend Analysis
        ↓
Comparative Analysis
        ↓
Segmentation
        ↓
Customer Behaviour
        ↓
Retention Analysis
        ↓
Root Cause Analysis
        ↓
Business Recommendations
```

---

# 🔍 Methods Used

### Descriptive Analysis

Used to understand:

- Revenue
- Orders
- Customers
- Average Order Value

---

### Trend Analysis

Used to study:

- Revenue growth over time
- Customer acquisition trends
- Demand patterns

---

### Comparative Analysis

Used to compare:

- States
- Product categories

---

### Pareto Analysis (80/20 Rule)

Used to determine:

- Revenue concentration by category
- Revenue concentration by customer

---

### Segmentation Analysis

Used to identify:

- Premium states
- Volume markets
- Hidden opportunities

---

### Correlation Analysis

Used to investigate relationships between:

- Delivery time and ratings
- Freight cost and ratings

---

### RFM Analysis

Used to understand:

- Customer recency
- Purchase frequency
- Customer value

---

### Cohort Analysis

Used to investigate:

- Customer retention
- Repeat purchase behaviour

---

### Root Cause Analysis

Used to identify the reasons behind:

- Low customer retention
- Customer dissatisfaction

---

# 📊 Overall Business Performance

| Metric | Value |
|----------|-------:|
| Revenue | ₹15.84M |
| Orders | 99,441 |
| Customers | 96,096 |
| Average Order Value | ₹160.57 |
| Revenue Per Customer | ₹166.04 |

---

# 📈 Trend Analysis Findings

### Revenue Growth

Revenue increased steadily throughout 2017 and 2018.

---

### Customer Acquisition

New customers consistently joined the platform.

---

### Demand

Order volume closely followed customer growth.

### Insight

Growth appears to be driven primarily by customer acquisition.

---

# 🌎 Geographic Analysis

Top Revenue States:

1. São Paulo (SP)
2. Rio de Janeiro (RJ)
3. Minas Gerais (MG)
4. Rio Grande do Sul (RS)
5. Paraná (PR)

### Key Finding

High-revenue states were not always high-value states.

Rio de Janeiro emerged as a strong market with both:

- High revenue
- Above-average customer value

---

# 📦 Category Analysis

Major categories:

- Beauty & Health
- Watches & Gifts
- Bed Bath & Table
- Sports & Leisure

### Category Types Identified

#### ⭐ Superstar Categories

- Beauty & Health

#### 💎 Premium Categories

- Watches & Gifts
- Cool Stuff

#### 🛒 Volume Categories

- Bed Bath & Table

---

# 📉 Pareto Analysis

### Category Concentration

Top 5 categories contributed:

> 40% of total revenue

Top 10 categories contributed:

> 62.34% of total revenue

Revenue was moderately diversified.

---

### Customer Concentration

| Segment | Revenue Contribution |
|---------|------------------:|
| Top 1% Customers | 9% |
| Top 5% Customers | 27% |
| Top 10% Customers | 44% |

### Insight

Revenue was not dependent on a handful of customers.

---

# ⭐ Customer Satisfaction Investigation

## Delivery Time vs Review Score

One of the strongest relationships discovered.

| Delivery Speed | Average Rating |
|---------------|---------------:|
| Fast | 4.43 |
| Normal | 4.35 |
| Slow | 4.25 |
| Very Slow | 4.09 |
| Extremely Slow | 3.12 |

### Finding

Orders taking more than 20 days caused ratings to decline sharply.

---

## Freight Cost vs Review Score

Only a weak relationship was observed.

### Finding

Customers were far more sensitive to delivery delays than shipping costs.

---

# 👥 Customer Behaviour Analysis

## Frequency Distribution

Out of:

> 96,096 customers

Approximately:

> 93,099 customers purchased exactly once.

This corresponds to:

> ~97% one-time buyers.

---

# 🔥 Cohort Analysis

Customers were grouped based on their first purchase month.

Across almost every cohort:

- Thousands of customers joined
- Very few returned in subsequent months

Example:

### July 2018 Cohort

| Month Since First Purchase | Active Customers |
|---------------------------|---------------:|
| 0 | 6071 |
| 1 | 44 |
| 2 | 2 |

---

# 🚨 Biggest Discovery

Although revenue continued to grow, customer retention was extremely poor.

Growth depended heavily on continuously acquiring new customers.

---

# 🕵 Root Cause Analysis

After combining findings from multiple analyses, three major causes emerged.

---

## 1. Product Characteristics

Most top categories consisted of durable goods:

- Furniture
- Watches
- Home Decor
- Sports Equipment

These products naturally have lower repeat purchase frequencies.

---

## 2. Delivery Delays

Orders taking more than 20 days significantly reduced customer satisfaction.

---

## 3. Marketplace Behaviour

Customers typically:

```text
Need Product
      ↓
Buy Once
      ↓
Leave Platform
```

---

# ⚠ Problems Identified

### Customer Retention

Nearly 97% of customers purchased only once.

---

### Long Delivery Times

Orders exceeding 20 days caused ratings to deteriorate.

---

### Acquisition Dependency

Business growth relied heavily on acquiring new customers.

---

# 💡 Recommendations

## Improve Delivery Performance

Prioritize reducing orders with delivery times exceeding 20 days.

---

## Increase Repeat Purchases

Strategies:

- Loyalty programs
- Product recommendations
- Cross-selling
- Personalized campaigns

---

## Focus on Repeat-Friendly Categories

Strengthen categories such as:

- Beauty & Health
- Sports & Leisure

These categories have greater potential for recurring purchases.

---

# 🛠 Tools Used

- PostgreSQL
- SQL
- Window Functions
- CTEs
- Aggregate Functions
- Date Functions
- Cohort Analysis
- RFM Analysis
- Pareto Analysis
- Root Cause Analysis

---

# Key Learnings

This project reinforced an important principle:

> **Data analysis is not about calculating numbers.**

It is about asking:

- What happened?
- Why did it happen?
- What should the business do next?

Ultimately, analytics is the process of transforming:

```text
Raw Data
     ↓
Information
     ↓
Insights
     ↓
Decisions
     ↓
Business Value
```

---

# Final Verdict

| Area | Status |
|--------|---------|
| Revenue Growth | ✅ Strong |
| Customer Acquisition | ✅ Strong |
| Category Diversification | ✅ Healthy |
| Customer Diversification | ✅ Healthy |
| Customer Satisfaction | ✅ Good |
| Freight Cost Impact | ✅ Low |
| Delivery Performance | ⚠ Needs Improvement |
| Customer Retention | 🚨 Critical |
| Growth Dependency | 🚨 Acquisition Driven |

---

> **From numbers to story.**
>
> This project demonstrates how exploratory analysis, customer analytics, and root cause investigation can be combined to uncover the hidden drivers behind business performance.
