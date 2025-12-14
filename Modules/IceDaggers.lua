local Players = game:GetService("Players")
---@type PartTiming
local PartTiming = getfenv().PartTiming

---@type Action
local Action = getfenv().Action

---@type Signal
local Signal = getfenv().Signal

---@module Utility.TaskSpawner
local TaskSpawner = getfenv().TaskSpawner

---@module Features.Combat.Defense
local Defense = getfenv().Defense

---@module Game.Latency
local Latency = getfenv().Latency

---Combined module for IceDaggers & FleetingSparks
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local thrown = workspace:FindFirstChild("Thrown")
	if not thrown then
		return
	end

	timing.forced = true

	-- Track either IceDagger or FleetingSparks
	local tracker = ProjectileTracker.new(function(candidate)
		return candidate and candidate.Name and (candidate.Name == "IceDagger" or candidate.Name == "LightningMote")
	end)

	task.wait(0.5 - Latency.rtt())

	local hrp = self.entity:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local thread = TaskSpawner.spawn("ProjectileWaiter", function()
		local projectile = tracker:wait()
		if not projectile or not projectile:IsA("BasePart") then
			return
		end

		local name = projectile.Name

		-- === FleetingSparks logic ===
		if name == "LightningMote" then
			TaskSpawner.spawn("FleetingSparks_MoveStack", function()
				local onDescendantAdded = Signal.new(Players.LocalPlayer.Character.DescendantAdded)

				task.wait(0.4 - Latency.rtt())

				if self:distance(self.entity) <= 5 then
					local action = Action.new()
					action._when = 0
					action.ihbc = true
					action._type = "Parry"
					action.name = "Fleeting Sparks Close"
					return self:action(timing, action)
				end

				local isFirstTarget = true
				local listenerConn = onDescendantAdded:connect("FleetingSparks_EffectListener", function(child)
					if child.Name ~= "Targeted" then
						return
					end

					if not child.Parent or not child.Parent:IsA("Attachment") then
						return
					end

					if isFirstTarget then
						isFirstTarget = false
						return
					end

					local action = Action.new()
					action._when = 100
					action.ihbc = true
					action._type = "Parry"
					action.name = "Fleeting Sparks Effect"
					return self:action(timing, action)
				end)

				task.wait(1.2)

				listenerConn:Disconnect()
			end)
		-- === IceDaggers logic ===
		elseif name == "IceDagger" then
			TaskSpawner.spawn("IceDagger_MoveStack", function()
				local onDescendantAdded = Signal.new(Players.LocalPlayer.Character.DescendantAdded)

				local listenerConn = onDescendantAdded:connect("IceDaggers_EffectListener", function(child)
					if child.Name ~= "Targeted" then
						return
					end

					if not child.Parent or not child.Parent:IsA("Attachment") then
						return
					end

					local action = Action.new()
					action._when = 200
					action.ihbc = true
					action._type = "Parry"
					action.name = "Ice Daggers Effect"
					return self:action(timing, action)
				end)

				task.wait(1.2)

				listenerConn:Disconnect()
			end)
		end
	end)

	local onDescendantAdded = Signal.new(self.entity.DescendantAdded)

	self.tmaid:add(onDescendantAdded:connect("IceDaggersClose", function(child)
		if child.Name ~= "REP_SOUND_5033484755" then
			return
		end

		local distance = self:distance(self.entity)
		if distance > 10 then
			return
		end

		-- Cancel thread.
		task.cancel(thread)

		-- Parry close.
		local action = Action.new()
		action.ihbc = true
		action._when = 100
		action._type = "Start Block"
		action.name =
			string.format("(%.2f) (%.2f) Ice Daggers Close Timing", distance, hrp.AssemblyLinearVelocity.Magnitude)
		self:action(timing, action)

		local actionTwo = Action.new()
		actionTwo._when = 1000
		actionTwo.ihbc = true
		actionTwo._type = "End Block"
		actionTwo.name = "Ice Daggers Close End"
		return self:action(timing, actionTwo)
	end))

	self.tmaid:add(thread)
end
