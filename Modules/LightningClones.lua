---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local hrp = self.entity:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	if hrp:WaitForChild("REP_SOUND_5010389678", 0.4) then
		local action = Action.new()
		action._when = 150
		action._type = "Parry"
		action.hitbox = Vector3.new(12, 12, 12)
		action.name = "Lightning Clones Timing"
		return self:action(timing, action)
	end
end
