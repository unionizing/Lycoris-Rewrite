---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local timings = {
		[1] = 600,
		[2] = 1000,
		[3] = 1470,
		[4] = 1850,
		[5] = 2280,
		[6] = 2750,
	}

	local humanoid = self.entity:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	for idx = 1, 6 do
		local action = Action.new()
		action._when = timings[idx] or 0
		action._type = "Parry"
		action.hitbox = Vector3.new(80, 250, 80)
		action.name = "Dynamic Primadon Timing"

		if humanoid.Health <= (humanoid.MaxHealth / 2) then
			action._when /= 1.25
		end

		self:action(timing, action)
	end
end
