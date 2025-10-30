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
		return candidate.Name:match("SpiritProjectile")
	end)

	task.wait(0.6 - self.rtt())

	if self:distance(self.entity) <= 25 then
		local action = Action.new()
		action._type = "Parry"
		action._when = 100
		action.name = "Putrid Edenstaff Close Timing (1)"
		action.hitbox = Vector3.new(25, 25, 25)
		action.fhb = false
		action.ihbc = false
		self:action(timing, action)

		local actionTwo = Action.new()
		actionTwo._type = "Dodge"
		actionTwo._when = 1000
		actionTwo.name = "Putrid Edenstaff Close Timing (2)"
		actionTwo.fhb = false
		actionTwo.ihbc = true
		self:action(timing, actionTwo)
	end

	local action = Action.new()
	action._when = 0
	action._type = "Dodge"
	action.name = "Putrid Edenstaff Part"

	local pt = PartTiming.new()
	pt.uhc = true
	pt.duih = true
	pt.fhb = true
	pt.name = "PutridEdenstaffProjectile"
	pt.hitbox = Vector3.new(20, 20, 32)
	pt.actions:push(action)
	pt.cbm = true

	Defense.cdpo(tracker:wait(), pt)
end
