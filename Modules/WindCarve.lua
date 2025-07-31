---@class Action
local Action = getfenv().Action

---@module Modules.Globals.Mantra
local Mantra = getfenv().Mantra

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local data = Mantra.data(self.entity, "Mantra:CarveWind{{Wind Carve}}")
	local range = data.perfect * 2 + data.crystal * 1
	local size = data.stratus * 2.5 + data.cloud * 1.5

	local action = Action.new()
	action._when = 450
	action._type = "Parry"
	action.hitbox = Vector3.new(14 + size, 10 + size, 14 + range)
	action.name = "Dynamic Wind Carve Timing"
	timing.duih = true
	timing.hitbox = action.hitbox

	self:action(timing, action)
end
