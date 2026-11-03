-- Refresh after new sales have been recorded.
REFRESH MATERIALIZED VIEW CONCURRENTLY sales_daily_summary;
