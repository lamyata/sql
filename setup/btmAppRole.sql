
INSERT INTO [dbo].[APPLICATION_ROLE]
 ([NAME]
 ,[APPLICATION_ID]
 ,[DESCRIPTION]
 ,[CREATE_USER]
 ,[CREATE_TIMESTAMP]
 ,[UPDATE_USER]
 ,[UPDATE_TIMESTAMP])
SELECT
  'BTMUser'
  ,APPLICATION_ID
  ,'BTMUser'
  ,'System'
  ,getdate()
  ,'System'
  ,getdate()
FROM [dbo].[APPLICATION]
where NAME = 'iTos';
	
insert into APPLICATION_ROLE_WEB_PAGE
	select ar.APPLICATION_ROLE_ID, awp.APPLICATION_WEB_PAGE_ID
	from APPLICATION_ROLE ar, [APPLICATION] a, APPLICATION_WEB_PAGE awp where
		ar.APPLICATION_ID = a.APPLICATION_ID and a.[NAME] = 'iTos' and ar.[NAME] = 'BTMUser'and
		awp.WEB_PAGE not like '/Stevedoring/Customs%'	

update par set APPLICATION_ROLE_ID = ar.APPLICATION_ROLE_ID
	from PERSON_APPLICATION_ROLE par, APPLICATION_ROLE ar, PERSON p where ar.[NAME] = 'BTMUser'
	and par.PERSON_ID = p.PERSON_ID and p.[LOGIN] in ('an@btmmoerdijk.eu', 'Leendert@vdreijtfert.nl', 'slemmer@vdreijtfert.nl', 'Kees@vdreijtfert.nl')
