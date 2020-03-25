--Create a view in [DYNAMICSXREFDB]


CREATE VIEW [dbo].[Dependencies]
AS
SELECT        CASE WHEN refs.Kind = 9 THEN 'Tag' WHEN refs.Kind = 8 THEN 'TestHelperCall' WHEN refs.Kind = 7 THEN 'Attribute' WHEN refs.Kind = 6 THEN 'Property' WHEN refs.Kind = 5 THEN 'TestCall' WHEN refs.Kind = 4
                          THEN 'ClassExtend' WHEN refs.Kind = 3 THEN 'Interface' WHEN refs.Kind = 2 THEN 'TypeReference' WHEN refs.Kind = 1 THEN 'MethodCall' ELSE 'Any' END AS Kind, refs.Kind AS KindId,
                         sourceName.Id AS SourceId, sourceName.Path AS SourcePath, sourceModule.Module AS SourceModule, targetName.Id AS TargetId, targetName.Path AS TargetPath, targetModule.Module AS TargetModule
FROM            dbo.[References] AS refs INNER JOIN
                         dbo.Names AS sourceName ON refs.SourceId = sourceName.Id INNER JOIN
                         dbo.Names AS targetName ON refs.TargetId = targetName.Id INNER JOIN
                         dbo.Modules AS targetModule ON targetName.ModuleId = targetModule.Id INNER JOIN
                         dbo.Modules AS sourceModule ON sourceName.ModuleId = sourceModule.Id



GO

--And then just run a query on the view

SELECT d1.TargetModule, d1.TargetPath
  FROM [DYNAMICSXREFDB].[dbo].[Dependencies] d1
  where d1.TargetPath like 'MenuItem%'
  and not exists (select 'x' from [DYNAMICSXREFDB].[dbo].[Dependencies] d2
    where d1.TargetId = d2.TargetId
    and d2.SourcePath like 'SecurityPrivilege%')
    group by d1.TargetModule, d1.TargetPath
