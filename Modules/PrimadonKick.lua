---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Action.new()
	action._when = (900 * 0.95) / self.track.Speed
	action._type = "Dodge"
	action.hitbox = Vector3.new(80, 250, 80)
	action.name = "Dynamic Primadon Timing"
	return self:action(timing, action)
end
