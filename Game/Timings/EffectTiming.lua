---@module Game.Timings.Timing
local Timing = require("Game/Timings/Timing")

---@class EffectTiming: Timing
---@field ename string Effect name.
---@field ilp boolean Ignore local player.
---@field flp boolean Force local player.
local EffectTiming = setmetatable({}, { __index = Timing })
EffectTiming.__index = EffectTiming

---Timing ID.
---@return string
function EffectTiming:id()
	return self.ename
end

---Equals check.
---@param other EffectTiming
---@return boolean
function EffectTiming:equals(other)
	if not Timing.equals(self, other) then
		return false
	end

	if self.ename ~= other.ename then
		return false
	end

	if self.ilp ~= other.ilp then
		return false
	end

	if self.flp ~= other.flp then
		return false
	end

	return true
end

---Load from partial values.
---@param values table
function EffectTiming:load(values)
	Timing.load(self, values)

	if typeof(values.ename) == "string" then
		self.ename = values.ename
	end

	if typeof(values.ilp) == "boolean" then
		self.ilp = values.ilp
	end

	if typeof(values.flp) == "boolean" then
		self.flp = values.flp
	end
end

---Clone timing.
---@return EffectTiming
function EffectTiming:clone()
	local clone = setmetatable(Timing.clone(self), EffectTiming)

	clone.ename = self.ename
	clone._rpd = self._rpd
	clone._rsd = self._rsd
	clone.rpue = self.rpue
	clone.ilp = self.ilp
	clone.flp = self.flp

	return clone
end

---Return a serializable table.
---@return EffectTiming
function EffectTiming:serialize()
	local serializable = Timing.serialize(self)

	serializable.ename = self.ename
	serializable.ilp = self.ilp
	serializable.flp = self.flp

	return serializable
end

---Create a new effect timing.
---@param values table?
---@return EffectTiming
function EffectTiming.new(values)
	local self = setmetatable(Timing.new(), EffectTiming)

	self.ename = ""
	self.ilp = false
	self.flp = false

	if values then
		self:load(values)
	end

	return self
end

-- Return EffectTiming module.
return EffectTiming
