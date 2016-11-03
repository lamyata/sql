declare @LotSidCode nvarchar(11) = 'LOT';
declare @SGNIcCode  nvarchar(50) = 'IC_SGN';

declare @LotSidId int;
declare @SGNIcId int;

select @SGNIcId = COMPANYNR from COMPANY where CODE = @SGNIcCode;
select @LotSidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @LotSidCode;

--update sic set LOT = sis.[VALUE]
select *
	from STOCK_INFO_CONFIG sic join STOCK_INFO_SID sis on sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID
		and sic.INTERNAL_COMPANY_ID != @SGNIcId
		and sis.SID_ID = @LotSidId


update STOCK_INFO_CONFIG
set _KEY_ = 
    STUFF ( _KEY_ , CHARINDEX(',"LOT":"', _KEY_) , CHARINDEX(',"PD":"', _KEY_) - CHARINDEX(',"LOT":"', _KEY_) , '"LOT":"' + ISNULL(LOT, '') )
	where sic.INTERNAL_COMPANY_ID != @SGNIcId

--update key
update STOCK_INFO_CONFIG
set _KEY_ = 
    STUFF ( _KEY_ , CHARINDEX(',"LOT":"', _KEY_) , CHARINDEX(',"PD":"', _KEY_) - CHARINDEX(',"LOT":"', _KEY_) , '"LOT":"' + ISNULL(LOT, '') )
	where sic.INTERNAL_COMPANY_ID != @SGNIcId
-- {"IC":1,"O":217,"P":776,"L":1266,"BU":7,"TN":"","IN":"","ST":0,"SU":null,"EU":[{"Id":"6"},{"Id":"11"}],"S":[{"1":"SGKS154099228"},{"21":"400064152"},{"22":"5"},{"23":""}]}

update STOCK_INFO_CONFIG
set _KEY_ = 
    STUFF ( _KEY_ , CHARINDEX(','"' + CAST(@LotSidId AS VARCHAR) + '":"', _KEY_) , CHARINDEX(',"PD":"', _KEY_) - CHARINDEX(',"LOT":"', _KEY_) , '"LOT":"' + ISNULL(LOT, '') )
	where sic.INTERNAL_COMPANY_ID != @SGNIcId
	
;WITH CTE (STOCK_INFO_CONFIG_ID, LotSidStart, LotSidEnd)
AS
(
    SELECT
		STOCK_INFO_CONFIG_ID,
		CHARINDEX(','"' + CAST(@LotSidId AS VARCHAR) + '":"', _KEY_) AS LotSidStart,
		CHARINDEX('"}', _KEY_, LotSidStart)
    FROM STOCK_INFO_CONFIG
    WHERE INTERNAL_COMPANY_ID != @SGNIcId
)
update sic
set _KEY_ = 
    STUFF ( _KEY_ , LotSidStart , LotSidEnd - LotSidStart , '' )
	FROM STOCK_INFO_CONFIG sic join CTE cte on sic.STOCK_INFO_CONFIG_ID = cte.STOCK_INFO_CONFIG_ID

--delete sis
select sis.*
	from STOCK_INFO_CONFIG sic join STOCK_INFO_SID sis on sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID
		and sic.INTERNAL_COMPANY_ID != @SGNIcId
		and sis.SID_ID = @LotSidId

select * from PRODUCT_STORAGE_IDENTIFIER psi
	where psi.SID_ID = @LotSidId
	and not exists (select 1 from PRODUCT_INT_COMPANY pic where pic.PRODUCT_ID = psi.PRODUCT_ID and pic.INT_COMPANYNR = @SGNIcId)


	