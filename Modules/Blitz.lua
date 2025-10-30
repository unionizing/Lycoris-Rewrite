---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)

	local action = Action.new()
	action._when = math.min(0 + distance * 7.5)
	action._type = "Parry"
	action.name = string.format("(%.2f) Dynamic Tempest Blitz Timing", distance)

	return self:action(timing, action)
end
