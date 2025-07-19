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

	local action = Weapon.action(self.entity, 325 * 1.11)
	if not action then
		return
	end

	action.name = "Dynamic Fist Swing"
	action.hitbox = Vector3.new(data.length * 1.75, data.length * 2, data.length * 2)
	return self:action(timing, action)
end
