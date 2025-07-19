---@module Modules.Globals.Waiter
local Waiter = getfenv().Waiter

---@module Game.Timings.Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local entity = self.entity
	if not entity then
		return
	end

	local speed = Waiter.wfsc(self.track)

	local action = Action.new()
	action._when = 400 / speed
	action._type = "Parry"
	action.hitbox = Vector3.new(50, 10, 50)
	action.name = string.format("(%.2f) Ground Slide Silentheart Timing", speed)
	self:action(timing, action)
end
