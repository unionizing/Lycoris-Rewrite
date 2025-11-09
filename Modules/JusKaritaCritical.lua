---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Action.new()
	action._when = 500
	action._type = "Parry"
	action.hitbox = Vector3.new(16, 14, 20)
	action.name = "Static Jus Karita Critical"
	return self:action(timing, action)
end
