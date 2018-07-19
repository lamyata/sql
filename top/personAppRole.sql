select [LOGIN], FIRST_NAME, LAST_NAME,
	IsNull(STUFF((SELECT ', ' + [NICK_NAME] FROM COMPANY c JOIN PERSON_INTERNAL_COMPANY pic on c.COMPANY_ID = pic.INTERNAL_COMPANY_ID WHERE pic.[USER_ID] = p.PERSON_ID ORDER BY [NICK_NAME] FOR XML PATH ('')), 1, 2, ''), '') as ICs,
	IsNull(STUFF((SELECT ', ' + [NAME] FROM APPLICATION_ROLE ar JOIN PERSON_APPLICATION_ROLE par on ar.APPLICATION_ROLE_ID = par.APPLICATION_ROLE_ID WHERE par.PERSON_ID = p.PERSON_ID ORDER BY [NAME] FOR XML PATH ('')), 1, 2, ''), '') as AppRoles
	from PERSON p
	order by p.PERSON_ID

select [LOGIN], p.PERSON_ID, FIRST_NAME, LAST_NAME,
	c.COMPANY_ID, c.CODE, c.NICK_NAME,
	ar.APPLICATION_ROLE_ID, ar.NAME
  from
	PERSON p join PERSON_INTERNAL_COMPANY pic on p.PERSON_ID = pic.USER_ID join COMPANY c on pic.INTERNAL_COMPANY_ID = c.COMPANY_ID
	join PERSON_APPLICATION_ROLE par on p.PERSON_ID = par.PERSON_ID join APPLICATION_ROLE ar on par.APPLICATION_ROLE_ID = ar.APPLICATION_ROLE_ID
order by PERSON_ID
	
	

--select * from PRODUCT_STORAGE_IDENTIFIER psi join PRODUCT_GROUP_PRODUCT pgp on psi.PRODUCT_ID = pgp.PRODUCT_ID
--	and pgp.PRODUCT_GROUP_ID = @FujiProductGroupId
--	join STORAGE_IDENTIFIER si on psi.SID_ID = si.STORAGE_IDENTIFIER_ID