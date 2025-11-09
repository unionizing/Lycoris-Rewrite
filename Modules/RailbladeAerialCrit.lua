---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)

	local action = Action.new()
	action._when = 400
	if distance >= 11 then
		action._when = math.min(250 + distance * 20)
	end
	action._type = "Parry"
	action.hitbox = Vector3.new(25, 30, 30)
	action.name = string.format("(%.2f) Dynamic Railblade Aerial Crit Timing", distance)

	return self:action(timing, action)
end
