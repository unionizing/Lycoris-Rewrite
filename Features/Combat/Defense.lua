---@module Utility.Signal
local Signal = require("Utility/Signal")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Features.Combat.Object.AnimationProtector
local AnimationProtector = require("Features/Combat/Object/AnimationProtector")

-- Handle all defense related functions.
local Defense = { blockTimestamp = nil }

-- Maids.
local defenseMaid = Maid.new()

-- Animation protector objects.
local animationProtectorObjects = {}

-- On live descendant added.
local function onLiveDescendantAdded(child)
	if not child:IsA("Animator") then
		return
	end

	animationProtectorObjects[child] = AnimationProtector.new(Defense, child)
end

-- On live descendant removed.
local function onLiveDescendantRemoved(child)
	local animationProtectorObject = animationProtectorObjects[child]
	if not animationProtectorObject then
		return
	end

	animationProtectorObject:detach()
	animationProtectorObjects[child] = nil
end

---Initialize defense.
function Defense.init()
	local live = workspace:WaitForChild("Live")
	local liveDescendantAdded = Signal.new(live.ChildAdded)
	local liveDescendantRemoved = Signal.new(live.ChildRemoved)

	defenseMaid:add(liveDescendantAdded:connect("Defense_LiveDescendantAdded", onLiveDescendantAdded))
	defenseMaid:add(liveDescendantRemoved:connect("Defense_LiveDescendantRemoved", onLiveDescendantRemoved))

	for _, child in next, live:GetDescendants() do
		onLiveDescendantAdded(child)
	end
end

---Detach defense.
function Defense.detach()
	for _, animationProtectorObject in next, animationProtectorObjects do
		animationProtectorObject:detach()
	end

	defenseMaid:clean()
end

-- Return Defense module.
return Defense
