---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 600
	if distance >= 16 then
		action._when = 700
	end

	action._type = "Parry"
	action.hitbox = Vector3.new(32, 32, 32)
	action.name = string.format("(%.2f) Dynamic Ice Dagers Timing", distance)
	return self:action(timing, action)
end
