DBCC SHRINKDATABASE (<database_name>, 0) -- 0 represents the % you want to leave as unallocated UsedSpaceKB

EXEC sp_spaceused -- size of the database
