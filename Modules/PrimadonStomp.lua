---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Action.new()
	action._when = (650 * 1.21) / self.track.Speed
	action._type = "Parry"
	action.hitbox = Vector3.new(40, 100, 40)
	action.name = "Dynamic Primadon Timing"
	return self:action(timing, action)
end
