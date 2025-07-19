---@module Modules.Globals.Weapon
local Weapon = getfenv().Weapon

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Weapon.action(self.entity, 700 * 0.83, true)
	if not action then
		return
	end

	action.name = "Dynamic Greataxe Timing"

	return self:action(timing, action)
end
