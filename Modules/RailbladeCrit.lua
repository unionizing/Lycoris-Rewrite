---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	timing.duih = false
	timing.fhb = false

	local action = Action.new()
	action._when = 350
	action._type = "Parry"
	action.hitbox = Vector3.new(20, 20, 25)
	action.name = string.format("(1) (%.2f) Dynamic Railblade Crit Timing", self.track.Speed)
	self:action(timing, action)

	repeat
		task.wait()
	until self.track.TimePosition >= 0.5 or not self.track.IsPlaying

	if not self.track.IsPlaying then
		return
	end

	timing.duih = true
	timing.hitbox = Vector3.new(20, 15, 20)
	timing.fhb = true

	local actionTwo = Action.new()
	actionTwo._when = 0
	actionTwo._type = "Parry"
	actionTwo.name = string.format("(2) (%.2f) Dynamic Railblade Crit Timing", self.track.Speed)
	self:action(timing, actionTwo)
end
