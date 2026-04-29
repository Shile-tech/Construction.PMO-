# 🏗️ Construction Project Performance Analytics

 Turning construction project data into decisions, a full analytics pipeline using SQL Server and Excel.

SQL and Excel analysis of 50 construction projects across Nigeria uncovering cost overrun drivers, schedule delay patterns, and contractor performance to support data driven project management decisions.

---

## 📌 Project Background

Infrastructure projects in Nigeria and across much of the developing world routinely suffer from cost overruns, schedule delays, and inconsistent contractor performance. Yet most Project Management Offices (PMOs) lack structured data analysis to understand 'why' this happens or 'where' to intervene.

This project simulates the work of a data analyst embedded in a Nigerian construction PMO. Using a structured dataset of 50 projects across 10 states, the analysis moves from raw data to actionable recommendations that project managers and executives can act on.

---

## 🎯 Business Questions Answered

1. Which projects had the highest cost and schedule overruns and what drove them?
2. Which project phases are the biggest risk areas for budget blowout?
3. Does contractor selection predict project performance?
4. What early warning signs indicate a project is heading for trouble?
5. Where should a PMO focus its improvement efforts?

---

## 🗂️ Dataset Structure

The dataset consists of three related tables:

| Table | Rows | Description |
|---|---|---|
| `Projects` | 50 | Master project records — budget, cost, schedule, status |
| `Phase_Breakdown` | 300 | Cost breakdown across 6 project phases per project |
| `Contractor_Scorecard` | 10 | Aggregated contractor performance metrics |

**Key fields:** `budget_NGN`, `actual_cost_NGN`, `cost_overrun_NGN`, `sched_delay_months`, `prim_delay_reas`, `status`, `perct_completed`

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **SQL Server (SSMS)** | Data structuring, cleaning, validation & analysis |
| **Microsoft Excel** | Visual inspection, dashboard & final reporting |
| **GitHub** | Version control & project documentation |

---

## 🔄 Project Workflow

```
Phase 1 → Data Design & Generation
Phase 2 → Data Cleaning & Structuring (SQL Server)
Phase 3 → SQL Analysis (Business Questions)
Phase 4 → Visualization & Dashboard (Excel)
Phase 5 → Insight Report & Recommendations
```

---

## 📁 Repository Structure

```
construction-pmo-analytics/
│
├── data/
│   └── Construction_Analytics_Dataset.xlsx   # Raw dataset (3 tables)
│
├── sql/
│   ├── 01_create_tables.sql                  # DDL — table creation
│   ├── 02_data_validation.sql                # Cleaning & integrity checks
│   └── 03_analysis_queries.sql               # Business analysis queries
│
├── dashboard/
│   └── Construction_Dashboard.xlsx           # Excel insight dashboard
│
├── report/
│   └── PMO_Insight_Report.pdf                # Final recommendations report
│
└── README.md
```

---

## 📊 Key Findings

- **Cost Overrun Rate:** 94% of projects (47 out of 50) exceeded their approved budgets
- **Total Net Cost Overrun:** ₦15.1 billion across the entire portfolio
- **Highest Individual Overrun:** PRJ-005 (Kano Erosion Control Phase 2) -- ₦842.8M over budget (54.1% overrun)
- **Most Risk-Prone Phase:** Procurement -- averaging 24.1% cost overrun, the highest of all 6 project phases
- **Worst Performing Contractor:** Horizon Builders -- performance score of 25.7% across 10 projects (31.4% avg cost overrun, 42.9% avg duration overrun)
- **Best Performing Contractor:** Grandeur Works -- performance score of 53.0% with the lowest avg cost overrun (18.8%)
- **Average Schedule Delay:** 10.4 months across all active projects
- **Top Delay Driver:** Funding delays, contractor defaults, and poor site supervision are the most frequent causes of high-risk project outcomes

---

## 💡 Key Skills Demonstrated

- Relational database design (Primary Keys, Foreign Keys, CHECK constraints)
- Data validation and integrity checking in SQL Server
- Aggregation, grouping, CTE and window functions in SQL
- Financial data analysis (budget variance, overrun rates)
- Executive level dashboard design in Excel
- Translating data findings into business recommendations

---

## 👤 Author

**MONSURU ADELEKE**
Data Analyst | Civil Engineering Graduate
📍 Nigeria
🔗 www.linkedin.com/in/adeleke-monsuru
📧 adelekemonsuru840@gmail.com

---

## 📄 License

This project is licensed under the **MIT License** — see below for details.

```
MIT License

Copyright (c) 2024 MONSURU ADELEKE

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

---

*⭐ If you found this project useful or insightful, feel free to star the repository!*
