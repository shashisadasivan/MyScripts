--Blocked queries
SELECT TOP 10 r.session_id, r.plan_handle,
r.sql_handle, r.request_id,      r.start_time, r.status,      r.command, r.database_id,      r.user_id, r.wait_type,      r.wait_time, r.last_wait_type,
r.wait_resource, r.total_elapsed_time,      r.cpu_time, r.transaction_isolation_level,      r.row_count, st.text
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) as st
WHERE r.blocking_session_id <> 0       -- blocked queries
and r.session_id in       (SELECT distinct(blocking_session_id)           FROM sys.dm_exec_requests)
GROUP BY r.session_id, r.plan_handle,      r.sql_handle, r.request_id,      r.start_time, r.status,      r.command, r.database_id,
r.user_id, r.wait_type,      r.wait_time, r.last_wait_type,      r.wait_resource, r.total_elapsed_time,
 r.cpu_time, r.transaction_isolation_level,      r.row_count, st.text
 ORDER BY r.total_elapsed_time desc

 -- serach for session
 select * from sys.dm_exec_requests where session_id = 223

 --Blocking queries
 SELECT
req.session_id,
req.status,
req.command,
req.cpu_time,
req.total_elapsed_time,
req.blocking_session_id
,sqltext.TEXT
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext

-- search SPID
exec sp_who2 -- get list of spids and possible applications
DBCC inputbuffer (<SPID>) -- get running query

-- KILL SPID
--KILL 143
