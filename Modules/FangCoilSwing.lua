---@module Modules.Globals.Weapon
local Weapon = getfenv().Weapon

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Weapon.action(self.entity, 350 * 1.11)
	action.name = "Dynamic Fang Coil Swing"
	return self:action(timing, action)
end
