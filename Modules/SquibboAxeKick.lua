---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 350
	action._type = "Parry"
	action.hitbox = Vector3.new(20, 33, 33)
	action.name = string.format("(%.2f) Squibbo Axe Kick Timing", distance)

	if self.entity.Name:match(".squidward_enforcer") then
		action._when = 550
		action._type = "Dodge"
		action.hitbox = Vector3.new(20, 40, 33)
		action.name = string.format("(%.2f) Squibbo Enforcer Axe Kick Timing", self.track.Speed)
	end

	return self:action(timing, action)
end
