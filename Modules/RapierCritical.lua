---@module Modules.Globals.Weapon
local Weapon = getfenv().Weapon

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Weapon.action(self.entity, 450 * 1.09, true)
	if not action then
		return
	end

	action.name = "Dynamic Rapier Critical"

	return self:action(timing, action)
end
