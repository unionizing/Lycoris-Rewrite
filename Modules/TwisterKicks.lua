---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)

	local action = Action.new()
	action._when = math.min(350 + distance * 6.5)
	action._type = "Parry"
	action.hitbox = Vector3.new(30, 25, 25)
	action.name = string.format("(%.2f) Dynamic Twister Kicks Timing", distance)

	return self:action(timing, action)
end
