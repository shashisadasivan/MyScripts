SELECT
    s.program_name,
    cast(r.context_info as varchar(128)) as context_info,
    cast(bls.context_info as varchar(128)) as context_info,
    r.session_id,
    r.blocking_session_id,
    r.start_time,
    r.status,
    r.wait_type,
    r.wait_time,
    r.command,
    DB_Name(s.database_id) as db_name,
    s.host_name,
    s.login_name,
    --r.blocking_session_id,
    r.scheduler_id,
    r.cpu_time,
    r.total_elapsed_time,
    mg.requested_memory_kb,
    mg.granted_memory_kb,
    mg.used_memory_kb,
    mg.max_used_memory_kb,
    r.reads,
    r.writes,
    r.logical_reads,
    tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count AS writes_in_tempdb,
    --r.transaction_isolation_level,
    r.row_count,
    r.task_address,
    s.client_interface_name,
    r.query_hash,
    r.query_plan_hash,
    r.sql_handle,
    r.plan_handle,
    r.database_id,
    qp.query_plan,
    st.text,
    r.statement_start_offset/2 AS statement_start_offset,
    r.statement_end_offset/2 AS statement_end_offset,
    --SUBSTRING(st.text, r.statement_start_offset/2, r.statement_end_offset/2 - r.statement_start_offset/2) AS current_text,
    OBJECT_NAME(st.objectid, st.dbid) AS object_name,
    bst.text as blocking_text
FROM sys.dm_exec_requests AS r
JOIN sys.dm_exec_sessions AS s
    ON s.session_id = r.session_id
JOIN sys.dm_db_task_space_usage AS tsu
    ON s.session_id = tsu.session_id
    AND r.task_address = tsu.task_address
LEFT JOIN sys.dm_exec_query_memory_grants AS mg
    ON s.session_id = mg.session_id
OUTER APPLY sys.dm_exec_query_plan(r.plan_handle) AS qp
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
LEFT JOIN sys.dm_exec_requests AS br
    ON r.blocking_session_id = br.session_id
OUTER APPLY sys.dm_exec_sql_text(br.sql_handle) AS bst
LEFT JOIN sys.dm_exec_sessions bls
    on r.blocking_session_id = bls.session_id
WHERE
    r.session_id <> @@spid
    AND r.status IN('running', 'runnable', 'suspended', 'rollback', 'sleeping')
	--and r.database_id = DB_ID('DynamicsAX_AUDC')
    --and host_name = 'AU1KATHMAP25P'
ORDER BY start_time

/*
declare @sessionid int = 63

SELECT t.text
FROM sys.dm_exec_connections c
CROSS APPLY sys.dm_exec_sql_text (c.most_recent_sql_handle) t
WHERE session_id = @sessionid

-- return from the above then try this
SELECT c.session_id, c.properties, c.creation_time, c.is_open, t.text,c.*
FROM sys.dm_exec_cursors (@sessionid) c
CROSS APPLY sys.dm_exec_sql_text (c.sql_handle) t

dbcc inputbuffer(@sessionid)

-- Kill 63
*/
