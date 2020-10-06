/*
Find the Entity taking the most time in the BYOD export
*/

select TargetStatus, NoOfRecords, 
--DATEDIFF(minute, StartDateTime, EndDateTime) AS Diff,
--DATEDIFF(minute, WriteStartDateTime, EndDateTime) AS Diff,
DATEDIFF(minute, IIF(StartDateTime > '1900-01-01 00:00:00.000', StartDateTime, WriteStartDateTime), EndDateTime) AS Diff,
WriteStartDateTime, StartDateTime,EndDateTime, * from DMFDefinitionGroupExecution
where 1=1
and executionid = '<executionId>' 
order by Diff desc
