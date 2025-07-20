---@note: The goal of this module is to be able to not have duplicates of handling of a projectile.
--- Normal child added signals will not work with multiple-same modules running because they will all create their own listener.
--- This module will prioritize only the last created listener, which will be the one that is used to handle the projectile. The last one will be discarded.

---@class Maid
local Maid = getfenv().Maid

---@class Signal
local Signal = getfenv().Signal

---@class Logger
local Logger = getfenv().Logger

---@class ProjectileListener
---@field maid Maid
---@field identifier string
local ProjectileListener = {}
ProjectileListener.__index = ProjectileListener

-- Object list.
local trackerObjects = {}

---Detach function.
function ProjectileListener.detach()
	for _, trackerObject in next, trackerObjects do
		if not trackerObject.maid then
			continue
		end

		trackerObject.maid:clean()
	end
end

---Create connection.
function ProjectileListener:connect(callback)
	local thrown = workspace:WaitForChild("Thrown")
	local childAdded = Signal.new(thrown.ChildAdded)

	self.maid:clean()

	self.maid:mark(
		childAdded:connect(string.format("%s_ProjectileListener_ThrownChildAdded", self.identifier), callback)
	)
end

---Create a new ProjectileListener object.
---@param identifier string
---@return ProjectileListener
function ProjectileListener.new(identifier)
	local self = setmetatable({}, ProjectileListener)
	self.maid = Maid.new()
	self.identifier = identifier
	trackerObjects[#trackerObjects + 1] = self
	return self
end

-- Return ProjectileListener module.
return ProjectileListener
