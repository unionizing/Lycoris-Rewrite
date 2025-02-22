---@module Menu.Objects.BuilderSection
local BuilderSection = require("Menu/Objects/BuilderSection")

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Game.Timings.EmitterTiming
local EmitterTiming = require("Game/Timings/EmitterTiming")

---@class EmitterBuilderSection: BuilderSection
local EmitterBuilderSection = setmetatable({}, { __index = BuilderSection })
EmitterBuilderSection.__index = EmitterBuilderSection

---Check before writing.
---@return boolean
function EmitterBuilderSection:check()
	if not BuilderSection.check(self) then
		return false
	end

	if not self.texture.Value or #self.texture.Value <= 0 then
		return Logger.longNotify("Please enter a valid texture ID.")
	end

	if self.pair:index(self.texture.Value) then
		return Logger.longNotify("The timing ID '%s' is already in the list.", self.texture.Value)
	end

	return true
end

---Load the extra elements. Override me.
---@param timing Timing
function EmitterBuilderSection:exload(timing)
	self.texture:SetRawValue(timing.texture)
	self.part:SetRawValue(timing.part)
	self.linkedAnimationIds:SetRawValue({})
	self.linkedAnimationIds:SetValues(timing.linked)
	self.linkedAnimationIds:Display()
end

---Reset the elements. Extend me.
function EmitterBuilderSection:reset()
	BuilderSection.reset(self)
	self.texture:SetRawValue("")
	self.part:SetRawValue("")
	self.linkedAnimationIds:SetRawValue({})
	self.linkedAnimationIds:SetValues({})
	self.linkedAnimationIds:Display()
end

---Create new timing. Override me.
---@return EmitterTiming
function EmitterBuilderSection:create()
	local timing = EmitterTiming.new()
	timing.name = self.timingName.Value
	timing.part = self.part.Value
	timing.texture = self.texture.Value
	return timing
end

---Create timing ID element. Override me.
---@param tab table
function EmitterBuilderSection:tide(tab)
	self.texture = tab:AddInput(nil, {
		Text = "Texture ID",
	})

	self.part = tab:AddInput(nil, {
		Text = "Parent Part Name",
	})
end

---Initialize filter tab.
function EmitterBuilderSection:filter()
	local tab = self.tabbox:AddTab("Filter")

	---@note: De-duplicate me?
	---@see: VisualsTab.addFilterESP and down here...

	self.linkedAnimationIds = tab:AddDropdown(nil, {
		Text = "Linked Animation IDs",
		Values = {},
		Default = nil,
		AllowNull = true,
		Tooltip = "Allow target checks to happen by giving the Projectile Defender data to guess the part's owner.",
		Multi = true,
	})

	self.linkedAnimationId = tab:AddInput(nil, {
		Text = "Animation ID",
	})

	tab:AddButton(
		"Add Animation ID To Linked",
		self:tnc(function(timing)
			local linkedAnimationIdValue = self.linkedAnimationId.Value

			if #linkedAnimationIdValue <= 0 then
				return Logger.longNotify("Please enter a valid Animation ID.")
			end

			local linkedValues = timing.linked

			if not table.find(linkedValues, linkedAnimationIdValue) then
				table.insert(linkedValues, linkedAnimationIdValue)
			end

			self.linkedAnimationIds:SetValues(linkedValues)
			self.linkedAnimationIds:SetValue({})
			self.linkedAnimationIds:Display()
		end)
	)

	tab:AddButton(
		"Remove Selected From Linked",
		self:tnc(function(timing)
			local linkedValues = timing.linked
			local selectedAnimationIds = self.linkedAnimationIds.Value

			for selectedFilterName, _ in next, selectedAnimationIds do
				local selectedIndex = table.find(linkedValues, selectedFilterName)
				if not selectedIndex then
					return Logger.longNotify(
						"The selected Animation ID %s does not exist in the list",
						selectedFilterName
					)
				end

				table.remove(linkedValues, selectedIndex)
			end

			self.partContentFilter:SetValues(selectedAnimationIds)
			self.partContentFilter:SetValue({})
			self.partContentFilter:Display()
		end)
	)
end

---Initialize EmitterBuilderSection object.
function EmitterBuilderSection:init()
	self:timing()
	self:builder()
	self:action()
	self:filter()
end

---Create new EmitterBuilderSection object.
---@param name string
---@param tabbox table
---@param pair TimingContainerPair
---@param timing EmitterTiming
---@return EmitterBuilderSection
function EmitterBuilderSection.new(name, tabbox, pair, timing)
	return setmetatable(BuilderSection.new(name, tabbox, pair, timing), EmitterBuilderSection)
end

-- Return EmitterBuilderSection module.
return EmitterBuilderSection
