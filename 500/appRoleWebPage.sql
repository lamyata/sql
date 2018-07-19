select ar.APPLICATION_ROLE_ID, ar.NAME, awp.APPLICATION_WEB_PAGE_ID, awp.WEB_PAGE
from APPLICATION_ROLE ar join APPLICATION_ROLE_WEB_PAGE arwp on ar.APPLICATION_ROLE_ID = arwp.APPLICATION_ROLE_ID
	join APPLICATION_WEB_PAGE awp on arwp.APPLICATION_WEB_PAGE_ID = awp.APPLICATION_WEB_PAGE_ID
	order by 2, 4