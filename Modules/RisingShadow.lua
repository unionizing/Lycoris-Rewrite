---@type PartTiming
local PartTiming = getfenv().PartTiming

---@type Action
local Action = getfenv().Action

---@module Modules.Globals.Mantra
local Mantra = getfenv().Mantra

---@type ProjectileTracker
---@diagnostic disable-next-line: unused-local
local ProjectileTracker = getfenv().ProjectileTracker

---@module Features.Combat.Defense
local Defense = getfenv().Defense

---@module Utility.TaskSpawner
local TaskSpawner = getfenv().TaskSpawner

---@module Game.Latency
local Latency = getfenv().Latency

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	---@note: This can get move stacked.
	timing.forced = true

	TaskSpawner.spawn("Module_RisingShadow", function()
		local data = Mantra.data(self.entity, "Mantra:RisingSlashShadow{{Rising Shadow}}")
		local range = data.rush * 3 + data.drift * 2
		local thrown = workspace:FindFirstChild("Thrown")
		if not thrown then
			return
		end

		local tracker = ProjectileTracker.new(function(candidate)
			return candidate.Name == "TRACKER"
		end)

		task.wait(0.70 - Latency.rtt())

		if self:distance(self.entity) <= 20 then
			local action = Action.new()
			action._type = "Start Block"
			action._when = 0
			action.name = "Rising Shadow Close Timing"
			action.ihbc = true
			self:action(timing, action)

			local actionTwo = Action.new()
			actionTwo._type = "End Block"
			action.name = "Rising Shadow End"
			actionTwo._when = 1000
			actionTwo.ihbc = true
			return self:action(timing, actionTwo)
		end

		local action = Action.new()
		action._when = 0
		action._type = "Start Block"
		action.name = "Rising Shadow Part"

		local actionTwo = Action.new()
		actionTwo._when = 1000
		actionTwo.name = "Rising Shadow End"
		actionTwo._type = "End Block"
		actionTwo.ihbc = true

		local pt = PartTiming.new()
		pt.uhc = true
		pt.duih = true
		pt.fhb = false
		pt.name = "RisingShadowProjectile"
		pt.hitbox = Vector3.new(22 + range, 22 + range, 22 + range)
		pt.actions:push(action)
		pt.actions:push(actionTwo)
		pt.cbm = true

		Defense.cdpo(tracker:wait(), pt)
	end)
end
