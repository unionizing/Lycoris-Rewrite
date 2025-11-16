---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Action.new()
	action._when = 175
	action._type = "Dodge"
	action.hitbox = Vector3.new(30, 30, 30)
	action.name = "Dynamic Skycrash End Timing"

	if self.entity.Name:match(".titus") then
		action.hitbox *= 2.0
		action.name = "Dynamic Titus Skycrash End Timing"
	end

	return self:action(timing, action)
end
