create procedure CreateTransportProperty
	@Code nvarchar(10),
	@Description nvarchar(50),
	@ValueType nvarchar(2000)
as
begin

set nocount on

INSERT INTO [dbo].[NS_TRANSPORT_PROPERTY]
	([CODE]
	,[DESCRIPTION]
	,[STATUS]
	,[CREATE_USER]
	,[CREATE_TIMESTAMP]
	,[UPDATE_USER]
	,[UPDATE_TIMESTAMP]
	,[EDI_CODE]
	,[SORTING]
	,[VALUE_TYPE]
	,[GLOBAL]
	,[MASK])
VALUES
	(@Code
	,@Description
	,1
	,'system'
	,getdate()
	,'system'
	,getdate()
	,null -- EDI_CODE
	,0 -- SORTING
	,@ValueType
	,0 -- GLOBAL
	,null -- MASK
	)
					 
set nocount off

end
go

create procedure CreateTransportType
	@Code nvarchar(10),
	@Description nvarchar(50)
as
	declare @InternalCompanyId int
begin

set nocount on

select top 1 @InternalCompanyId = COMPANYNR from NSCOMPANY order by COMPANYNR

INSERT INTO [dbo].[NS_TRANSPORT_TYPE]
	([CODE]
	,[DESCRIPTION]
	,[STATUS]
	,[CREATE_USER]
	,[CREATE_TIMESTAMP]
	,[UPDATE_USER]
	,[UPDATE_TIMESTAMP]
	,[ENTITY_TYPE]
	,[INTERNAL_COMPANY_NR]
	,[CONTAINER_FOLLOW_UP]
	,[VESSEL_LOCATION_REPORTING]
	,[NR_OF_COORDINATES]
	,[PERMIS_FOLLOW_UP]
	,[ANNOUNCED_DATE_MANDATORY])
VALUES
	(@Code
	,@Description
	,1
	,'system'
	,getdate()
	,'system'
	,getdate()
	,1
	,@InternalCompanyId
	,1
	,1
	,null
	,1
	,1)

set nocount off

end
go

create procedure CreateTransportTypeProperty
	@TransportTypeCode nvarchar(10),
	@TransportPropertyCode nvarchar(10),
	@Sequence int
as
	declare @TransportTypeId int
	declare @TransportPropertyId int
begin

set nocount on

select @TransportTypeId = TRANSPORT_TYPE_ID from NS_TRANSPORT_TYPE where CODE = @TransportTypeCode
select @TransportPropertyId = TRANSPORT_PROPERTY_ID from NS_TRANSPORT_PROPERTY where CODE = @TransportPropertyCode

INSERT INTO [dbo].[NS_TRANSPORT_TYPE_TP]
	([TRANSPORT_TYPE_ID]
	,[TRANSPORT_PROPERTY_ID]
	,[MANDATORY]
	,[DEFAULT_VALUE]
	,[CREATE_USER]
	,[CREATE_TIMESTAMP]
	,[UPDATE_USER]
	,[UPDATE_TIMESTAMP]
	,[SEQUENCE]
	,[SYSTEM_TYPE]
	,[REF_TRANSPORT_TYPE_TP_ID]
	,[UPDATE_STATUS])
VALUES
	(@TransportTypeId
	,@TransportPropertyId
	,0 -- MANDATORY
	,null -- DEFAULT_VALUE, nvarchar(255)
	,'system'
	,getdate()
	,'system'
	,getdate()
	,@Sequence
	,1 -- SYSTEM_TYPE
	,null -- REF_TRANSPORT_TYPE_TP_ID
	,0 -- UPDATE_STATUS
	)

set nocount off
end
go

exec CreateTransportProperty 'TC', 'Transport Company', 'iBoris.iTos.CRM.Company, iBoris.iTos'
exec CreateTransportProperty 'LP', 'LP', 'System.String, mscorlib'
exec CreateTransportProperty 'SHPT', 'Shipment', 'System.String, mscorlib'
exec CreateTransportType 'TR', 'Truck'
exec CreateTransportType 'TRL', 'Trailer'
exec CreateTransportTypeProperty 'TR', 'LP', 5
exec CreateTransportTypeProperty 'TR', 'TC', 10
exec CreateTransportTypeProperty 'TR', 'SHPT', 15
exec CreateTransportTypeProperty 'TRL', 'LP', 5
exec CreateTransportTypeProperty 'TRL', 'TC', 10
exec CreateTransportTypeProperty 'TRL', 'SHPT', 15
GO

drop procedure CreateTransportType
drop procedure CreateTransportProperty
drop procedure CreateTransportTypeProperty
go