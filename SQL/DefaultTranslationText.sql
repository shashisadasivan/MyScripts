-- Lot of the Descriptions and names may come across as @SYSXXXX these arent translated in the forms
-- But for some reasons the en-us language is always in plain text and not label id
-- Since not all of us live in the US this script should copy the text from the en-us description

-- Fixes the location Role in the Address:
update LRT
	set LRT.DESCRIPTION = LRTUS.DESCRIPTION
	from LOGISTICSLOCATIONROLETRANSLATION LRT
	join LOGISTICSLOCATIONROLETRANSLATION LRTUS
		on LRTUS.PARTITION = LRT.PARTITION and LRTUS.LOCATIONROLE = LRT.LOCATIONROLE and LRTUS.LANGUAGEID = 'en-us'
		
-- Fixes Country names
update LRT
	set LRT.LONGNAME = LRTUS.LONGNAME, LRT.SHORTNAME = LRTUS.SHORTNAME
	from LOGISTICSADDRESSCOUNTRYREGIONTRANSLATION LRT
		join LOGISTICSADDRESSCOUNTRYREGIONTRANSLATION LRTUS 
			on LRTUS.COUNTRYREGIONID = LRT.COUNTRYREGIONID
			and LRTUS.PARTITION = LRT.PARTITION
			and LRTUS.LANGUAGEID = 'en-us'
		where LRT.LONGNAME like '@%'
			and LRT.LANGUAGEID <> 'en-us'