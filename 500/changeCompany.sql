declare @oldCompanyId int = 1
declare @newCompanyId int = 1776
update COMPANY_APPLICATION_ROLE set COMPANYNR = @newCompanyId WHERE COMPANYNR = @oldCompanyId
update ORDERS set CUSTOMER_ID = @newCompanyId WHERE CUSTOMER_ID = @oldCompanyId
update STOCK_INFO_CONFIG set OWNER_ID = @newCompanyId WHERE OWNER_ID = @oldCompanyId

--select * from COMPANY_APPLICATION_ROLE where COMPANYNR = 1 --and INTERNAL_COMPANYNR = 1
--select * from ORDERS where CUSTOMER_ID = 1 -- and INTERNAL_COMPANY_ID = 1
--select * from STOCK_INFO_CONFIG where OWNER_ID = 1

--select * from ADDITIONAL_OPERATION_COMPANY where COMPANYNR = 1
--select * from COMPANY_DOCUMENT where COMPANYNR = 1
--select * from COMPANY_PAYMENT_CONDITIONS where COMPANY_NUMBER = 1
--select * from COMPANY_PROPERTY_VALUE where COMPANYNR = 1
--select * from CONTACT_PERSON where COMPANYNR = 1
--select * from CRM_GROUP_COMPANY where COMPANYNR = 1
--select * from FINANCIAL_DOCUMENT where PARTNER_ID = 1
--select * from FINANCIAL_LINE where PARTNER_ID = 1
--select * from PARTNER_ADDRESS where COMPANYNR = 1
--select * from PRODUCT_COMPANY where COMPANYNR = 1
--select * from REFERENCE where COMPANYNR = 1
--select * from TARIFF_CUSTOMER where COMPANY_ID =

--select * from CONFIG_SETTING_VALUE where INTERNAL_COMPANYNR = 1
--select * from CRM_EVENT_INTERNAL_COMPANY where INTERNAL_COMPANYNR = 1
--select * from DW_SWITCH_INT_COMP where COMPANYNR = 1
--select * from FINANCIAL_DOCUMENT where INTERNAL_COMPANY_ID = 1
--select * from JOURNAL where INTERNAL_COMPANY_ID = 1
--select * from LOCATION_INTERNAL_COMPANY where INTERNAL_COMPANY_ID = 1
--select * from NS_COSTCENTRE where  INTERNAL_COMPANY_NR = 1
--select * from NS_SHIFT_INTERNAL_COMPANY where INTERNAL_COMPANYNR = 1
--select * from NS_SHIFT_PROP_INT_COMPANY where INTERNAL_COMPANY_ID = 1
--select * from OBSTRUCTION where INTERNAL_COMPANY_ID = 1
--select * from OPERATION where INTERNAL_COMPANY_ID = 1
--select * from OPERATION_CONTEXT where INTERNAL_COMPANY_ID = 1
--select * from PERSON_INTERNAL_COMPANY where INT_COMPANYNR = 1
--select * from PRINTER_INT_COMP where COMPANYNR = 1
--select * from PRODUCT_INT_COMPANY where INT_COMPANYNR = 1
--select * from RECIPE_TYPE where INTERNAL_COMPANY_ID = 1
--select * from SERVICE_ACCOUNT where INTERNAL_COMPANY_ID = 1