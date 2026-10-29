---
tags: [cv, job-search, experience]
company: Acme Retail
title: Senior Data Engineer
start: 2022-03
end: present
location: Guadalajara, Mexico
updated: 2026-01-15
---
# Acme Retail — Senior Data Engineer

Back to [[CV Database]] · Skills: [[Skills Inventory]]

**Official title:** Senior Data Engineer.

**Company one-liners**
- "Data platform team for a multi-country retail chain."

## Bullet bank
Latest/best wording first; older variants kept for extra detail. `[CV]` marks where each one appeared.

### Pipeline performance `#spark` `#data-eng`
- **Reduced nightly pipeline runtime by 35% by tuning PySpark joins, partitioning, and caching across the sales and inventory lakehouse.** [2026.01 Initech]
- Older variant: "Optimized Spark jobs for the sales lakehouse." [2024.05]

**Interview depth (keep off the CV):** the biggest win was replacing a skewed sort-merge join with a broadcast join on the store dimension.

### Orchestration `#orchestration`
- **Migrated 50+ legacy cron jobs to Apache Airflow DAGs with alerting and retries, improving failure detection.** [2026.01]

### Data quality `#quality` `#cicd`
- **Introduced data-quality checks in CI with Great Expectations, catching schema breaks before production.** [2026.01]
- ⚠️ No metric yet. Template: "Added [N] checks across [N tables], catching [N] incidents per quarter before production."
