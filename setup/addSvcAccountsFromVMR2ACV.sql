declare @IcId int = 220 -- SGN
insert into SERVICE_ACCOUNT
select ACCOUNT, DESCRIPTION, @IcId, DIRECTION, 'la170518', getdate(), 'la170518', getdate() from SERVICE_ACCOUNT as sa where INTERNAL_COMPANY_ID = 299
	and not exists (select * from SERVICE_ACCOUNT where ACCOUNT = sa.ACCOUNT and INTERNAL_COMPANY_ID = @IcId)