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
		return candidate.Name == "IceDagger"
	end)

	task.wait(0.5 - self.rtt())

	if self:distance(self.entity) <= 15 then
		local actionclose = Action.new()
		actionclose._type = "Start Block"
		actionclose._when = 0
		actionclose.name = "Ice Daggers Close Timing"
		actionclose.ihbc = true
		self:action(timing, actionclose)

		local actioncloseTwo = Action.new()
		actioncloseTwo._when = 1000
		actioncloseTwo._type = "End Block"
		actioncloseTwo.ihbc = true
		self:action(timing, actioncloseTwo)
	end

	local action = Action.new()
	action._when = 0
	action._type = "Start Block"
	action.name = "Ice Dagger Part"

	local actionTwo = Action.new()
	actionTwo._when = 500
	actionTwo._type = "End Block"
	actionTwo.ihbc = true

	local pt = PartTiming.new()
	pt.uhc = true
	pt.duih = true
	pt.fhb = true
	pt.name = "IceDaggersProjectile"
	pt.hitbox = Vector3.new(20, 20, 32.5)
	pt.actions:push(action)
	pt.cbm = true

	Defense.cdpo(tracker:wait(), pt)
end
