---@class Action
local Action = getfenv().Action

---@module Features.Combat.Objects.RepeatInfo
local RepeatInfo = getfenv().RepeatInfo

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local info = RepeatInfo.new(timing, self.rdelay(), self:uid(10))
	info.track = self.track

	local action = Action.new()
	timing.fhb = false
	timing.rpue = true
	timing.duih = true
	timing.imdd = 0
	timing.imxd = 100
	timing._rsd = 450
	timing._rpd = 500
	timing.hitbox = Vector3.new(18, 15, 27)

	self:srpue(self.entity, timing, info)
end
