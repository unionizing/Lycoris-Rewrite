---@module Modules.Globals.ProjectileListener
local ProjectileListener = getfenv().ProjectileListener

---@class Action
local Action = getfenv().Action

---@module Game.Timings.PartTiming
local PartTiming = getfenv().PartTiming

---@module Features.Combat.Defense
local Defense = getfenv().Defense

-- Listener object.
local plistener = ProjectileListener.new("MetalRain")

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	plistener:connect(function(child)
		if child.Name ~= "RodMetalRain" and child.Name ~= "RodMetalRain2" then
			return
		end

		local action = Action.new()
		action._when = 200
		action._type = "Parry"
		action.name = "Metal Rod Part"
		action.hitbox = Vector3.new(20, 100, 20)

		local pt = PartTiming.new()
		pt.uhc = false
		pt.duih = false
		pt.fhb = false
		pt.name = "MetalRodProjectile"
		pt.imdd = 0
		pt.imxd = 20
		pt.actions:push(action)
		pt.cbm = true

		Defense.cdpo(child, pt)
	end)
end
