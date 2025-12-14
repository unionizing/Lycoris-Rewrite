---@module Menu.Objects.BuilderSection
local BuilderSection = require("Menu/Objects/BuilderSection")

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Game.Timings.EffectTiming
local EffectTiming = require("Game/Timings/EffectTiming")

---@class EffectBuilderSection: BuilderSection
---@field effectName table
---@field repeatStartDelay table
---@field repeatUntilParryEnd table
---@field repeatParryDelay table
---@field timing EffectTiming
local EffectBuilderSection = setmetatable({}, { __index = BuilderSection })
EffectBuilderSection.__index = EffectBuilderSection

---Create timing ID element. Override me.
---@param tab table
function EffectBuilderSection:tide(tab)
	self.effectName = tab:AddInput(nil, {
		Text = "Effect Name",
	})
end

---Load the extra elements. Override me.
---@param timing Timing
function EffectBuilderSection:exload(timing)
	self.effectName:SetRawValue(timing.ename)
	self.ignoreLocalPlayer:SetRawValue(timing.ilp)
	self.forceLocalPlayer:SetRawValue(timing.flp)
end

---Reset the elements. Extend me.
function EffectBuilderSection:reset()
	BuilderSection.reset(self)
	self.effectName:SetRawValue("")
	self.hitboxFacingOffset:SetRawValue(true)
	self.ignoreLocalPlayer:SetRawValue(false)
	self.forceLocalPlayer:SetRawValue(false)
end

---Check before creating new timing. Override me.
---@return boolean
function EffectBuilderSection:check()
	if not BuilderSection.check(self) then
		return false
	end

	if not self.effectName.Value or #self.effectName.Value <= 0 then
		return Logger.longNotify("Please enter a valid effect name.")
	end

	if self.pair:index(self.effectName.Value) then
		return Logger.longNotify("The timing ID '%s' is already in the list.", self.effectName.Value)
	end

	return true
end

---Set creation timing properties. Override me.
---@param timing EffectTiming
function EffectBuilderSection:cset(timing)
	timing.name = self.timingName.Value
	timing.ename = self.effectName.Value
end

---Create new timing. Override me.
---@return Timing
function EffectBuilderSection:create()
	local timing = EffectTiming.new()
	self:cset(timing)
	return timing
end

---Initialize extra tab.
---@param tab table
function EffectBuilderSection:extra(tab)
	self.ignoreLocalPlayer = tab:AddToggle(nil, {
		Text = "Ignore Local Player",
		Default = true,
		Tooltip = "If enabled, the effect will not react when it is applied to the local player.",
		Callback = self:tnc(function(timing, value)
			timing.ilp = value
		end),
	})

	self.forceLocalPlayer = tab:AddToggle(nil, {
		Text = "Force Local Player",
		Default = false,
		Tooltip = "If enabled, the effect will always react when it is applied to the local player, even if ignored.",
		Callback = self:tnc(function(timing, value)
			timing.flp = value
		end),
	})
end

---Create new EffectBuilderSection object.
---@param name string
---@param tabbox table
---@param pair TimingContainerPair
---@param timing EffectTiming
---@return EffectBuilderSection
function EffectBuilderSection.new(name, tabbox, pair, timing)
	return setmetatable(BuilderSection.new(name, tabbox, pair, timing), EffectBuilderSection)
end

-- Return EffectBuilderSection module.
return EffectBuilderSection
