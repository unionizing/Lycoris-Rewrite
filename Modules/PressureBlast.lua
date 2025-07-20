---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 600
	if distance >= 20 then
		action._when = 750
	end
	if distance >= 25 then
		action._when = 850
	end
	if distance >= 30 then
		action._when = 900
	end
	if distance >= 35 then
		action._when = 1000
	end
	action._type = "Start Block"
	action.hitbox = Vector3.new(25, 20, 40)
	action.name = string.format("(%.2f) Dynamic Pressure Blast Timing", distance)
	self:action(timing, action)

	local action = Action.new()
	action._when = 1150
	action._type = "End Block"
	action.ihbc = true
	action.name = string.format("(%.2f) Dynamic Pressure Blast Timing", distance)
	return self:action(timing, action)
end
