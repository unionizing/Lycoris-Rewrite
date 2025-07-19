---@note: The goal of this module is to be able to not have duplicates of handling of a projectile.
--- Normal child added signals will not work with multiple-same modules running because they will all create their own listener.
--- This module will prioritize only the last created listener, which will be the one that is used to handle the projectile. The last one will be discarded.

---@class Maid
local Maid = getfenv().Maid

---@class Signal
local Signal = getfenv().Signal

---@class ProjectileListener
local ProjectileListener = {}
ProjectileListener.__index = ProjectileListener

-- Listener maid.
local listenerMaid = Maid.new()

-- Global list of objects.
local listenerObjects = {}

-- Initialize global signals.
local thrown = workspace:WaitForChild("Thrown")
local childAdded = Signal.new(thrown.ChildAdded)

listenerMaid:mark(childAdded:connect("ProjectileTracker_ThrownChildAdded", function(child)
	for _, listener in next, listenerObjects do
		if not listener.callback then
			continue
		end

		listener.callback(child)
	end
end))

---Detach function. Module function. It is not related to the object itself.
function ProjectileListener.detach()
	listenerMaid:clean()
end

---Set a new handler for the projectile listener.
---@param callback fun(child: Instance): boolean
function ProjectileListener:handler(callback)
	self.callback = callback
end

---Create a new ProjectileListener object.
---@return ProjectileListener
function ProjectileListener.new()
	local self = setmetatable({}, ProjectileListener)
	self.callback = nil
	listenerObjects[#listenerObjects + 1] = self
	return self
end

-- Return ProjectileListener module.
return ProjectileListener
