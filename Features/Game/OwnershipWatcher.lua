-- Ownership watcher module.
local OwnershipWatcher = { modelsToScan = {}, parts = {} }

-- Services
local playersService = game:GetService("Players")
local runService = game:GetService("RunService")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

---@module Utility.Signal
local Signal = require("Utility/Signal")

---@module Utility.InstanceWrapper
local InstanceWrapper = require("Utility/InstanceWrapper")

-- Signals.
local renderStepped = Signal.new(runService.RenderStepped)

-- Maids.
local ownershipMaid = Maid.new()
local voidMaid = Maid.new()

-- Void Mobs
local YForce = workspace.StreamingEnabled and Vector3.new(0, -8000, 0) or Vector3.new(0, -100, 0)

-- Ownership data.
local clientPart = Instance.new('Part', workspace)
local clientPeerId = gethiddenproperty(clientPart, "NetworkOwnerV3")
clientPart:Destroy()

---Check for network ownership. Fallback to legacy check if NetworkOwnerV3 is not available.
---@param part BasePart
---@return boolean
local function hasNetworkOwnership(part)
    local success, partPeerId = pcall(function()
        return gethiddenproperty(part, "NetworkOwnerV3")
    end)

    if not success then
        return not part.Anchored and part.ReceiveAge == 0 and part.AssemblyLinearVelocity.Magnitude > 0
    end

    return partPeerId == clientPeerId
end

---Clean up parts. Every model to scan has a maid linked to it.
local function cleanParts()
    for _, maid in next, OwnershipWatcher.modelsToScan do
        maid:clean()
    end
end

---Add live characters to ownership watcher.
---@param character Model
local function onLiveAdded(character)
    if not character:IsA('Model') then
        return
    end

    if OwnershipWatcher.modelsToScan[character] then
        return
    end

    OwnershipWatcher.modelsToScan[character] = Maid.new()
end

---Remove live characters from ownership watcher.
---@param character Model
local function onLiveRemoved(character)
    if not OwnershipWatcher.modelsToScan[character] then
        return
    end

    OwnershipWatcher.modelsToScan[character]:clean()
    OwnershipWatcher.modelsToScan[character] = nil
end

local function updateOwnership()
    local ShowOwnership = Configuration.expectToggleValue("ShowOwnership")
    for _,v in next, ownershipHolder do
        local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            continue
        end

        local NetVisual = HumanoidRootPart:FindFirstChild("NetworkVisual")
        
        if not NetVisual and ShowOwnership then
            NetVisual = NetworkVisual:Clone()
            NetVisual.Weld.Part0 = HumanoidRootPart
            NetVisual.Parent = HumanoidRootPart
        end

        if not ShowOwnership and NetVisual then
            NetVisual:Destroy()
            continue
        end
        
        local isNetworkOwner = hasNetworkOwnership(HumanoidRootPart)
        if not isNetworkOwner then
            if NetVisual then
                NetVisual.Color = Color3.fromRGB(0, 0, 255)
            end
            v:RemoveTag('NetworkOwner')
            continue
        end

        if NetVisual then
            NetVisual.Color = Color3.fromRGB(0, 255, 0)
        end
        v:AddTag('NetworkOwner')
    end
end

---Get table of watched parts along with a mapping to extra data.
---@return table<BasePart, table>
function OwnershipWatcher.get()
    return OwnershipWatcher.parts
end

---Iniitalize OwnershipWatcher module.
function OwnershipWatcher.init()
	local live = workspace:WaitForChild("Live")
	local liveChildAdded = Signal.new(live.ChildAdded)
	local liveChildRemoved = Signal.new(live.ChildRemoved)

    ownershipMaid:add(liveChildAdded:connect("OwnershipWatcher_OnLiveChildAdded", onLiveAdded))
    ownershipMaid:add(liveChildRemoved:connect("OwnershipWatcher_OnLiveChildRemoved", onLiveRemoved))
    ownershipMaid:add(renderStepped:connect("OwnershipWatcher_RenderStepped", updateOwnership))

    for _, entity in next, live:GetChildren() do
        onLiveAdded(entity)
    end
end

---Detach OwnershipWatcher module.
function OwnershipWatcher.detach()
    -- Clean up ownership maids.
    ownershipMaid:clean()

    -- Clean up parts.
    cleanParts()
end

-- Return OwnershipWatcher module.
return OwnershipWatcher