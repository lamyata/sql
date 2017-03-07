create procedure INSERT_PERSON
	@Login nvarchar(30),
	@Role nvarchar(50)
as
begin
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
	,@Login
	,@Login
	,@Login
	,'EN'
	,1
	,'System'
	,getdate()
	,'System'
	,getdate()
	,NULL
	,NULL);

INSERT INTO [dbo].[PERSON_APPLICATION_ROLE](
	[PERSON_ID]
	,[APPLICATION_ROLE_ID]
)
select p.PERSON_ID, ar.APPLICATION_ROLE_ID
from dbo.PERSON p, dbo.APPLICATION_ROLE ar
where p.[LOGIN]=@Login and ar.[NAME] = @Role

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
end
go

exec INSERT_PERSON 'vmg1', 'VMG_Operations'
exec INSERT_PERSON 'vmghh1', 'HH_Scanning'