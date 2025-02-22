---@module Game.Timings.Timing
local Timing = require("Game/Timings/Timing")

---@class EmitterTiming: Timing
---@field texture string Texture ID.
---@field part string Parent part name.
---@field linked string[] Linked animation IDs to filter with.
local EmitterTiming = setmetatable({}, { __index = Timing })
EmitterTiming.__index = EmitterTiming

---Timing ID.
---@return string
function EmitterTiming:id()
	return self.texture
end

---Load from partial values.
---@param values table
function EmitterTiming:load(values)
	Timing.load(self, values)

	if typeof(values.texture) == "string" then
		self.texture = values.texture
	end

	if typeof(values.linked) == "table" then
		self.linked = values.linked
	end

	if typeof(values.part) == "string" then
		self.part = values.part
	end
end

---Clone timing.
---@return PartTiming
function EmitterTiming:clone()
	local clone = setmetatable(Timing.clone(self), EmitterTiming)

	clone.linked = self.linked
	clone.texture = self.texture
	clone.part = self.part

	return clone
end

---Return a serializable table.
---@return PartTiming
function EmitterTiming:serialize()
	local serializable = Timing.serialize(self)

	serializable.linked = self.linked
	serializable.texture = self.texture
	serializable.part = self.part

	return serializable
end

---Create a new emitter timing.
---@param values table?
---@return EmitterTiming
function EmitterTiming.new(values)
	local self = setmetatable(Timing.new(), EmitterTiming)

	self.linked = {}
	self.texture = ""
	self.part = ""

	if values then
		self:load(values)
	end

	return self
end

-- Return EmitterTiming module.
return EmitterTiming
