---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 650
	action._type = "Dodge"
	if distance >= 25 then
		action._when = math.min(325 + distance * 13, 3000)
	end
	action.hitbox = Vector3.new(40, 40, 100)
	action.name = string.format("(%.2f) Pillars of Erisia Timing", distance)

	if self.entity.Name:match(".theduke") then
		action._when = math.min(650 + distance * 9, 3000)
		action._type = "Dodge"
		action.hitbox = Vector3.new(40, 40, 100)
		action.name = string.format("(%.2f) Dynamic Duke Stomp Timing", distance)
	end

	return self:action(timing, action)
end
