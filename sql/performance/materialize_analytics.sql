-- Example materialized view for frequent analytics (per day, event_type)
CREATE MATERIALIZED VIEW IF NOT EXISTS events_agg_daily AS
SELECT
    event_type,
    date_trunc('day', event_time) AS event_date,
    COUNT(*) AS event_count,
    COUNT(DISTINCT user_id) AS unique_users
FROM events_partitioned
GROUP BY event_type, event_date;

CREATE UNIQUE INDEX IF NOT EXISTS idx_events_agg_daily_type_date
  ON events_agg_daily (event_type, event_date);

-- To keep fresh (nightly or more frequent):
-- REFRESH MATERIALIZED VIEW CONCURRENTLY events_agg_daily;
