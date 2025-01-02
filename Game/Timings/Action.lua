---@class Action
---@field _type string
---@field when number The point at which the action occurs. This may be a point in time or a point in a track. Up to the caller to determine what that's used for.
---@field hitbox Vector3 The hitbox of the action.
local Action = {}
Action.__index = Action

---Load from partial values.
---@param values table
function Action:load(values)
	if typeof(values._type) == "string" then
		self._type = values._type
	end

	if typeof(values.when) == "number" then
		self.when = values.when
	end

	if typeof(values.name) == "string" then
		self.name = values.name
	end

	if typeof(values.hitbox) == "table" then
		self.hitbox = Vector3.new(values.hitbox.X, values.hitbox.Y, values.hitbox.Z)
	end
end

---Clone action.
---@return Action
function Action:clone()
	local clone = Action.new()

	clone._type = self._type
	clone.when = self.when
	clone.name = self.name
	clone.hitbox = self.hitbox

	return clone
end

---Return a serializable table.
---@return table
function Action:serialize()
	return {
		_type = self._type,
		when = self.when,
		name = self.name,
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
	self.when = 0
	self.name = ""
	self.hitbox = Vector3.zero

	if values then
		self:load(values)
	end

	return self
end

-- Return Action module.
return Action
