---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	timing.ffh = true
	timing.duih = false

	local dist = self:distance(self.entity)

	if dist <= 20 then
		local action = Action.new()
		action._when = 500
		action._type = "Parry"
		action.ihbc = true
		action.name = string.format("(%.2f) Close Wyrm Crit Timing", dist)
		return self:action(timing, action)
	end

	local actionTwo = Action.new()
	actionTwo._when = 650
	actionTwo._type = "Parry"
	actionTwo.ihbc = true
	actionTwo.name = string.format("(%.2f) Far Wyrm Crit Timing", dist)
	return self:action(timing, actionTwo)
end
