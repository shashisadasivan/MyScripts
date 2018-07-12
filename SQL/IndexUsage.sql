-- Script from https://www.mssqltips.com/sqlservertip/1239/how-to-get-index-usage-information-in-sql-server/
SELECT   OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME],
         I.[NAME] AS [INDEX NAME],
         USER_SEEKS,
         USER_SCANS,
         USER_LOOKUPS,
         USER_UPDATES
FROM     SYS.DM_DB_INDEX_USAGE_STATS AS S
         INNER JOIN SYS.INDEXES AS I
           ON I.[OBJECT_ID] = S.[OBJECT_ID]
              AND I.INDEX_ID = S.INDEX_ID
WHERE    OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1
and S.OBJECT_ID = OBJECT_ID(N'dbo.INVENTDIM') -- Indexes for this table only
-- and S.[object_id] in (OBJECT_ID('VendInvoiceJour'), OBJECT_ID('PROJPROPOSALJOUR'), OBJECT_ID('VENDTRANS'), OBJECT_ID('PROJITEMTRANS'), OBJECT_ID('SALESLINE'), OBJECT_ID('PROJINVOICEJOUR'), OBJECT_ID('KOO_TMSTranHeader'))
