---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Action.new()
	action._when = self.track.Speed <= 1.0 and 1250 or 1000
	action._type = "Parry"
	action.hitbox = Vector3.new(100, 100, 100)
	action.name = string.format("(%.2f) Relentless Silentheart Timing", self.track.Speed)
	self:action(timing, action)
end
