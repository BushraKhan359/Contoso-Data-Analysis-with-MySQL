# Key Findings — Contoso Retail SQL Analysis

## Dataset
- **Source:** Contoso Retail Data Warehouse
- **Tool:** MySQL Workbench
- **Period:** 2007–2009
- **Tables:** factsales, factonlinesales, dimcustomer, dimproduct, dimproductcategory, dimproductsubcategory, dimchannel, dimstore, dimgeography

---

## Q1 — Sales & Profit Trends
- Store/Catalog/Reseller channels: Jan 2007 started at 111K orders, $270M revenue, $152M profit
- Online channel: Jan 2007 at 357K orders, $80M revenue, $34M profit
- Online drives higher order volume; physical channels drive higher revenue per order

---

## Q2 — Product Category Analysis
| Category | Revenue | Profit Margin |
|---|---|---|
| Home Appliances | $834M | ~57% |
| Computers | High revenue | ~57% |
| Cameras & Camcorders | $1.5bn | 57.3% (highest) |
| Games & Toys | Low | 48.7% (lowest) |

- Margin is remarkably consistent (~56–57%) across most categories
- Games & Toys is the outlier with the lowest margin

---

## Q3 — Customer Segmentation
- **B2B dominates:** Company customers = $2.03bn revenue vs Person = $686M (3× more)
- Top customer (CS586) spent $19.1M — all top spenders are Company type
- B2B generates 3× more revenue despite being a smaller customer count

---

## Q4 — Channel Analysis
| Channel | Revenue | Margin |
|---|---|---|
| Store | $6.9bn | 56.9% |
| Online | $2.7bn | 56.6% |
| Reseller | $1.7bn | 56.8% |
| Catalog | $1.1bn | 56.7% |

- Store is the clear leader at $6.9bn
- All channels have nearly identical margins (~56.6–56.9%) — pricing is highly consistent across channels

---

## Q5 — Regional Analysis
- **USA #1** — $7bn revenue
- **China #2** — $1.7bn revenue
- **Germany #3** — $811M revenue
- Data quality note: "Germany" appears twice with a trailing space — dirty source data

---

## Q6 — RFM Analysis (B2C / Person customers only)
| Segment | Customers | % |
|---|---|---|
| Recent Customers | 1,471 | 35.8% |
| Lost | 1,468 | 35.8% |
| Potential Loyalists | 997 | 24.3% |
| Loyal Customers | 170 | 4.1% |

- No Champions segment exists — Contoso's B2C base is largely transactional
- Only 4.1% are Loyal Customers — significant retention opportunity

---

## Q7 — Customer Lifetime Value
- 2,000 Person customers analyzed
- Top CLV: $664K over 8.45 years
- All top CLV customers are Person (B2C) type

---

## Q8 — Demographics
- Senior age group dominates spending
- Company customers show NULL gender (expected — companies have no gender field)
- B2C skews heavily Senior — marketing implication for targeting

---

## Q9 — Cohort Analysis
- Jan 2007 cohort: 13,140 customers
- Month 1 retention: **96.4%**
- Month 12 retention: **77.3%**
- Exceptionally high retention rates — strongest finding in the entire analysis

---

## Q10 — ABC Analysis
| Tier | Products | % of Catalogue | % of Revenue |
|---|---|---|---|
| A | 661 | 26.3% | 70% |
| B | 665 | 26.4% | 20% |
| C | 1,190 | 47.3% | 10% |

- Textbook Pareto principle: ~26% of products drive 70% of revenue
- Nearly half the catalogue (C tier) contributes only 10% of revenue
