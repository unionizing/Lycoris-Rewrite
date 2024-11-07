-- VoidMobs related stuff is handled here.
local VoidMobs = {}

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.Signal
local Signal = require("Utility/Signal")

-- Services.
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local lighting = game:GetService("Lighting")
local PhysicsService = cloneref(game:GetService("PhysicsService"))

-- Variables.
local VoidMobsHeight = workspace.FallenPartsDestroyHeight + 100

-- Instances.
local voidMobsBodyVelocity = {}
local networkDatabase = {}

local NetChecker = Instance.new("BodyVelocity")
NetChecker.MaxForce = Vector3.new(9e9, 9e9, 9e9)
NetChecker.P = 10000
NetChecker.Velocity = Vector3.new(0, -10, 0)
NetChecker:SetAttribute("Allowed", true)
NetChecker:AddTag("AllowedBM")

-- Maids.
local voidMobsMaid = Maid.new()

-- Signals.
local renderStepped = Signal.new(runService.RenderStepped)

---Grab Character Parts.
---@param character Model
local function getCharacterParts(character)
	local parts = {}
	for _, v in character:GetDescendants() do
		if v:isA("BasePart") then
			table.insert(parts, v)
		end
	end
	return parts
end

--Required PCall because sometime it likes to error if its ran twice
pcall(function()
	PhysicsService:RegisterCollisionGroup("Nothing")
	PhysicsService:CollisionGroupSetCollidable("VoidMobs", "Default", false)
	PhysicsService:CollisionGroupSetCollidable("VoidMobs", "VoidMobs", false)
	PhysicsService:CollisionGroupSetCollidable("VoidMobs", "Player", false)
	PhysicsService:CollisionGroupSetCollidable("VoidMobs", "WalkThrough", false)
end)

--@return string
local function generateString()
	return tostring(math.random(1, 9e9))
end

--@param BasePart BasePart
--@param Custom boolean
--@return boolean
local function isnetworkowner(BasePart, Custom)
	if typeof(BasePart) ~= "Instance" then
		return warn("invalid argument #1 Instance expected, got " .. typeof(BasePart))
	end
	if not BasePart:IsA("BasePart") then
		return warn("BasePart expected, got " .. BasePart.ClassName)
	end

	local ReceiveAge = BasePart.ReceiveAge
	local Anchored = BasePart.Anchored
	local Velocity = BasePart.Velocity
	local AngularVelocity = BasePart.AssemblyAngularVelocity

	if Custom and not networkDatabase[BasePart] then
		networkDatabase[BasePart] = true

		local Retain = NetChecker:Clone()
		Retain.Parent = BasePart
		game:GetService("Debris"):AddItem(Retain, 0.001)

		task.delay(0.5, function()
			networkDatabase[BasePart] = nil
		end)
	end

	return Custom and (ReceiveAge == 0 and not Anchored and Velocity.Magnitude > 0 and AngularVelocity.Magnitude > 0)
		or (ReceiveAge == 0 and not Anchored and Velocity.Magnitude > 0)
end

-- This is made more optimized as it only search for the baseparts now instead of the whole character descendant which may be over 100+ instances
---Update Void Mobs.
---@param localPlayer Player
local function toggleVoidMobs(localPlayer)
	local velstring = generateString()
	local mobs = {}

	local function addMob(mob)
		if mob == localPlayer.Character then
			return
		end

		mob:WaitForChild("HumanoidRootPart", 9e9)
		mobs[#mobs + 1] = getCharacterParts(mob)
	end

	for _, v in pairs(workspace.Live:GetChildren()) do
		task.spawn(addMob, v)
	end

	voidMobsMaid:add(workspace.Live.ChildAdded:Connect(addMob))

	--@param part BasePart
	local function retainPart(part)
		if not part:FindFirstChild(velstring) then
			local retainVelocity = Instance.new("BodyVelocity")
			retainVelocity.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)
			retainVelocity.Velocity = Vector3.new(0, workspace.StreamingEnabled and -8000 or -100, 0)
			retainVelocity.D = 0
			retainVelocity.P = 1 / 0
			retainVelocity.Parent = part
		end

		if isnetworkowner(part, true) then
			local controlVel = part:FindFirstChild("ControlVel")
			local safetyBV = part:FindFirstChild("SafetyBV")

			if controlVel then
				controlVel:Destroy()
			end

			if safetyBV then
				safetyBV:Destroy()
			end

			part.CanCollide = false
			part.CollisionGroup = "Nothing"

			local partCFrame = part.CFrame
			part.Velocity = Vector3.new(0, -12000, 0)
			part.CFrame = CFrame.new(partCFrame.X, VoidMobsHeight, partCFrame.Z)

			sethiddenproperty(part, "NetworkIsSleeping", false)
		end
	end

	local function scanMobs()
		for _, v in pairs(mobs) do
			for _, part in pairs(v) do
				if not v.Parent then
					continue
				end
				task.spawn(retainPart, part)
			end
		end
	end

	voidMobsMaid:add(renderStepped:connect("VoidMobs_RenderStepped", scanMobs))
end

---Reset Void Mobs.
local function resetVoidMobs()
	for _, instance in pairs(voidMobsBodyVelocity) do
		if instance and instance.Parent then
			instance:Destory()
		end
	end

	voidMobsBodyVelocity = {}
end
---Update voidMobs.
local function updateVoidMobs()
	local localPlayer = players.LocalPlayer
	if not localPlayer then
		return
	end

	if Toggles.Value.VoidMobs then
		toggleVoidMobs()
	else
		resetVoidMobs()
	end
end

---Initalize voidMobs.
function VoidMobs.init()
	voidMobsMaid:add(renderStepped:connect("VoidMobs_RenderStepped", updateVoidMobs))
end

---Detach voidMobs.
function VoidMobs.detach()
	voidMobsMaid:clean()
	resetVoidMobs()
end

-- Return VoidMobs module.
return VoidMobs
