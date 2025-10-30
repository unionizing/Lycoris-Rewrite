---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)

	local action = Action.new()
	action._when = math.min(1020 + distance * 10)
	action._type = "Forced Full Dodge"
	action.hitbox = Vector3.new(30, 60, 50)
	action.name = string.format("(%.2f) Dynamic Ascension Timing", distance)

	return self:action(timing, action)
end
