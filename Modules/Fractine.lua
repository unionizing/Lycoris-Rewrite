---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local rightHand = self.entity:FindFirstChild("RightHand")
	local leftHand = self.entity:FindFirstChild("LeftHand")
	if not rightHand or not leftHand then
		return
	end

	local handWeapon = rightHand:FindFirstChild("HandWeapon") or leftHand:FindFirstChild("HandWeapon")
	if not handWeapon then
		return
	end

	if handWeapon:GetAttribute("WeaponName") == "Ferractine" then
		local action = Action.new()
		action._when = 250
		action._type = "Parry"
		action.hitbox = Vector3.new(24, 15, 27)
		action.name = string.format("(%.2f) VOI Fractine Crit (1)", self.track.Speed)
		self:action(timing, action)

		local actionTwo = Action.new()
		actionTwo._when = 850
		actionTwo._type = "Parry"
		actionTwo.hitbox = Vector3.new(30, 15, 35)
		actionTwo.name = string.format("(%.2f) VOI Fractine Crit (2)", self.track.Speed)

		return self:action(timing, actionTwo)
	end

	local action = Action.new()
	action._when = 500
	action._type = "Parry"
	action.hitbox = Vector3.new(24, 15, 27)
	action.name = string.format("(%.2f) Fractine Crit (1)", self.track.Speed)
	self:action(timing, action)

	local actionTwo = Action.new()
	actionTwo._when = 1300
	actionTwo._type = "Parry"
	actionTwo.hitbox = Vector3.new(30, 15, 35)
	actionTwo.name = string.format("(%.2f) Fractine Crit (2)", self.track.Speed)

	return self:action(timing, actionTwo)
end
