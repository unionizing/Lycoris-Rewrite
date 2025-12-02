---@class Action
local Action = getfenv().Action

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

	-- Fallbacks. Reset to normal.
	timing.nvfb = true
	timing.pbfb = false
	timing.ndfb = false
	timing.bfht = 0.3

	-- Prediction settings.
	timing.dp = false
	timing.pfh = true
	timing.phd = true

	-- Prediction history times.
	timing.pfht = 0.25
	timing.phds = 0.6

	if data.type == "Fist" or data.type == "Dagger" then
		timing.pbfb = true
		timing.bfht = 0.6
		timing.phds = data.type == "Dagger" and 0.6 or 0.25
		timing.pfh = false
		timing.dp = true
	end

	if
		data.type == "Sword"
		or data.type == "Twinblade"
		or data.type == "Spear"
		or data.type == "Club"
		or data.type == "Rifle"
		or data.type == "Pistol"
	then
		timing.pbfb = true
		timing.bfht = 0.6
		timing.phd = false
		timing.ffh = true
		timing.dp = data.type ~= "Spear"
	end

	if
		data.type == "Greathammer"
		or data.type == "Greatcannon"
		or data.type == "Greatsword"
		or data.type == "Greataxe"
	then
		timing.phd = false
		timing.ffh = true
		timing.pfht = 0.5
		timing.dp = false
	end

	local windup = nil

	-- Windup + 0-speed duration.

	if data.type == "Greataxe" then
		windup = (0.18 / self.track.Speed) + 0.100
	elseif data.type == "Greathammer" then
		windup = (0.14 / self.track.Speed) + 0.140
	elseif data.type == "Greatsword" then
		windup = (0.17 / self.track.Speed) + 0.050
	elseif data.type == "Twinblade" then
		windup = (0.166 / self.track.Speed) + 0.140
	elseif data.type == "Bow" then
		windup = (0.172 / self.track.Speed) + 0.140
	elseif data.type == "Pistol" then
		windup = 0.500 / data.ss
	elseif data.type == "Greatcannon" then
		windup = (0.173 / self.track.Speed) + 0.160
	elseif data.type == "Dagger" then
		windup = (0.165 / self.track.Speed) + 0.100
	elseif data.type == "Rapier" then
		windup = (0.163 / self.track.Speed) + 0.120
	elseif data.type == "Spear" then
		windup = (0.135 / self.track.Speed) + 0.180
	elseif data.type == "Fist" then
		windup = (0.160 / self.track.Speed) + 0.140
	elseif data.type == "Sword" then
		windup = (0.16 / self.track.Speed) + 0.120
	elseif data.type == "Club" then
		windup = (0.16 / self.track.Speed) + 0.150
	elseif data.type == "Rifle" then
		windup = (0.16 / self.track.Speed) + 0.150
	end

	if not windup then
		return self:notify(timing, "(%s) No windup for this weapon type.", data.type)
	end

	-- Create action.
	local action = Action.new()
	action._when = windup * 1000
	action._type = "Parry"
	action.hitbox = Vector3.new(data.length * 2.7, data.length * 3, data.length * 1.8)

	if data.type == "Bow" then
		action.hitbox = Vector3.new(data.length * 1.5, data.length * 2, data.length * 1.5)
	end

	if data.type == "Pistol" then
		action.hitbox = Vector3.new(data.length * 1.5, data.length * 2, data.length * 1.25)
	end

	if data.type == "Rapier" or data.type == "Spear" then
		action.hitbox = Vector3.new(data.length * 1.7, data.length * 3, data.length * 2.1)
	end

	if data.type == "Sword" or data.type == "Twinblade" then
		action.hitbox = Vector3.new(data.length * 2.0, data.length * 3, data.length * 2.0)
	end

	if
		data.type == "Greathammer"
		or data.type == "Greatcannon"
		or data.type == "Greatsword"
		or data.type == "Greataxe"
	then
		action.hitbox = Vector3.new(data.length * 2, data.length * 2, data.length * 1.6)
	end

	if data.type == "Fist" or data.type == "Dagger" then
		action.hitbox = Vector3.new(data.length * 2.7, data.length * 3, data.length * 2)
	end

	action.name = string.format(
		"(%.2f, %.2f, %.2f) (%.2f) Dynamic Weapon Flourish",
		data.oss,
		data.ss,
		self.track.Speed,
		data.length
	)

	return self:action(timing, action)
end
