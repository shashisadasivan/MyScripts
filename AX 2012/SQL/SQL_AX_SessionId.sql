--https://blogs.msdn.microsoft.com/amitkulkarni/2011/08/10/finding-user-sessions-from-spid-in-dynamics-ax-2012/
select cast(context_info as varchar(128)) as ci,* from sys.dm_exec_sessions
  where program_name like '%Dynamics%'
  and database_id = DB_ID('Dynamics_AX')
