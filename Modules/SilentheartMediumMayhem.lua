---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	timing.pfh = true

	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = math.min(400 + distance * 14.5)

	if self.track.Speed >= 0.7 then
		action._when = math.min(350 + distance * 20, 650)
	end

	action._type = "Parry"
	action.hitbox = Vector3.new(20, 15, 45)
	action.name = string.format("(%.2f) Mayhem Silentheart Timing", self.track.Speed)
	self:action(timing, action)
end
