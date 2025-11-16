---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local TARGET_POINT = 0.615

	repeat
		task.wait()
	until self.track.TimePosition >= TARGET_POINT

	local action = Action.new()
	action._when = 0
	action._type = "Parry"
	action.hitbox = Vector3.new(30, 50, 30)
	action.name = string.format("(%.2f) Mayhem Silentheart Timing", self.track.Speed)

	self:action(timing, action)
end
