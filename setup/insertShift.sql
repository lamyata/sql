INSERT INTO [dbo].[NS_SHIFT]
           ([CODE]
           ,[STATUS]
           ,[START_TIME]
           ,[END_TIME]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP]
           ,[BREAK_START]
           ,[BREAK_END]
           ,[SEQUENCE])
     VALUES
        (  '24' -- CODE
           ,1 -- STATUS
           ,'0001/1/1' -- START_TIME
           ,'0001/1/1 23:59:59.99' -- END_IME
           ,'system' -- CREATE_USER
           ,getdate() -- CREATE_TIMESTAMP
           ,'system' -- UPDATE_USER
           ,getdate() -- UPDATE_TIMESTAMP
           ,null -- BREAK_START
           ,null -- BREAK_END
           ,1 -- SEQUENCE
	)
declare @shiftId int
select @shiftId = SCOPE_IDENTITY()
declare @InternalCompanyId int
select top 1 @InternalCompanyId = COMPANYNR from NSCOMPANY order by COMPANYNR
insert into NS_SHIFT_INTERNAL_COMPANY values(@shiftId, @InternalCompanyId)
go