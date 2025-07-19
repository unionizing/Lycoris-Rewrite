-- Timestamp.
local lastEncircleTimestamp = nil

---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	if self:distance(self.entity) > 12 then
		return
	end

	if lastEncircleTimestamp and os.clock() - lastEncircleTimestamp <= 1.0 then
		return
	end

	self:hook("target", function()
		return true
	end)

	lastEncircleTimestamp = os.clock()

	timing.fhb = false

	local action = Action.new()
	action._when = 750
	action._type = "Parry"
	action.ihbc = true
	action.name = "Shadow Encircle Timing"
	self:action(timing, action)
end
