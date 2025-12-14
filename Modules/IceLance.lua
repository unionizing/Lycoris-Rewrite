---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = math.min(300 + distance * 13)
	action._type = "Start Block"
	action.hitbox = Vector3.new(19, 15, 26)
	action.name = string.format("(%.2f) Dynamic Ice Lance Timing", distance)

	local actionTwo = Action.new()
	actionTwo._when = math.min(700 + distance * 13)
	actionTwo.ihbc = true
	actionTwo._type = "End Block"
	self:action(timing, action)
end
