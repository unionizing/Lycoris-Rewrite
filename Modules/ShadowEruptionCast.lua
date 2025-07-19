---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local thrown = workspace:FindFirstChild("Thrown")
	if not thrown then
		return
	end

	local action = Action.new()
	action._type = "Parry"

	if thrown:FindFirstChild("ChainPortalShadow") then
		action._when = 250
		action.hitbox = Vector3.new(10, 10, 15)
		action.name = "Shadow Chains Timing"
		timing.fhb = true
	else
		action._when = 50
		action.hitbox = Vector3.new(25, 25, 25)
		action.name = "Shadow Eruption Timing"
		timing.fhb = false
	end

	self:action(timing, action)
end
