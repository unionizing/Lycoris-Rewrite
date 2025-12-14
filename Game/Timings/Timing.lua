---@module Game.Timings.ActionContainer
local ActionContainer = require("Game/Timings/ActionContainer")

---@class Timing
---@field name string
---@field tag string
---@field imdd number Initial minimum distance from position.
---@field imxd number Initial maximum distance from position.
---@field punishable number Punishable window in seconds.
---@field after number After window in seconds.
---@field duih boolean Delay until in hitbox.
---@field actions ActionContainer
---@field hitbox Vector3
---@field umoa boolean Use module over actions.
---@field smn boolean Skip module notification.
---@field srpn boolean Skip repeat notification.
---@field smod string Selected module string.
---@field aatk boolean Allow attacking.
---@field fhb boolean Hitbox facing offset.
---@field hso number Hitbox shift offset. This offset is applied backwards. Positive is backwards, negative is forwards.
---@field ndfb boolean No dash fallback.
---@field cbm boolean A non-saved field to indicate whether this was non-part-timing created by a module.
---@field nvfb boolean No vent fallback.
---@field bfht number Block fallback hold time.
---@field pbfb boolean Prefer block fallback.
---@field forced boolean Hidden field which allows us to force tasks to go through.
---@field htype Enum.PartType Shape of hitbox. Never accessible unless inside of a module or inside of real code. This is never serialized.
---@field rpue boolean Prefer repeat usage.
---@field _rsd number Repeat start delay. Never access directly.
---@field _rpd number Repeat parry delay. Never access directly.
---@field nbfb boolean No block fallback.
local Timing = {}
Timing.__index = Timing

---Getter for repeat start delay in seconds
---@return number
function Timing:rsd()
	return PP_SCRAMBLE_NUM(self._rsd) / 1000
end

---Getter for repeat parry delay in seconds.
---@return number
function Timing:rpd()
	return PP_SCRAMBLE_NUM(self._rpd) / 1000
end

---Timing ID. Override me.
---@return string
function Timing:id()
	return self.name
end

---Set timing ID. Override me.
---@param id string
function Timing:set(id)
	self.name = id
end

---Load from partial values.
---@param values table
function Timing:load(values)
	if typeof(values.name) == "string" then
		self.name = values.name
	end

	if typeof(values.tag) == "string" then
		self.tag = values.tag
	end

	if typeof(values.imdd) == "number" then
		self.imdd = values.imdd
	end

	if typeof(values.imxd) == "number" then
		self.imxd = values.imxd
	end

	if typeof(values.duih) == "boolean" then
		self.duih = values.duih
	end

	if typeof(values.punishable) == "number" then
		self.punishable = values.punishable
	end

	if typeof(values.after) == "number" then
		self.after = values.after
	end

	if typeof(values.actions) == "table" then
		self.actions:load(values.actions)
	end

	if typeof(values.smn) == "boolean" then
		self.smn = values.smn
	end

	if typeof(values.hitbox) == "table" then
		self.hitbox = Vector3.new(values.hitbox.X or 0, values.hitbox.Y or 0, values.hitbox.Z or 0)
	end

	if typeof(values.umoa) == "boolean" then
		self.umoa = values.umoa
	end

	if typeof(values.srpn) == "boolean" then
		self.srpn = values.srpn
	end

	if typeof(values.smod) == "string" then
		self.smod = values.smod
	end

	if typeof(values.aatk) == "boolean" then
		self.aatk = values.aatk
	end

	if typeof(values.fhb) == "boolean" then
		self.fhb = values.fhb
	end

	if typeof(values.hso) == "number" then
		self.hso = values.hso
	end

	if typeof(values.ndfb) == "boolean" then
		self.ndfb = values.ndfb
	end

	if typeof(values.nvfb) == "boolean" then
		self.nvfb = values.nvfb
	end

	if typeof(values.bfht) == "number" then
		self.bfht = values.bfht
	end

	if typeof(values.rsd) == "string" then
		self._rsd = tonumber(values.rsd) or 0.0
	end

	if typeof(values.rpd) == "string" then
		self._rpd = tonumber(values.rpd) or 0.0
	end

	if typeof(values.rsd) == "number" then
		self._rsd = values.rsd
	end

	if typeof(values.rpd) == "number" then
		self._rpd = values.rpd
	end

	if typeof(values.rpue) == "boolean" then
		self.rpue = values.rpue
	end

	if typeof(values.nbfb) == "boolean" then
		self.nbfb = values.nbfb
	end
end

---Equals check.
---@param other Timing
---@return boolean
function Timing:equals(other)
	if self.name ~= other.name then
		return false
	end

	if self.tag ~= other.tag then
		return false
	end

	if self.imdd ~= other.imdd then
		return false
	end

	if self.imxd ~= other.imxd then
		return false
	end

	if self.duih ~= other.duih then
		return false
	end

	if self.punishable ~= other.punishable then
		return false
	end

	if self.after ~= other.after then
		return false
	end

	if not self.actions:equals(other.actions) then
		return false
	end

	if self.smn ~= other.smn then
		return false
	end

	if self.hitbox ~= other.hitbox then
		return false
	end

	if self.umoa ~= other.umoa then
		return false
	end

	if self.hso ~= other.hso then
		return false
	end

	if self.srpn ~= other.srpn then
		return false
	end

	if self.smod ~= other.smod then
		return false
	end

	if self.aatk ~= other.aatk then
		return false
	end

	if self.fhb ~= other.fhb then
		return false
	end

	if self.ndfb ~= other.ndfb then
		return false
	end

	if self.nvfb ~= other.nvfb then
		return false
	end

	if self.bfht ~= other.bfht then
		return false
	end

	if self.rpue ~= other.rpue then
		return false
	end

	if self._rsd ~= other._rsd then
		return false
	end

	if self._rpd ~= other._rpd then
		return false
	end

	if self.nbfb ~= other.nbfb then
		return false
	end

	return true
end

---Clone timing.
---@return Timing
function Timing:clone()
	local clone = Timing.new()

	clone.name = self.name
	clone.tag = self.tag
	clone.duih = self.duih
	clone.imdd = self.imdd
	clone.imxd = self.imxd
	clone.smn = self.smn
	clone.punishable = self.punishable
	clone.after = self.after
	clone.actions = self.actions:clone()
	clone.hitbox = self.hitbox
	clone.umoa = self.umoa
	clone.srpn = self.srpn
	clone.smod = self.smod
	clone.aatk = self.aatk
	clone.fhb = self.fhb
	clone.ndfb = self.ndfb
	clone.hso = self.hso
	clone.nvfb = self.nvfb
	clone.bfht = self.bfht
	clone.rpue = self.rpue
	clone._rsd = self._rsd
	clone._rpd = self._rpd
	clone.nbfb = self.nbfb

	return clone
end

---Return a serializable table.
---@return table
function Timing:serialize()
	return {
		name = self.name,
		tag = self.tag,
		imdd = self.imdd,
		imxd = self.imxd,
		duih = self.duih,
		punishable = self.punishable,
		smn = self.smn,
		after = self.after,
		actions = self.actions:serialize(),
		hitbox = {
			X = self.hitbox.X,
			Y = self.hitbox.Y,
			Z = self.hitbox.Z,
		},
		srpn = self.srpn,
		umoa = self.umoa,
		smod = self.smod,
		aatk = self.aatk,
		fhb = self.fhb,
		ndfb = self.ndfb,
		phd = self.phd,
		pfh = self.pfh,
		hso = self.hso,
		nvfb = self.nvfb,
		bfht = self.bfht,
		rpue = self.rpue,
		rsd = self._rsd,
		rpd = self._rpd,
		nbfb = self.nbfb,
	}
end

---Create new Timing object.
---@param values table?
---@return Timing
function Timing.new(values)
	local self = setmetatable({}, Timing)

	self.tag = "Undefined"
	self.name = "N/A"
	self.imdd = 0
	self.imxd = 0
	self.smn = false
	self.punishable = 0
	self.after = 0
	self.rpue = false
	self._rsd = 0
	self._rpd = 0
	self.duih = false
	self.actions = ActionContainer.new()
	self.hitbox = Vector3.zero
	self.umoa = false
	self.srpn = false
	self.smod = "N/A"
	self.aatk = false
	self.fhb = true
	self.ndfb = false
	self.hso = 0
	self.nvfb = false
	self.bfht = 0.3
	self.nbfb = false

	if values then
		self:load(values)
	end

	return self
end

-- Return Timing module.
return Timing
