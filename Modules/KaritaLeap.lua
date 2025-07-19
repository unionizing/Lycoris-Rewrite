---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 300 + (distance * 4)
	action._type = "Parry"
	action.hitbox = Vector3.new(10, 10, 40)
	action.name = "Dynamic Karita Leap Timing"
	return self:action(timing, action)
end
