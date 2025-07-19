---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	for idx = 1, 2 do
		local action = Action.new()
		action._when = 500 + (idx * 600)
		action._type = "Parry"
		action.hitbox = Vector3.new(40, 40, 40)
		action.name = "Dynamic Crocco Timing"

		if self.entity.Name:match("king") then
			action.hitbox *= 2.0
		end

		self:action(timing, action)
	end
end
