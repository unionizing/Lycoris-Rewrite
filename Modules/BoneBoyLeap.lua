---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Action.new()
	action._when = 150
	action._type = "Teleport Up"
	action.hitbox = Vector3.new(50, 50, 50)
	action.name = "Bone Boy Leap"
	timing.aatk = true
	return self:action(timing, action)
end
