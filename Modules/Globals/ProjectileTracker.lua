---@type Signal
local Signal = getfenv().Signal

---@type Maid
local Maid = getfenv().Maid

---@note: The goal of this module is to track projectiles --
--- To be able to distribute each projectile to a specific, unique tracker which will handle it.
--- It is not this case where: for each tracker, assuming that they were created in order of the projectiles being thrown,
--- we can assume that the first projectiles that we find are the ones linked to a user. It is somewhat true but not something to rely on.

---@class ProjectileTracker
---@field projectile Instance
local ProjectileTracker = {}
ProjectileTracker.__index = ProjectileTracker

-- Global list of projectiles that we need to skip.
local seenProjectiles = {}

-- Object list.
local trackerObjects = {}

-- Projectile tracker maid.
local ptMaid = Maid.new()

-- Initialize global signals.
local thrown = workspace:WaitForChild("Thrown")
local childAdded = Signal.new(thrown.ChildAdded)

---@note: Forced fully ordered from first to last projectile tracker.
ptMaid:mark(childAdded:connect("ProjectileTracker_ThrownChildAdded", function(child)
	for _, tracker in next, trackerObjects do
		if tracker.projectile then
			continue
		end

		if not tracker.callback(child) then
			continue
		end

		if seenProjectiles[child] then
			continue
		end

		tracker.projectile = child

		seenProjectiles[child] = true
	end
end))

---Wait for the first projectile that was found.
---@return Instance
function ProjectileTracker:wait()
	repeat
		task.wait()
	until self.projectile

	return self.projectile
end

---Detach function. Module function. It is not related to the object itself.
function ProjectileTracker.detach()
	ptMaid:clean()
end

---Create new ProjectileTracker object.
---@param callback fun(candidate: Instance): boolean
---@return ProjectileTracker
function ProjectileTracker.new(callback)
	local self = setmetatable({}, ProjectileTracker)
	self.projectile = nil
	self.callback = callback
	trackerObjects[#trackerObjects + 1] = self
	return self
end

-- Return ProjectileTracker module.
return ProjectileTracker
