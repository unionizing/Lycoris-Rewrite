---@module Modules.Globals.ProjectileListener
local ProjectileListener = getfenv().ProjectileListener

---@class Action
local Action = getfenv().Action

---@module Features.Combat.Defense
local Defense = getfenv().Defense

---@module Game.Timings.PartTiming
local PartTiming = getfenv().PartTiming

-- Listener object.
local plistener = ProjectileListener.new("IceForgeNewCharge")

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	plistener:connect(function(child)
		if child.Name ~= "IceShuriken" then
			return
		end

		local action = Action.new()
		action._when = 0
		action._type = "Parry"
		action.name = "Ice Shuriken Part"

		local pt = PartTiming.new()
		pt.uhc = false
		pt.duih = true
		pt.fhb = false
		pt.name = "IceShurikenProjectile"
		pt.hitbox = Vector3.new(50, 50, 50)
		pt.actions:push(action)

		Defense.cdpo(child, pt)
	end)
end
