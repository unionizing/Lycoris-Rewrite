---@module Modules.Globals.Weapon
local Weapon = getfenv().Weapon

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local data = Weapon.data(self.entity)
	if not data then
		return
	end

	local base = 400
	local name = data.hw:GetAttribute("WeaponName")

	-- Bloodfouler uppercut
	if name:match("Bloodfouler") then
		base = 350 * 0.83
	end

	local action = Weapon.action(self.entity, base, true)
	if not action then
		return
	end

	action.name = "Dynamic Sword Swing"

	return self:action(timing, action)
end
