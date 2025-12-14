---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Action.new()
	action._when = 1150
	action._type = "Parry"
	action.hitbox = Vector3.new(30, 55, 55)
	action.name = string.format("(%.2f) Ice Guy Regular Timing", self.track.Speed)

	if self.entity.Name:match(".iceguysniperepic") then
		action._when = 950
		action.name = string.format("(%.2f) Ice Guy Sniper Timing", self.track.Speed)
	end

	return self:action(timing, action)
end
