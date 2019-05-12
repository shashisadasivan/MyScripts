-- set the database to single user mode (Discoonnects all users)
-- then make it available again

USE master;
GO

ALTER DATABASE [<AxDB>]
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

-- Do something here if you want
--ALTER DATABASE [AxDB]
--SET READ_ONLY;
--GO

ALTER DATABASE [AxDB]
SET MULTI_USER;
GO
