---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	timing.duih = true
	action._when = math.min(0 + distance * 8)
	action._type = "Parry"
	timing.hitbox = Vector3.new(22, 50, 53)
	action.name = "Dynamic Skycrash Loop Timing"

	if self.entity.Name:match(".titus") then
		timing.hitbox *= 2.0
		action._type = "Dodge"
		action.name = "Dynamic Titus Skycrash Loop Timing"
	end

	return self:action(timing, action)
end
