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

	local action = Weapon.action(self.entity, 400, false)
	if not action then
		return
	end

	action.name = "Dynamic Flourish Attack"

	return self:action(timing, action)
end
