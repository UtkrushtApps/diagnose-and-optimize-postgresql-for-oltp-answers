# Solution Steps

1. Use pg_locks and pg_stat_activity to analyze and confirm lock contention between OLAP and OLTP queries. Deploy the diagnostic SQL (lock_analysis.sql) and optionally the helper function (monitor_locks_function.sql) for ongoing use.

2. Redesign the busiest 'events' table from a monolithic structure into a partitioned table using range partitioning (event_time) for scale. Create new partitions monthly, migrate historic data, and introduce composite indexes on user_id, event_type, and event_time (partition_event_table.sql).

3. Optimize the 'report' table for common analytic queries: add indexes on report_type, generated_at, and user_id—taking care to index heavily filtered columns, including support for JSONB fields if required (index_report_table.sql).

4. Implement query-level statement_timeout and lock_timeout settings to provide fast failure for OLTP (API) roles and controlled limits for OLAP/reporting users. Set these at ROLE or DATABASE level as appropriate for the platform (set_timeouts.sql).

5. Identify expensive recurring analytics (e.g., daily event aggregation) and implement materialized views to precompute and cache results. Index the materialized view for fast slicing (materialize_analytics.sql), and regularly refresh the view.

6. Monitor locks and performance post-implementation by running the helper function 'show_blocking_locks' or lock_analysis query, and adjust indexes, partitions, or timeout settings as workloads evolve.

