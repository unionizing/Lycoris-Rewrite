---@module Features.Visuals.Objects.ModelESP
local ModelESP = require("Features/Visuals/Objects/ModelESP")

---@module Features.Visuals.Objects.PartESP
local PartESP = require("Features/Visuals/Objects/PartESP")

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

---@class ChestESP: ModelESP
local ChestESP = setmetatable({}, { __index = ModelESP })
ChestESP.__index = ChestESP
ChestESP.__type = "ChestESP"

---Update ChestESP.
---@param self ChestESP
ChestESP.update = LPH_NO_VIRTUALIZE(function(self)
	local inst = self.part or self.model

	if Configuration.idToggleValue(self.identifier, "HideIfOpened") and not inst:HasTag("ClosedChest") then
		return self:visible(false)
	end

	if self.part then
		PartESP.update(self, {})
	else
		ModelESP.update(self, {})
	end
end)

---Create new ChestESP object.
---@param identifier string
---@param inst Instance
---@param label string
function ChestESP.new(identifier, inst, label)
	return setmetatable(
		inst:IsA("Model") and ModelESP.new(identifier, inst, label) or PartESP.new(identifier, inst, label),
		ChestESP
	)
end

-- Return ChestESP module.
return ChestESP
