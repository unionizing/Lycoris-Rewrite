---@module Game.Timings.Timing
local Timing = require("Game/Timings/Timing")

---@class AnimationTiming: Timing
---@field id string Animation ID.
---@field ha boolean Flag to see whether or not this timing can be cancelled by a hit.
---@field iae boolean Flag to see whether or not this timing should ignore animation end.
---@field phd boolean Past hitbox detection.
---@field pfh boolean Predict hitboxes facing.
---@field phds number History seconds for past hitbox detection.
---@field pfht number Extrapolation time for hitbox prediction.
---@field ieae boolean Flag to see whether or not this timing should ignore early animation end.
---@field mat number Max animation timeout in milliseconds.
---@field dp boolean Disable prediction.
---@field imb boolean Ignore megalodaunt block. Hidden option.
---@field ffh boolean Flag to see whether or not this timing should force facing hitbox to the user, no matter what. Hidden option.
local AnimationTiming = setmetatable({}, { __index = Timing })
AnimationTiming.__index = AnimationTiming

---Timing ID.
---@return string
function AnimationTiming:id()
	return self._id
end

---Equals check.
---@param other AnimationTiming
function AnimationTiming:equals(other)
	if not Timing.equals(self, other) then
		return false
	end

	if self.ha ~= other.ha then
		return false
	end

	if self.iae ~= other.iae then
		return false
	end

	if self.ieae ~= other.ieae then
		return false
	end

	if self.mat ~= other.mat then
		return false
	end

	if self.phd ~= other.phd then
		return false
	end

	if self.pfh ~= other.pfh then
		return false
	end

	if self.phds ~= other.phds then
		return false
	end

	if self.pfht ~= other.pfht then
		return false
	end

	if self.dp ~= other.dp then
		return false
	end

	if self.imb ~= other.imb then
		return false
	end

	return true
end

---Load from partial values.
---@param values table
function AnimationTiming:load(values)
	Timing.load(self, values)

	if typeof(values._id) == "string" then
		self._id = values._id
	end

	if typeof(values.ha) == "boolean" then
		self.ha = values.ha
	end

	if typeof(values.iae) == "boolean" then
		self.iae = values.iae
	end

	if typeof(values.ieae) == "boolean" then
		self.ieae = values.ieae
	end

	if typeof(values.mat) == "number" then
		self.mat = values.mat
	end

	if typeof(values.phd) == "boolean" then
		self.phd = values.phd
	end

	if typeof(values.pfh) == "boolean" then
		self.pfh = values.pfh
	end

	if typeof(values.phds) == "number" then
		self.phds = values.phds
	end

	if typeof(values.pfht) == "number" then
		self.pfht = values.pfht
	end

	if typeof(values.dp) == "boolean" then
		self.dp = values.dp
	end

	if typeof(values.imb) == "boolean" then
		self.imb = values.imb
	end
end

---Clone timing.
---@return AnimationTiming
function AnimationTiming:clone()
	local clone = setmetatable(Timing.clone(self), AnimationTiming)

	clone._id = self._id
	clone.ha = self.ha
	clone.iae = self.iae
	clone.ieae = self.ieae
	clone.mat = self.mat
	clone.phd = self.phd
	clone.pfh = self.pfh
	clone.phds = self.phds
	clone.pfht = self.pfht
	clone.dp = self.dp
	clone.imb = self.imb

	return clone
end

---Return a serializable table.
---@return AnimationTiming
function AnimationTiming:serialize()
	local serializable = Timing.serialize(self)

	serializable._id = self._id
	serializable.ha = self.ha
	serializable.iae = self.iae
	serializable.ieae = self.ieae
	serializable.mat = self.mat
	serializable.phd = self.phd
	serializable.pfh = self.pfh
	serializable.phds = self.phds
	serializable.pfht = self.pfht
	serializable.dp = self.dp
	serializable.imb = self.imb

	return serializable
end

---Create a new animation timing.
---@param values table?
---@return AnimationTiming
function AnimationTiming.new(values)
	local self = setmetatable(Timing.new(), AnimationTiming)

	self.dp = false
	self._id = ""
	self.ha = false
	self.iae = false
	self.ieae = false
	self.mat = 2000
	self.phd = false
	self.pfh = false
	self.phds = 0
	self.pfht = 0.15
	self.imb = false

	if values then
		self:load(values)
	end

	return self
end

-- Return AnimationTiming module.
return AnimationTiming
