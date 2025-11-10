---@type PartTiming
local PartTiming = getfenv().PartTiming

---@type Action
local Action = getfenv().Action

---@type ProjectileTracker
---@diagnostic disable-next-line: unused-local
local ProjectileTracker = getfenv().ProjectileTracker

---@module Features.Combat.Defense
local Defense = getfenv().Defense

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local thrown = workspace:FindFirstChild("Thrown")
	if not thrown then
		return
	end

	local tracker = ProjectileTracker.new(function(candidate)
		return candidate.Name == "Secondary"
	end)

	task.wait(0.5 - self.rtt())

	if self:distance(self.entity) <= 20 then
		local action = Action.new()
		action._type = "Parry"
		action._when = 0
		action.name = "Table Flip Close Timing"
		action.hitbox = Vector3.new(20, 20, 20)
		action.fhb = true
		action.ihbc = false
		return self:action(timing, action)
	end

	local action = Action.new()
	action._when = 0
	action._type = "Parry"
	action.name = "Table Flip Part"

	local pt = PartTiming.new()
	pt.uhc = true
	pt.duih = true
	pt.fhb = true
	pt.name = "TableFlipProjectile"
	pt.hitbox = Vector3.new(20, 20, 20)
	pt.actions:push(action)
	pt.cbm = true

	Defense.cdpo(tracker:wait(), pt)
end
