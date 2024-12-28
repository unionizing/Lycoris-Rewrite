---@module Features.Visuals.Objects.PositionESP
local PositionESP = require("Features/Visuals/Objects/PositionESP")

---@note: Optimization - we assume the model coming in is an actual model.
---@class ModelESP: PositionESP
---@field model Model
local ModelESP = setmetatable({}, { __index = PositionESP })
ModelESP.__index = ModelESP

---Update ModelESP.
---@param tags string[]
function ModelESP:update(tags)
	local model = self.model

	if not model.Parent then
		return self:hide()
	end

	PositionESP.update(self, model:GetPivot().Position, tags or {})
end

---Create new ModelESP object.
---@param identifier string
---@param model Model
---@param label string
function ModelESP.new(identifier, model, label)
	if not model:IsA("Model") then
		return error(string.format("ModelESP expected model on %s creation.", identifier))
	end

	model.ModelStreamingMode = Enum.ModelStreamingMode.Persistent

	local self = setmetatable(PositionESP.new(identifier, label), ModelESP)
	self.model = model
	return self
end

-- Return ModelESP module.
return ModelESP
