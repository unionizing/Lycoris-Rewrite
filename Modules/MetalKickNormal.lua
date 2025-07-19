---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Action.new()
	action._when = 500
	action._type = "Parry"
	action.hitbox = Vector3.new(20, 100, 20)
	action.name = "Metal Kick Assume Fast"
	self:action(timing, action)

	repeat
		task.wait()
	until not self.track.IsPlaying

	if self.track.Speed >= 1.5 then
		return
	end

	local fallbackAction = Action.new()
	fallbackAction._when = 150
	fallbackAction._type = "Dodge"
	fallbackAction.hitbox = Vector3.new(20, 100, 20)
	fallbackAction.name = "Metal Kick Slow Dodge"
	self:action(timing, fallbackAction)
end
