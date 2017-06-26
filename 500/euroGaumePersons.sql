declare @AddressId int;

INSERT INTO [dbo].[ADDRESS]
           ([ADDRESS_LINE]
           ,[COUNTRY_ID]
           ,[ZIP]
           ,[CITY]
           ,[FULL_ADDRESS]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
     SELECT
           'Rue Neuve 1' -- ADDRESS_LINE, nvarchar(200),
           ,COUNTRY_ID
           ,'6810' --  <ZIP, nvarchar(200),>
           ,'JAMOIGNE' -- <CITY, nvarchar(200),>
           ,'Rue Neuve 1    BELGIUM'
           ,'sys'
           ,getdate()
           ,'sys'
           ,getdate()
		FROM COUNTRY where CODE = 'BE'

select @AddressId = SCOPE_IDENTITY();

update INTERNAL_COMPANY set NAME = 'Eurogaume SA' where COMPANY_ID = 1
update COMPANY
set
	NAME = 'Eurogaume SA',
	MAIN_ADDRESS_ID = @AddressId
where COMPANY_ID = 1

go

create procedure INSERT_PERSON
	@Login nvarchar(30),
	@Password nvarchar(50),
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@EMail nvarchar(75) = null
as
begin
set nocount on
print N'Inserting Person : ' + @Login
INSERT INTO [dbo].[PERSON] (
  [LOGIN]
  ,[PASSWORD]
  ,[FIRST_NAME]
  ,[LAST_NAME]
  ,[LANGUAGE_ID]
  ,[ACTIVE]
  ,[CREATE_USER]
  ,[CREATE_TIMESTAMP]
  ,[UPDATE_USER]
  ,[UPDATE_TIMESTAMP]
)
SELECT
  @Login
  ,@Password
  ,@FirstName
  ,@LastName
  ,[LANGUAGE_ID]
  ,1
  ,'System'
  ,getdate()
  ,'System'
  ,getdate()
FROM [_LANGUAGE_]
WHERE CODE = 'EN';
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
  from dbo.INTERNAL_COMPANY ic, dbo.PERSON p
  where p.[LOGIN] = @Login
set nocount off
end
go

exec INSERT_PERSON 'PSMOUT', 'Jemanuel1010','Pieter', 'Smout', 'psmout@ionlogistics.eu'
exec INSERT_PERSON 'IDRESSELAERS', 'ID1010', 'Ivan', 'Dresselaers';
exec INSERT_PERSON 'GVDVEKEN', 'GVDVeken1010','Guy','Van Der Veken', 'gvanderveken@ionlogistics.eu'
exec INSERT_PERSON 'KVLEEMPUT', 'KVL1010','Koen','Van Leemput', 'kvanleemput@ionlogistics.eu'
exec INSERT_PERSON 'DIRK', 'D1010','Dirk','Dirk'
exec INSERT_PERSON 'SMAZUIS', 'SM1010','Stéphanie','Mazuis', 'stephanie.mazuis@eurogaume.com'
exec INSERT_PERSON 'JMAZUIS', 'D1010','Jean-Philippe','Mazuis'

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

exec INSERT_PERSON_ROLE 'PSMOUT', 'Admin';
exec INSERT_PERSON_ROLE 'IDRESSELAERS', 'Admin';
exec INSERT_PERSON_ROLE 'GVDVEKEN', 'Admin';
exec INSERT_PERSON_ROLE 'KVLEEMPUT', 'Admin';
exec INSERT_PERSON_ROLE 'DIRK', 'Admin';
exec INSERT_PERSON_ROLE 'SMAZUIS', 'Admin';
exec INSERT_PERSON_ROLE 'JMAZUIS', 'Admin';

drop procedure INSERT_PERSON_ROLE
go
