---@class PlaybackData
---@field asdh table<number, number> Animation speed difference history.
---@field recorded boolean to track whether or not we have fully finished recording. Simply is set when the animation has atleast stopped once.
---@field entity Model Entity to playback.
local PlaybackData = {}
PlaybackData.__index = PlaybackData

---Track animation stop.
function PlaybackData:astop()
	self.recorded = true
end

---Track animation speed.
---@param position number
---@param speed number
function PlaybackData:astrack(position, speed)
	if table.find(self.asdh, speed) then
		return
	end

	self.asdh[position] = speed
end

---Create new PlaybackData object.
---@param entity Model
---@return PlaybackData
function PlaybackData.new(entity)
	local self = setmetatable({}, PlaybackData)
	self.asdh = {}
	self.recorded = false
	self.entity = entity:Clone()
	return self
end

-- Return PlaybackData module.
return PlaybackData
