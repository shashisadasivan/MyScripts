select et.ElementTypeName, et.TreeNodeName, med1.ParentHandle, med1.ElementHandle, me.* from ModelElementData med1
join ModelElement me
	on ((me.ElementHandle = med1.ParentHandle and med1.ParentHandle <> 0)
				or (med1.ParentHandle = 0 and me.ElementHandle = med1.ElementHandle))
join ElementTypes et
	on et.ElementType = me.ElementType		
		
where med1.ModelId in (27,29) -- base models that have changed (like hotfix)
and med1.ElementHandle in (select medisv.ElementHandle from ModelElementData medisv 
									where medisv.ModelId in (21,22,23,24,25,26)) -- Models to compare it to, like custom CUS, var layer etc
order by me.ElementType	

--select medisv.* from ModelElementData medisv 
--where medisv.ModelId in (21,22,23,24,25,26)