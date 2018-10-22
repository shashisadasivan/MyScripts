-- Find LEDGERDIMENSION from TaxTrans when it relates to a AP Invoice Journal
select
	taxTrans.RecId, dimAttribCombVal.DISPLAYVALUE, dimAttribCombVal.MAINACCOUNTVALUE, TaxTrans.*
	from Taxtrans
	join VENDINVOICETRANS vendInvTrans
		on vendInvTrans.RECID = taxTrans.SOURCERECID
		and TaxTrans.SOURCETABLEID = 10699
	join ACCOUNTINGDISTRIBUTION accDist
		on accDist.SOURCEDOCUMENTLINE = vendInvTrans.SOURCEDOCUMENTLINE
	join DIMENSIONATTRIBUTEVALUECOMBINATION dimAttribCombVal
		on dimAttribCombVal.RECID = accDist.LEDGERDIMENSION
	where TaxTrans.VOUCHER = 'PTI0000101'


-- Find LEDGERDIMENSION from TaxTrans when it relates to a General Journal
select TaxTrans.RECID, dimAttribCombVal.DISPLAYVALUE, dimAttribCombVal.MAINACCOUNTVALUE , TaxTrans.* from TAXTRANS
       join LedgerJournalTrans jourTrans
              on JourTrans.RECID = TaxTrans.SourceRecId
              and taxTrans.SOURCETABLEID = 10969 -- LedgerJournalTrans
    join DIMENSIONATTRIBUTEVALUECOMBINATION dimAttribCombVal
              on dimAttribCombVal.RECID = jourTrans.LEDGERDIMENSION
where TaxTrans.VOUCHER = 'VIJ000053'
