---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	-- First parry at 200ms
	task.delay(0.2, function()
		if not self or not self.entity then
			return
		end

		local action = Action.new()
		local distance = self:distance(self.entity)
		timing.fhb = true
		action._when = 150
		if distance >= 11 then
			action._when = math.min(50 + distance * 16)
		end
		action._type = "Parry"
		action.hitbox = Vector3.new(23, 25, 40)
		action.name = string.format("(%.2f) Dynamic Railblade Crit Timing", self.track.Speed)
		self:action(timing, action)
	end)

	repeat
		task.wait()
	until not self or not self.track or self.track.TimePosition >= 1.15

	if not self or not self.entity or not self.track then
		return
	end

	local action = Action.new()
	timing.fhb = true
	action._when = 0
	action._type = "Parry"
	action.hitbox = Vector3.new(32, 25, 28)
	action.name = string.format("(%.2f) Dynamic Railblade Crit Timing", self.track.Speed)
	self:action(timing, action)
end
