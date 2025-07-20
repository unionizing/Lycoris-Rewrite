---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 410
	if distance >= 12 then
		action._when = 550
	end
	if distance >= 15 then
		action._when = 620
	end
	if distance >= 20 then
		action._when = 670
	end
	if distance >= 25 then
		action._when = 720
	end
	if distance >= 27 then
		action._when = 750
	end
	action._type = "Parry"
	action.hitbox = Vector3.new(20, 15, 27)
	action.name = string.format("(%.2f) Dynamic Gale Lunge Windup Timing", distance)
	return self:action(timing, action)
end
