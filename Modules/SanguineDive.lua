---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local hrp = self.entity:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	if not hrp:FindFirstChild("REP_SOUND_15776883508") then
		return
	end

	local action = Action.new()
	action._when = 200
	action._type = "Parry"
	action.hitbox = Vector3.new(19, 14, 12)
	action.name = "Sanguine Dive Timing"
	self:action(timing, action)
end
