-- Tweening module.
local Tweening = { active = false, queue = {} }

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

-- Services.
local players = game:GetService("Players")

---On update step. Queue gets processed from most recent to oldest.
---@param dt number
Tweening.update = LPH_NO_VIRTUALIZE(function(dt)
	Tweening.active = false

	local current = Tweening.current()
	if not current then
		return
	end

	local part = typeof(current.goal) == "Instance" and current.goal or nil
	if part and not part.Parent then
		return Tweening.stop(current.identifier)
	end

	local localPlayer = players.LocalPlayer
	local character = localPlayer and localPlayer.Character
	if not character then
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	Tweening.active = true

	local startPosition = humanoidRootPart.Position
	local targetCFrame = typeof(current.goal) == "Instance" and current.goal.CFrame or current.goal
	local targetPosition = targetCFrame.Position

	local distanceToTarget = (targetPosition - startPosition).Magnitude

	if distanceToTarget <= 0.01 then
		return
	end

	local direction = (targetPosition - startPosition) / distanceToTarget
	local moveDistance = (Configuration.expectOptionValue("TweenStudsPerSecond") or 200) * dt

	local newPosition = nil

	if moveDistance >= distanceToTarget then
		newPosition = targetPosition
	else
		newPosition = startPosition + (direction * moveDistance)
		newPosition = Vector3.new(newPosition.X, targetPosition.Y, newPosition.Z)
	end

	local rotation = (targetCFrame - targetCFrame.Position)

	local _, _, _, m00, m01, m02, m10, m11, m12, m20, m21, m22 = rotation:GetComponents()

	if
		m00 == m00
		and m01 == m01
		and m02 == m02
		and m10 == m10
		and m11 == m11
		and m12 == m12
		and m20 == m20
		and m21 == m21
		and m22 == m22
	then
		humanoidRootPart.CFrame = CFrame.new(newPosition) * rotation
	else
		humanoidRootPart.CFrame = CFrame.new(newPosition)
	end

	-- Check distance from NEW position to target.
	local newDistanceToTarget = (targetPosition - newPosition).Magnitude

	current.reached = false

	if newDistanceToTarget >= 1.0 then
		return
	end

	if current.swc then
		return Tweening.stop(current.identifier)
	end

	current.reached = true
end)

---Get the tween data of an identifier.
---@param identifier string
---@return number, table?
function Tweening.get(identifier)
	for idx, data in next, Tweening.queue do
		if data.identifier ~= identifier then
			continue
		end

		return idx, data
	end

	return nil
end

---Wait until we reach the goal.
---@param identifier string
function Tweening.wait(identifier)
	local _, data = Tweening.get(identifier)
	if not data then
		return
	end

	repeat
		task.wait()
	until data.reached
end

---Current target.
---@return table?
function Tweening.current()
	return Tweening.queue[#Tweening.queue]
end

---Set a goal to follow. The most recent goal will be processed first.
---@param identifier string
---@param goal BasePart|CFrame
---@param swc boolean Whether or not to stop when we reach the goal.
function Tweening.goal(identifier, goal, swc)
	local _, data = Tweening.get(identifier)

	if data then
		data.goal = goal
		data.swc = swc
		data.reached = false
	else
		table.insert(Tweening.queue, 1, { identifier = identifier, goal = goal, swc = swc, reached = false })
	end
end

---Stop tweening.
---@param identifier string
function Tweening.stop(identifier)
	local idx, _ = Tweening.get(identifier)
	if not idx then
		return
	end

	table.remove(Tweening.queue, idx)
end

-- Return Tweening module.
return Tweening
