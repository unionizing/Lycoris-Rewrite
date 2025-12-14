---@module Features.Combat.Objects.RepeatInfo
local RepeatInfo = getfenv().RepeatInfo

---@module Game.Latency
local Latency = getfenv().Latency

---@module Game.Timings.PartTiming
local PartTiming = getfenv().PartTiming

---Module function.
---@param self PartDefender
---@param timing PartTiming
return function(self, timing)
	local ntiming = PartTiming.new()
	ntiming.name = "SinisterHaloRepeat"
	ntiming.duih = true
	ntiming.hitbox = Vector3.new(20, 20, 20)
	ntiming.fhb = false
	ntiming.ndfb = true
	ntiming._rsd = 0
	ntiming._rpd = 200
	ntiming.imxd = 120
	ntiming.imdd = 0

	ntiming.rsd = function()
		return ntiming._rsd / 1000
	end

	ntiming.rpd = function()
		return ntiming._rpd / 1000
	end

	self:hook("rc", function(...)
		return self.part.Parent ~= nil
	end)

	local info = RepeatInfo.new(ntiming, Latency.rdelay(), self:uid(10))
	self:srpue(self.part, ntiming, info)
end
