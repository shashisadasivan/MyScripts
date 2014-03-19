2012--
select * from ElementTypes order by ElementTypeName

Select L.Name as 'Layer', D.MODELID, M.NAME as 'Model Name', t.ElementTypeName, Eroot.NAME as 'Root', E.* 
from SYSMODELELEMENT E 
join ElementTypes t on t.ElementType = E.ELEMENTTYPE
join SYSMODELELEMENTDATA D on D.MODELELEMENT = E.RECID
join Layer L on L.Id = D.LAYER
join SYSMODELMANIFEST M on m.MODEL = D.MODELID and M.MODEL in (24,25,26)
join SYSMODELELEMENT ERoot on ERoot.RECID = E.ROOTMODELELEMENT
where E.ELEMENTTYPE in (44,42) 
order by E.ROOTMODELELEMENT, E.RECID, E.NAME 

select * from ModelElement where ElementType in (44,42)

select * from SYSMODELELEMENTDATA
select * from SYSMODELMANIFEST
select * from MODEL
select * from Layer

2012 R2 --
Select L.Name as 'Layer', D.MODELID, M.NAME as 'Model Name', t.ElementTypeName, Eroot.NAME as 'Root', E.* 
from SYSMODELELEMENT E 
join ElementTypes t on t.ElementType = E.ELEMENTTYPE
join SYSMODELELEMENTDATA D on D.MODELELEMENT = E.RECID
join Layer L on L.Id = D.LAYER
join SYSMODELMANIFEST M on m.MODEL = D.MODELID and M.MODEL in (20,21)
join SYSMODELELEMENT ERoot on ERoot.RECID = E.ROOTMODELELEMENT
where E.ELEMENTTYPE in (44,42) 
order by E.ROOTMODELELEMENT, E.RECID, E.NAME 


select * from SYSMODELMANIFEST
select * from MODEL

--Comparison
select * from PAY_2012_CU2
select * from PAY_2012_R2

select cu2.* from PAY_2012_CU2 cu2
where not exists 
(select * from PAY_2012_R2 r2
	where r2.NAME = cu2.NAME
	and r2.ElementTypeName = cu2.ElementTypeName)

select R2.* from PAY_2012_R2 r2
where not exists 
(select * from PAY_2012_CU2 cu2
	where r2.NAME = cu2.NAME
	and r2.ElementTypeName = cu2.ElementTypeName)
	
select * from PAY_2012_CU2
where ORIGIN not in (select ORIGIN from PAY_2012_R2)


	
select * from PAY_2012_R2
where ORIGIN not in (select ORIGIN from PAY_2012_CU2)

----Compare objects common in between layers (compare objects in ISV / ISP layer to higher ones)
Select L.Name as 'Layer', /*D.MODELID,*/ M.NAME as 'Model Name', Eroot.RECID as 'Root RecId', Eroot.NAME as 'Root', tRoot.ElementTypeName as 'Root Element type', t.ElementTypeName, E.NAME, E.ROOTMODELELEMENT, E.PARENTMODELELEMENT, E.PARENTID, E.AXID 
from SYSMODELELEMENT E 
join ElementTypes t on t.ElementType = E.ELEMENTTYPE
join SYSMODELELEMENTDATA D on D.MODELELEMENT = E.RECID
join Layer L on L.Id = D.LAYER
and l.Id >= 10
join SYSMODELMANIFEST M on m.MODEL = D.MODELID 
--and M.MODEL in (20,21)
join SYSMODELELEMENT ERoot on ERoot.RECID = E.ROOTMODELELEMENT
join ElementTypes tRoot on tRoot.ElementType = ERoot.ELEMENTTYPE
where E.RECID in
(	
	Select E1.RecId
	from SYSMODELELEMENT E1
	join SYSMODELELEMENTDATA D1 on D1.MODELELEMENT = E1.RECID
	join Layer L1 on L1.Id = D1.LAYER
	and L1.Id in (8,9)
	--order by E1.RECID
)
-- Eroot.RecId is unique
--where E.ELEMENTTYPE in (44,42) 
order by L.Name, M.NAME, E.ROOTMODELELEMENT, E.RECID, E.NAME 




------Models that I need to send

DECLARE @DATEMODIFIED nvarchar(100)
DECLARE @ELEMENTTYPESUNWANTED as TABLE (Id int not null)
DECLARE @LAYERSUNWANTED as Table (Layername nvarchar(250) not null)

---Set values here
--Date since when objects have been modified
SET @DATEMODIFIED = '2013-11-30'
--Unwanted Element types
INSERT INTO @ELEMENTTYPESUNWANTED (Id) values (23), (24) --23: ClassHeader, 24: TableHeader
--Unwanted layers
INSERT INTO @LAYERSUNWANTED (Layername) values ('SYS'), ('SYP'), ('FPP'), ('FPK')


--List Of elements that have changed--
select L.Name, SYSMM.DISPLAYNAME as 'Model', MED.ModelId,MED.MODIFIEDDATETIME, MED.CREATEDDATETIME, MED.MODIFIEDBY, ME.Name, ET.ElementTypeName, ME.ElementType
from ModelElement ME
join ModelElementData MED on MED.ElementHandle = ME.ElementHandle
join ElementTypes ET on ET.ElementType = ME.ElementType
join SYSMODELMANIFEST SYSMM on SYSMM.MODEL = MED.ModelId
join Layer L on L.Id = MED.LayerId
where MED.MODIFIEDDATETIME >= CONVERT(dateTime, @DATEMODIFIED)
and ME.ElementType not in (select Id from @ELEMENTTYPESUNWANTED)
and L.Name not in (select Layername from @LAYERSUNWANTED)
order by MED.MODIFIEDDATETIME desc


--List of Models That has been updated--
select L.Name, SYSMM.DISPLAYNAME, MED.ModelId, MAX(MED.MODIFIEDDATETIME) as LastModified
from ModelElement ME
join ModelElementData MED on MED.ElementHandle = ME.ElementHandle
join ElementTypes ET on ET.ElementType = ME.ElementType
join SYSMODELMANIFEST SYSMM on SYSMM.MODEL = MED.ModelId
join Layer L on L.Id = MED.LayerId
where MED.MODIFIEDDATETIME >= CONVERT(dateTime, @DATEMODIFIED)
and ME.ElementType not in (select Id from @ELEMENTTYPESUNWANTED)
and L.Name not in (select Layername from @LAYERSUNWANTED)
group by SYSMM.DISPLAYNAME, MED.ModelId, L.Name
order by L.Name