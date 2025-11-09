---@class Action
local Action = getfenv().Action

---@module Modules.Globals.Mantra
local Mantra = getfenv().Mantra

---@module Features.Combat.Objects.RepeatInfo
local RepeatInfo = getfenv().RepeatInfo

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local data = Mantra.data(self.entity, "Mantra:CarveWind{{Wind Carve}}")
	local range = data.stratus * 1.4 + data.cloud * 0.9

	local info = RepeatInfo.new(timing, self.rdelay(), self:uid(10))
	info.track = self.track

	local action = Action.new()
	timing.fhb = true
	timing.rpue = true
	timing.duih = true
	timing.imdd = 0
	timing.imxd = 100
	timing._rsd = 400
	timing._rpd = 500
	timing.hitbox = Vector3.new(18 + range, 15 + range, 15 + range)

	self:srpue(self.entity, timing, info)
end
