---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	timing.ffh = true
	timing.duih = false

	local dist = self:distance(self.entity)

	if dist <= 12 then
		local action = Action.new()
		action._when = 450
		action._type = "Parry"
		action.ihbc = true
		action.name = string.format("(%.2f) Close Crescent Crit Timing", dist)
		return self:action(timing, action)
	end

	local actionTwo = Action.new()
	actionTwo._when = 800
	actionTwo._type = "Parry"
	actionTwo.ihbc = true
	actionTwo.name = string.format("(%.2f) Far Crescent Crit Timing", dist)
	return self:action(timing, actionTwo)
end
