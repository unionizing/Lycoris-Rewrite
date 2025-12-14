---@module Menu.Objects.BuilderSection
local BuilderSection = require("Menu/Objects/BuilderSection")

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Game.Timings.SoundTiming
local SoundTiming = require("Game/Timings/SoundTiming")

---@class SoundBuilderSection: BuilderSection
---@field soundId table
---@field repeatStartDelay table
---@field repeatUntilParryEnd table
---@field repeatParryDelay table
---@field timing SoundTiming
---@field allowLocalPlayer table
local SoundBuilderSection = setmetatable({}, { __index = BuilderSection })
SoundBuilderSection.__index = SoundBuilderSection

---Create timing ID element. Override me.
---@param tab table
function SoundBuilderSection:tide(tab)
	self.soundId = tab:AddInput(nil, {
		Text = "Sound ID",
	})
end

---Load the extra elements. Override me.
---@param timing Timing
function SoundBuilderSection:exload(timing)
	self.soundId:SetRawValue(timing._id)
	self.allowLocalPlayer:SetRawValue(timing.alp)
end

---Reset the elements. Extend me.
function SoundBuilderSection:reset()
	BuilderSection.reset(self)
	self.soundId:SetRawValue("")
	self.allowLocalPlayer:SetRawValue(false)
end

---Check before creating new timing. Override me.
---@return boolean
function SoundBuilderSection:check()
	if not BuilderSection.check(self) then
		return false
	end

	if not self.soundId.Value or #self.soundId.Value <= 0 then
		return Logger.longNotify("Please enter a valid sound ID.")
	end

	if self.pair:index(self.soundId.Value) then
		return Logger.longNotify("The timing ID '%s' is already in the list.", self.soundId.Value)
	end

	return true
end

---Set creation timing properties. Override me.
---@param timing SoundTiming
function SoundBuilderSection:cset(timing)
	timing.name = self.timingName.Value
	timing._id = self.soundId.Value
end

---Create new timing. Override me.
---@return Timing
function SoundBuilderSection:create()
	local timing = SoundTiming.new()
	self:cset(timing)
	return timing
end

---Initialize extra tab.
---@param tab table
function SoundBuilderSection:extra(tab)
	self.allowLocalPlayer = tab:AddToggle(nil, {
		Text = "Allow Local Player",
		Default = false,
		Callback = self:tnc(function(timing, value)
			timing.alp = value
		end),
	})
end

---Create new SoundBuilderSection object.
---@param name string
---@param tabbox table
---@param pair TimingContainerPair
---@param timing SoundTiming
---@return SoundBuilderSection
function SoundBuilderSection.new(name, tabbox, pair, timing)
	return setmetatable(BuilderSection.new(name, tabbox, pair, timing), SoundBuilderSection)
end

-- Return SoundBuilderSection module.
return SoundBuilderSection
