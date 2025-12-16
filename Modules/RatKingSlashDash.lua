---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 580
	action._type = "Parry"
	action.hitbox = Vector3.new(40, 40, 40)
	action.name = string.format("(%.2f) Rat King Slash (1)", distance)
	self:action(timing, action)

	local actionTwo = Action.new()
	actionTwo._when = 1390
	actionTwo._type = "Parry"
	actionTwo.hitbox = Vector3.new(40, 40, 40)
	actionTwo.name = string.format("(%.2f) Rat King Slash (2)", distance)
	self:action(timing, actionTwo)

	local actionThree = Action.new()
	actionThree._when = math.min(2300 + distance * 8)
	actionThree._type = "Parry"
	actionThree.hitbox = Vector3.new(50, 50, 50)
	actionThree.name = string.format("(%.2f) Dynamic Rat King Dash (3)", distance)
	return self:action(timing, actionThree)
end
