-- Query sessions currently locked in SQL
SELECT * FROM sys.dm_exec_requests where DB_NAME(database_id)='DynamicsAX_Prod' and blocking_session_id <>0

--User session in SQL - Map to AX User sessions
select cast(context_info as varchar(128)) as ci,* from sys.dm_exec_sessions where program_name like '%Dynamics%'
