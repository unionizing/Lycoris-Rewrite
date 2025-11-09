---@class Action
local Action = getfenv().Action

---@module Modules.Globals.Mantra
local Mantra = getfenv().Mantra

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local data = Mantra.data(self.entity, "Mantra:PalmMetal{{Iron Quills}}")
	local range = data.perfect * 2 + data.crystal * 1.5

	local action = Action.new()
	action._when = 350
	action._type = "Parry"
	action.hitbox = Vector3.new(20 + range, 20 + range, 20 + range)
	action.name = "Dynamic Iron Quills Timing"

	timing.hitbox = action.hitbox

	self:action(timing, action)
end
