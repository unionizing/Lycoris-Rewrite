---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = math.min(350 + distance * 6)
	action._type = "Parry"
	action.hitbox = Vector3.new(50, 40, 50)
	action.name = string.format("(%.2f) Dynamic Rat King Turn Dash", distance)
	return self:action(timing, action)
end
