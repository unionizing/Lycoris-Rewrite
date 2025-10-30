---@module Modules.Globals.ProjectileListener
local ProjectileListener = getfenv().ProjectileListener

---@type PartTiming
local PartTiming = getfenv().PartTiming

---@type Action
local Action = getfenv().Action

---@module Features.Combat.Defense
local Defense = getfenv().Defense

-- Create listener for Fire Forge projectiles
local plistener = ProjectileListener.new("FireForge")

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	plistener:connect(function(child)
		if not child.Name:match("FireDagger") then
			return
		end

		task.wait(0.05 - self.rtt())

		if self:distance(self.entity) <= 20 then
			local action = Action.new()
			action._type = "Parry"
			action._when = 0
			action.name = "Fire Forge Close Timing"
			action.hitbox = Vector3.new(18, 18, 25)
			action.fhb = true
			action.ihbc = false
			return self:action(timing, action)
		end

		local action = Action.new()
		action._when = 0
		action._type = "Parry"
		action.name = "Fire Forge Part"

		local pt = PartTiming.new()
		pt.uhc = true
		pt.duih = true
		pt.fhb = false
		pt.name = "FireForgeProjectile"
		pt.hitbox = Vector3.new(5, 25, 5)
		pt.actions:push(action)
		pt.cbm = true

		Defense.cdpo(child, pt)
	end)
end
