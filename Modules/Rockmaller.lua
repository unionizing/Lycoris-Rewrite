---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)

	local action = Action.new()
	action._when = 350
	if distance >= 11 then
		action._when = math.min(225 + distance * 26)
	end
	action._type = "Parry"
	action.hitbox = Vector3.new(15, 15, 25)
	action.name = string.format("(%.2f) Dynamic Rockmaller Crit Timing", distance)

	return self:action(timing, action)
end
