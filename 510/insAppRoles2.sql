create procedure CreateApplicationRole
  @Name nvarchar(100)
as
begin

set nocount on

declare @ApplicationName nvarchar(50) = 'iTos'
INSERT INTO [dbo].[APPLICATION_ROLE]
 ([NAME]
 ,[APPLICATION_ID]
 ,[DESCRIPTION]
 ,[CREATE_USER]
 ,[CREATE_TIMESTAMP]
 ,[UPDATE_USER]
 ,[UPDATE_TIMESTAMP])
SELECT
  @Name
  ,APPLICATION_ID
  ,@Name
  ,'System'
  ,getdate()
  ,'System'
  ,getdate()
FROM [dbo].[APPLICATION]
where NAME = @ApplicationName;
					 
set nocount off

end
go

exec CreateApplicationRole 'VMG_Operations';
exec CreateApplicationRole 'VMG_Invoicing';
exec CreateApplicationRole 'HH_Scanning';
exec CreateApplicationRole 'VMG_CRM'
exec CreateApplicationRole 'VMG_ADMIN'
drop procedure CreateApplicationRole

declare @ApplicationName nvarchar(50) = 'iTos'
exec INSERT_PAGE @ApplicationName,'OrdersDefault.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Order/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Transport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportPropertyDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportPropertyOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportPropertyDefaultValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/OperationReport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Transport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Inventory/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Operation/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/OperationReport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Order/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Financial/CustomerInvoice/Index', 'VMG_Invoicing'
exec INSERT_PAGE @ApplicationName,'UnitGroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'UnitGroupOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'UnitDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'UnitOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductUnitTempDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseStructure.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SectionTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SectionTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationPropertyDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationPropertyOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationPropertyDefaultValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationPropertyPredefinedValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductStructure.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductCommercialNameDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductGroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductPropertyDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductSubgroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductPropertyOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductDamagePropertyDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductSidTempDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductUnitTempDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidValueOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidGroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidGroupOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductPropertyOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SubgroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SubgroupPPDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SubgroupOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductSubgroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'BarcodeTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'BarcodeTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'OperationsDefault.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'OperationTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Operation/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/OperationReport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Operation/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ShiftDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ShiftOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ReferenceTypeValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ReferenceTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ReferenceTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Barcode/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Discharging/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Inbound/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/InboundNew/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Operation/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Outbound/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Barcode/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Discharging/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Inbound/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/InboundNew/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Operation/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Outbound/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductPPDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SectionDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ComplexDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductPPDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ReferenceDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'CompanyOverview.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyRoleDetail.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyTypeDetail.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyApplicationRoleDetail.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyPaymentConditionDetail.aspx', 'VMG_Invoicing'
exec INSERT_PAGE @ApplicationName,'CompanyPaymentConditionOverview.aspx', 'VMG_Invoicing'
exec INSERT_PAGE @ApplicationName,'CompanyDetail.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyRoleOverview.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyTypeOverview.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyRelationDetail.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyRoleLinkDetail.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyRelationOverview.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CustomerPersonDetail.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'CustomerPersonOverview.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'PersonOverview.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'ExternalCompanyPersonDetail.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'InternalCompanyPersonDetail.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'PersonDetail.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'WebPageDetail.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'WebPageOverview.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'ApplicationRoleDetail.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'ApplicationRoleOverview.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'DWReportUserSettingsDetail.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'PrinterDetail.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'PrinterOverview.aspx', 'VMG_ADMIN'
exec INSERT_PAGE @ApplicationName,'FinancialParameterOverview.aspx', 'VMG_Invoicing'
exec INSERT_PAGE @ApplicationName,'ClosePeriod.aspx', 'VMG_Invoicing'
exec INSERT_PAGE @ApplicationName,'ExchangeRateOverview.aspx', 'VMG_Invoicing'
exec INSERT_PAGE @ApplicationName,'JournalOverview.aspx', 'VMG_Invoicing'
exec INSERT_PAGE @ApplicationName,'JournalDetail.aspx', 'VMG_Invoicing'
exec INSERT_PAGE @ApplicationName,'PropertyDetail.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'PropertyOverview.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'ContactOverview.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'ContactDetail.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyRelationDetail.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'CompanyRelationOverview.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'GroupOverview.aspx', 'VMG_CRM'
exec INSERT_PAGE @ApplicationName,'GroupDetail.aspx', 'VMG_CRM'
go

create procedure INSERT_PERSON
	@Login nvarchar(30),
	@Password nvarchar(50),
	@FirstName nvarchar(50),
	@LastName nvarchar(50)
as
begin
set nocount on
print N'Inserting Person : ' + @Login
INSERT INTO [dbo].[PERSON] (
  [LOGIN]
  ,[PASSWORD]
  ,[FIRST_NAME]
  ,[LAST_NAME]
  ,[LID]
  ,[ACTIVE]
  ,[CREATE_USER]
  ,[CREATE_TIMESTAMP]
  ,[UPDATE_USER]
  ,[UPDATE_TIMESTAMP]
  ,[LAST_LOGIN]
  ,[EFFECTIVE_ROLES_CALC_DATE]
)
VALUES (
  @Login
  ,@Password
  ,@FirstName
  ,@LastName
  ,'EN'
  ,1
  ,'System'
  ,getdate()
  ,'System'
  ,getdate()
  ,NULL
  ,NULL);
INSERT INTO [dbo].[INT_COMP_PERSON]
    ([INT_COMPANYNR]
    ,[USER_ID]
    ,[DEFAULT_INT_COMP]
    ,[CREATE_USER]
    ,[CREATE_TIMESTAMP]
    ,[UPDATE_USER]
    ,[UPDATE_TIMESTAMP])
   select
	c.COMPANYNR,
	PERSON_ID,
	COMPANYNR,
	'System',
	getdate(),
	'System',
	getdate()
  from dbo.NSCOMPANY c, dbo.PERSON p
  where p.[LOGIN] = @Login
set nocount off
end
go

exec INSERT_PERSON 'GVEsbroeck', 'GVEsbroeck1010','Gerda','Van Esbroeck'
exec INSERT_PERSON 'VLeysens', 'VLeysens1010','Veronik','Leysens'
exec INSERT_PERSON 'GVerbraeken', 'GVerbraeken1010','Gertjan','Verbraeken'
exec INSERT_PERSON 'KDirckx', 'KDirckx1010','Kevin','Dirckx'
exec INSERT_PERSON 'TFranssens', 'TFranssens1010','Tanja','Franssens'
exec INSERT_PERSON 'Jemanuel', 'Jemanuel1010','Joris','Emanuel'
drop procedure INSERT_PERSON
go

create procedure INSERT_PERSON_ROLE
	@Login nvarchar(30),
	@Role nvarchar(100)
as
begin
set nocount on
  INSERT INTO [dbo].[PERSON_APPLICATION_ROLE](
	[PERSON_ID]
	,[APPLICATION_ROLE_ID]
  )
  select p.PERSON_ID, ar.APPLICATION_ROLE_ID
  from dbo.PERSON p, dbo.APPLICATION_ROLE ar
  where p.[LOGIN]=@Login and ar.[NAME] = @Role

print N'Login: ' + @Login + N' Role: ' + @Role
set nocount off

end
go

exec INSERT_PERSON_ROLE 'GVEsbroeck','VMG_Operations'
exec INSERT_PERSON_ROLE 'VLeysens','VMG_Operations'
exec INSERT_PERSON_ROLE 'GVerbraeken','VMG_Operations'
exec INSERT_PERSON_ROLE 'KDirckx','VMG_Operations'
exec INSERT_PERSON_ROLE 'TFranssens','VMG_Operations'
exec INSERT_PERSON_ROLE 'Jemanuel','VMG_Operations'
exec INSERT_PERSON_ROLE 'GVEsbroeck','VMG_CRM'
exec INSERT_PERSON_ROLE 'VLeysens','VMG_CRM'
exec INSERT_PERSON_ROLE 'GVerbraeken','VMG_CRM'
exec INSERT_PERSON_ROLE 'KDirckx','VMG_CRM'
exec INSERT_PERSON_ROLE 'TFranssens','VMG_CRM'
exec INSERT_PERSON_ROLE 'Jemanuel','VMG_CRM'
exec INSERT_PERSON_ROLE 'Jemanuel','HH_Scanning'
exec INSERT_PERSON_ROLE 'Jemanuel','VMG_ADMIN'
exec INSERT_PERSON_ROLE 'Jemanuel','VMG_Invoicing'
drop procedure INSERT_PERSON_ROLE
go


--delete from INT_COMP_PERSON where USER_ID > 5
--delete from [PERSON] where PERSON_ID > 5
--delete from [APPLICATION_WEB_PAGE] where [APPLICATION_WEB_PAGE_ID] > 476
--delete from APPLICATION_ROLE_WEB_PAGE where [APPLICATION_ROLE_ID] > 6
--delete from APPLICATION_ROLE where APPLICATION_ROLE_ID > 6
--delete from PERSON_APPLICATION_ROLE where APPLICATION_ROLE_ID > 6