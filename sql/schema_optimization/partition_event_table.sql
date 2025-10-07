-- Example Event Table Partitioning (BY monthly timestamp)
-- Assuming original table: events
-- STEP 1: Create new partitioned table
CREATE TABLE IF NOT EXISTS events_partitioned (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    event_type TEXT NOT NULL,
    event_data JSONB,
    event_time TIMESTAMPTZ NOT NULL
) PARTITION BY RANGE (event_time);

-- STEP 2: Create partitions for current/future months (automatable)
CREATE TABLE IF NOT EXISTS events_2024_06 PARTITION OF events_partitioned
    FOR VALUES FROM ('2024-06-01') TO ('2024-07-01');
CREATE TABLE IF NOT EXISTS events_2024_07 PARTITION OF events_partitioned
    FOR VALUES FROM ('2024-07-01') TO ('2024-08-01');
-- Add more partitions as needed (scriptable via cron)

-- STEP 3: Index for fast OLTP and OLAP
CREATE INDEX IF NOT EXISTS idx_events_user_time ON events_partitioned (user_id, event_time DESC);
CREATE INDEX IF NOT EXISTS idx_events_type_time ON events_partitioned (event_type, event_time DESC);

-- STEP 4: Foreign Keys, Constraints and Triggers
-- Add as needed, keeping OLTP critical constraints optimized.

-- Optionally: Attach old 'events' data with ALTER TABLE ... ATTACH PARTITION, or migrate.
