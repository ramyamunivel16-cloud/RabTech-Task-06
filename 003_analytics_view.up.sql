BEGIN;

CREATE MATERIALIZED VIEW IF NOT EXISTS sales_daily_summary AS
SELECT
    (s.sale_date AT TIME ZONE 'UTC')::date AS sale_date,
    COUNT(DISTINCT s.sale_id) AS sale_count,
    SUM(si.quantity) AS units_sold,
    SUM(si.quantity * si.unit_price)::NUMERIC(14,2) AS revenue
FROM sales s
JOIN sale_items si ON si.sale_id = s.sale_id
GROUP BY (s.sale_date AT TIME ZONE 'UTC')::date
WITH DATA;

CREATE UNIQUE INDEX IF NOT EXISTS idx_sales_daily_summary_date
ON sales_daily_summary(sale_date);

COMMIT;
