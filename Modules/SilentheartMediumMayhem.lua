---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	timing.pfh = true

	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 400

	if self.track.Speed >= 0.7 then
		action._when = 350
	end

	if distance >= 10 then
		action._when = action._when + 25
	end

	if distance >= 20 then
		action._when = action._when + 25
	end

	action._type = "Parry"
	action.hitbox = Vector3.new(20, 15, 45)
	action.name = string.format("(%.2f) (%.2f) Mayhem Silentheart Timing", self.track.Speed, distance)
	self:action(timing, action)
end
