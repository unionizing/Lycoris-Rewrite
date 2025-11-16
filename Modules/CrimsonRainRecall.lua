---@module Modules.Globals.ProjectileListener
local ProjectileListener = getfenv().ProjectileListener

---@type PartTiming
local PartTiming = getfenv().PartTiming

---@type Action
local Action = getfenv().Action

---@module Features.Combat.Defense
local Defense = getfenv().Defense

-- Create listener for Fire Forge projectiles
local plistener = ProjectileListener.new("CrimsonRain")

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	plistener:connect(function(child)
		if not child.Name:match("BloodDagger") then
			return
		end

		task.wait(0.01 - self.rtt())

		local action = Action.new()
		action._when = 0
		action._type = "Parry"
		action.name = "Crimson Rain Dagger"

		local pt = PartTiming.new()
		pt.uhc = true
		pt.duih = true
		pt.fhb = true
		pt.name = "CrimsonRainProjectile"
		pt.hitbox = Vector3.new(12, 12, 25)
		pt.actions:push(action)
		pt.cbm = true

		Defense.cdpo(child, pt)
	end)
end
