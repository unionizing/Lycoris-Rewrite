---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)

	local action = Action.new()
	action._when = 250
	action._type = "Parry"
	action.hitbox = Vector3.new(30, 75, 55)
	action.name = string.format("(%.2f) Heavenly Wind Timing")

	if self.entity.Name:match(".evengarde") then
		timing.ieae = true
		timing.iae = true
		action._when = 200
		action.hitbox = Vector3.new(55, 55, 55)
		action.name = string.format("(%.2f) Maestro Heavenly Wind Timing")
	end

	return self:action(timing, action)
end
