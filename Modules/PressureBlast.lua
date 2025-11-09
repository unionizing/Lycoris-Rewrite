---@type Action
local Action = getfenv().Action

---@module Modules.Globals.Mantra
local Mantra = getfenv().Mantra

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local data = Mantra.data(self.entity, "Mantra:StrongPunchWeaponHeavy{{Pressure Blast}}")
	local range = data.magnifying * 1.5 + data.glass * 1
	timing.pfh = true

	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 650
	if distance >= 25 then
		action._when = math.min(700 + distance * 6, 1000)
	end
	action._type = "Start Block"
	action.hitbox = Vector3.new(30 + range, 20 + range, 50 + range)
	action.name = string.format("(%.2f) Dynamic Pressure Blast Timing", distance)
	self:action(timing, action)

	local action = Action.new()
	action._when = 1400
	action._type = "End Block"
	action.ihbc = true
	action.name = string.format("(%.2f) Dynamic Pressure Blast Timing", distance)
	return self:action(timing, action)
end
