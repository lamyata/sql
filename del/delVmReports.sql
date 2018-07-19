DECLARE @RepIds TABLE ( RepId INT );
DECLARE @RepSwitches TABLE ( SwitchId INT );
DECLARE @RepRules TABLE	( RuleId INT );

INSERT INTO @RepIds SELECT REPORT_ID FROM DW_REPORT where REPORT_KEY like 'VML_%' -- del rpts for VM
INSERT INTO @RepSwitches SELECT [SWITCH_ID] FROM [dbo].[DW_SWITCH] s JOIN @RepIds r on s.REPORT_ID = r.RepId;
INSERT INTO @RepRules SELECT [RULE_ID] FROM [dbo].[DW_RULE] WHERE [SWITCH_ID] IN (SELECT SwitchId FROM @RepSwitches)

-- Delete contanct relations for rules
DELETE FROM [dbo].[DW_RULE_CONTACT]
WHERE [RULE_ID] IN 
(SELECT RuleId FROM @RepRules)

-- Delete printer relations for rules
DELETE FROM [dbo].[DW_RULE_PRINTER]
WHERE [RULE_ID] IN 
(SELECT RuleId FROM @RepRules)

-- Delete rules
DELETE FROM [dbo].[DW_RULE]
WHERE [SWITCH_ID] IN 
(SELECT SwitchId FROM @RepSwitches)

-- Delete internal company relations for switches
DELETE FROM [dbo].[DW_SWITCH_INT_COMP]
WHERE [SWITCH_ID] IN 
(SELECT SwitchId FROM @RepSwitches)

-- Delete printer relations for switches
DELETE FROM [dbo].[DW_SWITCH_PRINTER]
WHERE [SWITCH_ID] IN 
(SELECT SwitchId FROM @RepSwitches)

-- Delete switches
DELETE FROM [dbo].[DW_SWITCH]
WHERE [REPORT_ID] IN
(SELECT RepId from @RepIds)

-- Delete links to report context
DELETE FROM [dbo].[DW_REPORT_REP_CONTEXT]
WHERE [REPORT_ID] IN
(SELECT RepId from @RepIds)

-- Delete layouts
DELETE FROM [dbo].[DW_LAYOUT]
WHERE [REPORT_ID] IN
(SELECT RepId from @RepIds)

-- Delete the report rules
DELETE FROM [dbo].[DW_REPORT_USER_SETTINGS]
WHERE [REPORT_ID] IN
(SELECT RepId from @RepIds)

-- Delete report
DELETE FROM [dbo].[DW_REPORT]
WHERE [REPORT_ID] IN
(SELECT RepId from @RepIds)
