---@module Modules.Globals.ProjectileListener
local ProjectileListener = getfenv().ProjectileListener

---@class Action
local Action = getfenv().Action

---@module Features.Combat.Defense
local Defense = getfenv().Defense

---@module Game.Timings.PartTiming
local PartTiming = getfenv().PartTiming

-- Listener object.
local plistener = ProjectileListener.new("IceSpike")

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	plistener:connect(function(child)
		if child.Name ~= "IceCircle" then
			return
		end

		local action = Action.new()
		action._when = 250
		action._type = "Parry"
		action.name = "Ice Circle Part"
		action.hitbox = Vector3.new(15, 50, 15)

		local pt = PartTiming.new()
		pt.uhc = false
		pt.duih = false
		pt.fhb = false
		pt.imdd = 0
		pt.imxd = 100
		pt.name = "IceCircleProjectile"
		pt.actions:push(action)

		Defense.cdpo(child, pt)
	end)
end
