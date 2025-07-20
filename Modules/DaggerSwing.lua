---@module Modules.Globals.Weapon
local Weapon = getfenv().Weapon

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local action = Weapon.action(self.entity, 250 * 1.25, true)
	if not action then
		return
	end

	action.hitbox += Vector3.new(0.0, 0.0, 2.5)
	action.name = "Dynamic Dagger Swing"
	return self:action(timing, action)
end
