--SQL 2016 onwards
SELECT top 10
			q.query_id
              ,q.query_text_id
              ,OBJECT_NAME(q.object_id) AS OBJECT_NAME
              ,q.query_hash
              ,qp.plan_id
              ,qp.query_plan_hash
              ,qt.query_sql_text
              ,qp.query_plan
              ,rs.runtime_stats_interval_id
              ,rs.execution_type
              ,rs.execution_type_desc
              ,rs.count_executions
              ,rs.avg_duration
              ,rs.last_duration
              ,rs.min_duration
              ,rs.max_duration
              ,rs.avg_cpu_time
              ,rs.last_cpu_time
              ,rs.min_cpu_time
              ,rs.max_cpu_time
              ,rs.avg_logical_io_reads
              ,rs.last_logical_io_reads
              ,rs.min_logical_io_reads
              ,rs.max_logical_io_reads
              ,rs.avg_logical_io_writes
              ,rs.last_logical_io_writes
              ,rs.min_logical_io_writes
              ,rs.max_logical_io_writes
              ,rs.avg_physical_io_reads
              ,rs.last_physical_io_reads
              ,rs.min_physical_io_reads
              ,rs.max_physical_io_reads
              ,rs.avg_dop
              ,rs.last_dop
              ,rs.min_dop
              ,rs.max_dop
              ,rs.avg_query_max_used_memory
              ,rs.last_query_max_used_memory
              ,rs.min_query_max_used_memory
              ,rs.max_query_max_used_memory
              ,rs.avg_rowcount
              ,rs.last_rowcount
              ,rs.min_rowcount
              ,rs.max_rowcount
              ,qi.start_time
              ,qi.end_time
FROM sys.query_store_plan qp
INNER JOIN sys.query_store_runtime_stats rs ON qp.plan_id = rs.plan_id
INNER JOIN sys.query_store_runtime_stats_interval qi ON qi.runtime_stats_interval_id = rs.runtime_stats_interval_id
INNER JOIN sys.query_store_query q ON qp.query_id = q.query_id
INNER JOIN sys.query_store_query_text qt ON q.query_text_id = qt.query_text_id
WHERE 1 = 1
              --and query_sql_text like '%SalesOrderDetail_test%' and query_sql_text like '%select%'
				and query_sql_text like '%update LEDGERJOURNALTRANS%'
              --and q.query_text_id not in( 40,41)
              --and query_hash in (0x07CD5A833DF184E2,0x662E79A84FD3D111)
                --and q.query_id = 15
              --  order by q.query_text_id
Order by qi.start_time desc
