INSERT INTO [dbo].[DISCHARGING_TARIFF_TRANSPORT_TYPE]
		([DISCHARGING_TARIFF_ID]
		,[TRANSPORT_TYPE_ID])
SELECT 374
		,[TRANSPORT_TYPE_ID]
FROM TRANSPORT_TYPE tt where tt.INTERNAL_COMPANY_NR = 1 and tt.CODE in ('TR', 'TRSI', 'TRTL', 'BA', 'VE')