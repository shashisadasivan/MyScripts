-- Start in master
USE MASTER;

--SET DEADLOCK_PRIORITY HIGH
-- Add users
ALTER DATABASE [AxDB] SET MULTI_USER --WITH ROLLBACK IMMEDIATE
GO