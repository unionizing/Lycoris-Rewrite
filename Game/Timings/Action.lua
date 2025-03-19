---@class Action
---@field _type string
---@field _when number When the action will occur in miliseconds. Never access directly.
---@field tp number Time position if applicable.
---@field utp boolean Use time position instead of delay.
---@field hitbox Vector3 The hitbox of the action.
local Action = {}
Action.__index = Action

---Getter for when in seconds.
---@return number
function Action:when()
	return self._when / 1000
end

---Load from partial values.
---@param values table
function Action:load(values)
	if typeof(values._type) == "string" then
		self._type = values._type
	end

	if typeof(values.when) == "number" then
		self._when = values.when
	end

	if typeof(values.name) == "string" then
		self.name = values.name
	end

	if typeof(values.hitbox) == "table" then
		self.hitbox = Vector3.new(values.hitbox.X, values.hitbox.Y, values.hitbox.Z)
	end

	if typeof(values.tp) == "number" then
		self.tp = values.tp
	end

	if typeof(values.utp) == "boolean" then
		self.utp = values.utp
	end
end

---Clone action.
---@return Action
function Action:clone()
	local clone = Action.new()

	clone._type = self._type
	clone._when = self._when
	clone.name = self.name
	clone.hitbox = self.hitbox
	clone.tp = self.tp
	clone.utp = self.utp

	return clone
end

---Return a serializable table.
---@return table
function Action:serialize()
	return {
		_type = self._type,
		when = self._when,
		name = self.name,
		tp = self.tp,
		utp = self.utp,
		hitbox = {
			X = self.hitbox.X,
			Y = self.hitbox.Y,
			Z = self.hitbox.Z,
		},
	}
end

---Create new Action object.
---@param values table?
---@return Action
function Action.new(values)
	local self = setmetatable({}, Action)

	self._type = "N/A"
	self._when = 0
	self.name = ""
	self.hitbox = Vector3.zero
	self.tp = 0
	self.utp = false

	if values then
		self:load(values)
	end

	return self
end

-- Return Action module.
return Action
