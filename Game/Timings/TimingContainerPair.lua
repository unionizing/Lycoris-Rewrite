---@class TimingContainerPair
---@note The configs are always prioritized over the internal timings.
---@field internal TimingContainer
---@field config TimingContainer
local TimingContainerPair = {}
TimingContainerPair.__index = TimingContainerPair

---Create new TimingContainerPair object.
---@param internal TimingContainer
---@param config TimingContainer
---@return TimingContainerPair
function TimingContainerPair.new(internal, config)
	local self = setmetatable({}, TimingContainerPair)
	self.internal = internal
	self.config = config
	return self
end

---Index timing container.
---@param key any?
---@return Timing?
function TimingContainerPair:index(key)
	return self.config.timings[key] or self.internal.timings[key]
end

---Find timing from name.
---@param name string
---@return Timing?
function TimingContainerPair:find(name)
	return self.config:find(name) or self.internal:find(name)
end

-- Return TimingContainerStack module.
return TimingContainerPair
