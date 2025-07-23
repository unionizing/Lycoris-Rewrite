---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 5350
	action._type = "Parry"
	action.hitbox = Vector3.new(900, 900, 900)
	action.name = string.format("(%.2f) World Serpent Roar Timing", distance)
	return self:action(timing, action)
end
