-- CombatTab module.
local CombatTab = {}

-- Initialize combat targeting section.
---@param groupbox table
function CombatTab.initCombatTargetingSection(groupbox) end

-- Initialize auto defense section.
---@param groupbox table
function CombatTab.initAutoDefenseSection(groupbox) end

-- Initialize feint detection section.
---@param groupbox table
function CombatTab.initFeintDetectionSection(groupbox) end

-- Initialize attack assistance section.
---@param groupbox table
function CombatTab.initAttackAssistanceSection(groupbox) end

-- Initialize input assistance section.
---@param groupbox table
function CombatTab.initInputAssistance(groupbox) end

-- Initialize combat assistance section.
---@param groupbox table
function CombatTab.initCombatAssistance(groupbox) end

---Initialize tab.
---@param window table
function CombatTab.init(window)
	-- Create tab.
	local tab = window:AddTab("Combat")

	-- Initialize sections.
	CombatTab.initCombatTargetingSection(tab:AddDynamicGroupbox("Combat Targeting"))
	CombatTab.initAutoDefenseSection(tab:AddDynamicGroupbox("Auto Defense"))
	CombatTab.initFeintDetectionSection(tab:AddDynamicGroupbox("Feint Detection"))
	CombatTab.initAttackAssistanceSection(tab:AddDynamicGroupbox("Attack Assistance"))
	CombatTab.initInputAssistance(tab:AddDynamicGroupbox("Input Assistance"))
	CombatTab.initCombatAssistance(tab:AddDynamicGroupbox("Combat Assistance"))
end

-- Return CombatTab module.
return CombatTab
