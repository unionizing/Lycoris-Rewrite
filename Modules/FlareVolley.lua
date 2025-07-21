---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 100
	if distance >= 12 then
		action._when = 150
	end
	if distance >= 18 then
		action._when = 200
	end
	if distance >= 26 then
		action._when = 250
	end
	if distance >= 34 then
		action._when = 300
	end
	if distance >= 43 then
		action._when = 350
	end
	action._type = "Parry"
	action.hitbox = Vector3.new(15, 10, 50)
	action.name = string.format("(%.2f) Dynamic Flare Volley Timing", distance)
	return self:action(timing, action)
end
