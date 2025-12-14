---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local hrp = self.entity:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	timing.duih = false

	if hrp:WaitForChild("REP_SOUND_15776883341", 0.1) then
		timing.pfh = true

		local action = Action.new()
		action._when = 400
		action._type = "Parry"
		action.hitbox = Vector3.new(20, 15, 15)
		action.name = "(1) Blood Scythe Timing"
		self:action(timing, action)

		local actionTwo = Action.new()
		actionTwo._when = 500
		actionTwo._type = "Parry"
		actionTwo.hitbox = Vector3.new(20, 15, 30)
		actionTwo.name = "(2) Blood Scythe Timing"
		return self:action(timing, actionTwo)
	else
		timing.pfh = false
		local action = Action.new()
		action._when = 300
		action._type = "Parry"
		action.hitbox = Vector3.new(16, 12, 16)
		action.name = "Scythe Timing"
		return self:action(timing, action)
	end
end
