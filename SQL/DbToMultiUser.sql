-- Start in master
USE MASTER;

--SET DEADLOCK_PRIORITY HIGH
-- Add users
ALTER DATABASE [AxDB] SET MULTI_USER --WITH ROLLBACK IMMEDIATE
GO


--Incase there are services to kill.
-- Make sure to stop the Batch services
/*
SELECT db_name(resource_database_id) AS DB_Name, request_session_id
FROM sys.dm_tran_locks l
WHERE resource_type = 'DATABASE'
  AND EXISTS (SELECT * FROM sys.dm_exec_sessions s 
                WHERE l.request_session_id = s.session_id
                  AND s.is_user_process = 1)
  and resource_database_id = db_id('AXDB')
*/
--  KILL 57
