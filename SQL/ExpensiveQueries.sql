-- SQL adopted from http://blog.sqlauthority.com/2010/05/14/sql-server-find-most-expensive-queries-using-dmv/
SELECT TOP 10 SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(qt.TEXT)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2)+1),
qs.execution_count,
qs.total_logical_reads, qs.last_logical_reads,
qs.total_logical_writes, qs.last_logical_writes,
qs.total_worker_time,
qs.last_worker_time,
qs.total_elapsed_time/1000 total_elapsed_time_in_mS,
qs.last_elapsed_time/1000 last_elapsed_time_in_mS,
qs.last_execution_time,
qs.min_elapsed_time / 1000 min_elapsed_time_ms,
qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
where last_execution_time > '2016-07-22 15:30:00.000' and qp.dbid = DB_ID(N'DynamicsAX')
ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time