-- Identify holding and waiting queries with lock contention
SELECT
    blocked.pid AS blocked_pid,
    blocked.usename AS blocked_user,
    blocked.query AS blocked_query,
    blocking.pid AS blocking_pid,
    blocking.usename AS blocking_user,
    blocking.query AS blocking_query,
    blocked.locktype,
    blocked.relation::regclass AS locked_relation,
    blocked.transactionid
FROM pg_catalog.pg_locks blocked
JOIN pg_catalog.pg_stat_activity blocked_act ON blocked.pid = blocked_act.pid
JOIN pg_catalog.pg_locks blocking ON blocking.locktype = blocked.locktype
    AND blocking.DATABASE IS NOT DISTINCT FROM blocked.DATABASE
    AND blocking.relation IS NOT DISTINCT FROM blocked.relation
    AND blocking.page IS NOT DISTINCT FROM blocked.page
    AND blocking.tuple IS NOT DISTINCT FROM blocked.tuple
    AND blocking.virtualxid IS NOT DISTINCT FROM blocked.virtualxid
    AND blocking.transactionid IS NOT DISTINCT FROM blocked.transactionid
    AND blocking.classid IS NOT DISTINCT FROM blocked.classid
    AND blocking.objid IS NOT DISTINCT FROM blocked.objid
    AND blocking.objsubid IS NOT DISTINCT FROM blocked.objsubid
JOIN pg_catalog.pg_stat_activity blocking_act ON blocking.pid = blocking_act.pid
WHERE NOT blocked.granted AND blocking.granted
ORDER BY blocked.query_start, blocking.query_start;
