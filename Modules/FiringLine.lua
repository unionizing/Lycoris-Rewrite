---@module Modules.Globals.ProjectileListener
local ProjectileListener = getfenv().ProjectileListener

---@class Action
local Action = getfenv().Action

---@module Features.Combat.Defense
local Defense = getfenv().Defense

---@module Game.Timings.PartTiming
local PartTiming = getfenv().PartTiming

-- Listener object.
local plistener = ProjectileListener.new()

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	plistener:callback(function(child)
		if child.Name ~= "MetalBullet" then
			return
		end

		local action = Action.new()
		action._when = 0
		action._type = "Parry"
		action.name = "Metal Bullet Part"

		local pt = PartTiming.new()
		pt.uhc = true
		pt.duih = true
		pt.fhb = true
		pt.name = "MetalBulletProjectile"
		pt.hitbox = Vector3.new(100, 50, 100)
		pt.actions:push(action)

		Defense.cdpo(child, pt)
	end)
end
