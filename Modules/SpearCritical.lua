---@module Modules.Globals.Weapon
local Weapon = getfenv().Weapon

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Weapon.action(self.entity, 400 * 0.93, true)
	if not action then
		return
	end

	action.name = "Dynamic Spear Critical Timing"

	return self:action(timing, action)
end
