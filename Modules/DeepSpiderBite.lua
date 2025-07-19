---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local speed = self.track.Speed
	local action = Action.new()
	action._when = 400
	action._type = "Parry"
	action.hitbox = Vector3.new(40, 40, 40)
	action.name = string.format("(%.2f) Dynamic Spider Timing", speed)

	if speed > 0.9 and speed < 1.0 then
		action._when = 600
	end

	return self:action(timing, action)
end
