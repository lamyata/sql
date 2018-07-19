declare @sidQuaId int = (SELECT STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = 'QUA')
declare @curUser varchar(20) = 'man180126'
declare @sValues table (val varchar(50))
insert into @sValues values ('DUPLEX GREY BACK')

select * from STORAGE_IDENTIFIER_PR_VALUE sipv join @sValues sv on SID_ID = @sidQuaId and sipv.PREDEFINED_VALUE = sv.val

--insert into STORAGE_IDENTIFIER_PR_VALUE
--select @sidQuaId, val, @curUser, getdate(), @curUser, getdate()
--from @sValues sv
--where not exists (select * from STORAGE_IDENTIFIER_PR_VALUE where SID_ID = @sidQuaId and PREDEFINED_VALUE = sv.val)