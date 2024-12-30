---@module Game.Timings.SaveManager
local SaveManager = require("Game/Timings/SaveManager")

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Game.Timings.AnimationTiming
local AnimationTiming = require("Game/Timings/AnimationTiming")

---@module Game.Timings.EffectTiming
local EffectTiming = require("Game/Timings/EffectTiming")

---@module Game.Timings.PartTiming
local PartTiming = require("Game/Timings/PartTiming")

---@module Game.Timings.SoundTiming
local SoundTiming = require("Game/Timings/SoundTiming")

---@module Game.Timings.ActionContainer
local ActionContainer = require("Game/Timings/ActionContainer")

---@module Game.Timings.Action
local Action = require("Game/Timings/Action")

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

-- BuilderTab module.
---@note: This is the worst piece of menu code that ever has existed. Please beautify me and make me readable later.
local BuilderTab = {}

---Initialize save manager section.
---@param groupbox table
function BuilderTab.initSaveManagerSection(groupbox)
	local configName = groupbox:AddInput("ConfigName", {
		Name = "Config Name",
		Tooltip = "Name of a new configuration file.",
	})

	local configList = groupbox:AddDropdown("ConfigList", {
		Name = "Config List",
		Values = SaveManager.list(),
		AllowNull = true,
	})

	groupbox
		:AddButton("Create Config", function()
			SaveManager.create(configName.Value)
			SaveManager.refresh(configList)
		end)
		:AddButton("Load Config", {
			DoubleClick = true,
			Func = function()
				SaveManager.load(configList.Value)
			end,
		})

	groupbox:AddButton("Overwrite Config", {
		DoubleClick = true,
		Func = function()
			SaveManager.save(configList.Value)
		end,
	})

	groupbox:AddButton("Delete Config", {
		DoubleClick = true,
		Func = function()
			SaveManager.delete(configList.Value)
			SaveManager.refresh(configList)
		end,
	})

	groupbox:AddButton("Refresh List", function()
		SaveManager.refresh(configList)
	end)

	groupbox:AddButton("Set To Auto Load", function()
		SaveManager.autoload(configList.Value)
	end)
end

---Initialize merge manager section.
---@param groupbox table
function BuilderTab.initMergeManagerSection(groupbox)
	local configList = groupbox:AddDropdown("ConfigList", {
		Name = "Config List",
		Values = SaveManager.list(),
		AllowNull = true,
	})

	local mergeConfigType = groupbox:AddDropdown("MergeConfigType", {
		Name = "Merge Type",
		Values = { "Add New Timings", "Overwrite and Add Everything" },
		Default = 1,
	})

	groupbox:AddButton("Merge With Current Config", {
		DoubleClick = true,
		Func = function()
			SaveManager.merge(configList.Value, mergeConfigType.Value)
		end,
	})
end

---Initialize logger section.
---@param groupbox table
function BuilderTab.initLoggerSection(groupbox)
	groupbox:AddToggle("Show Logger Window", {
		Text = "Show Logger Window",
		Default = false,
	})
end

---Refresh timing list.
---@param identifier string
---@param groupbox table
---@param pair TimingContainerPair
function BuilderTab.refreshTimingList(identifier, groupbox, pair)
	local timingList = Configuration.optionValue(Configuration.identify(identifier, "TimingList"))
	timingList:SetValues(pair:names())
end

---Write timing to base builder section.
---@param identifier string
---@param timing Timing
function BuilderTab.writeTimingToBase(identifier, timing)
	local timingName = Options[(Configuration.identify(identifier, "TimingName"))]
	timingName:SetValue(timing.name)

	local timingTag = Options[Configuration.identify(identifier, "TimingTag")]
	timingTag:SetValue(timing.tag)

	local hitboxLength = Options[(Configuration.identify(identifier, "HitboxLength"))]
	hitboxLength:SetValue(timing.hitbox.X)

	local hitboxHeight = Options[(Configuration.identify(identifier, "HitboxHeight"))]
	hitboxHeight:SetValue(timing.hitbox.Y)

	local hitboxWidth = Options[(Configuration.identify(identifier, "HitboxWidth"))]
	hitboxWidth:SetValue(timing.hitbox.Z)

	local duih = Options[(Configuration.identify(identifier, "DelayUntilInHitbox"))]
	duih:SetValue(timing.duih)

	local actionList = Options[Configuration.identify(identifier, "ActionList")]
	actionList:SetValues(timing.actions:names())
	actionList:SetValue({})
	actionList:Display()

	local actionName = Options[Configuration.identify(identifier, "ActionName")]
	actionName:SetValue("")

	local actionDelay = Options[Configuration.identify(identifier, "ActionDelay")]
	actionDelay:SetValue(0)

	local actionType = Options[Configuration.identify(identifier, "ActionType")]
	actionType:SetValue("Parry")
end

---Base builder timing add.
---@param identifier string
---@param timing Timing
---@param container ActionContainer
---@param groupbox table
---@param pair TimingContainerPair
function BuilderTab.baseBuilderTimingAdd(identifier, timing, container, groupbox, pair)
	local config = pair:config()

	if config:find(timing.name) then
		return Logger.longNotify("The timing name '%s' already exists in the list.", timing.name)
	end

	local conflicting = config.timings[timing:id()]

	if conflicting then
		return Logger.longNotify("The timing name '%s' is conflicting with the current one.", conflicting.name)
	end

	timing.name = Configuration.idOptionValue(Configuration.identify(identifier, "TimingName"))
	timing.tag = Configuration.idOptionValue(Configuration.identify(identifier, "TimingTag"))
	timing.hitbox = Vector3.new(
		Configuration.idOptionValue(Configuration.identify(identifier, "HitboxLength")),
		Configuration.idOptionValue(Configuration.identify(identifier, "HitboxHeight")),
		Configuration.idOptionValue(Configuration.identify(identifier, "HitboxWidth"))
	)
	timing.duih = Configuration.idOptionValue(Configuration.identify(identifier, "DelayUntilInHitbox"))
	timing.actions = container:clone()

	config:push(timing)

	BuilderTab.refreshTimingList(identifier, groupbox, pair)
end

---Base builder timing remove.
---@param identifier string
---@param timing Timing
---@param groupbox table
---@param pair TimingContainerPair
function BuilderTab.baseBuilderTimingRemove(identifier, timing, groupbox, pair)
	local list = Options[Configuration.identify(identifier, "TimingList")]
	local name = list.Value

	if not name then
		return Logger.longNotify("Please select a timing to remove.")
	end

	local default = pair:default()
	local config = pair:config()

	if default:find(name) then
		return Logger.longNotify("You cannot remove default timings.")
	end

	local found = config:find(name)
	if not found then
		return Logger.longNotify("The selected timing '%s' does not exist in the list.", name)
	end

	config:remove(found)

	BuilderTab.refreshTimingList(identifier, groupbox, pair)
end

---Initialize builder section.
---@param identifier string
---@param groupbox table
---@param pair TimingContainerPair
---@return string, table, TimingContainerPair
function BuilderTab.initBuilderSection(identifier, groupbox, pair)
	groupbox:AddDropdown(Configuration.identify(identifier, "TimingList"), {
		Name = "Timing List",
		Values = pair:names(),
		AllowNull = true,
	})

	groupbox:AddDropdown(Configuration.identify(identifier, "TimingTag"), {
		Name = "Timing Tag",
		Values = { "Undefined", "Critical", "Mantra", "M1" },
		Default = 1,
	})

	groupbox:AddSlider(Configuration.identify(identifier, "HitboxLength"), {
		Name = "Hitbox Length",
		Min = 0,
		Max = 300,
		Suffix = "s",
		Default = 0,
	})

	groupbox:AddSlider(Configuration.identify(identifier, "HitboxWidth"), {
		Name = "Hitbox Width",
		Min = 0,
		Max = 300,
		Suffix = "s",
		Default = 0,
	})

	groupbox:AddSlider(Configuration.identify(identifier, "HitboxHeight"), {
		Name = "Hitbox Height",
		Min = 0,
		Max = 300,
		Suffix = "s",
		Default = 0,
	})

	groupbox:AddToggle(Configuration.identify(identifier, "DelayUntilInHitbox"), {
		Name = "Delay Until In Hitbox",
		Default = false,
	})

	return identifier, groupbox, pair
end

---Add action builder.
---@param identifier string
---@param base table
---@param container ActionContainer
function BuilderTab.addActionBuilder(identifier, base, container)
	local actionName = nil
	local actionDelay = nil
	local actionType = nil

	local actionList = base:AddDropdown(Configuration.identify(identifier, "ActionList"), {
		Name = string.format("%s Actions"),
		Values = container:names(),
		AllowNull = true,
		Callback = function(value)
			local action = container:find(value)
			if not action then
				return Logger.longNotify("The selected action '%s' does not exist in the list.", value)
			end

			actionName:SetValues(action.name)
			actionDelay:SetValues(action.when)
			actionType:SetValues(action._type)
		end,
	})

	actionName = base:AddInput(Configuration.identify(identifier, "ActionName"), {
		Text = string.format("%s Action Name"),
	})

	actionDelay = base:AddInput(Configuration.identify(identifier, "ActionDelay"), {
		Text = string.format("%s Action Delay"),
		Numeric = true,
	})

	actionType = base:AddDropdown(Configuration.identify(identifier, "ActionType"), {
		Name = string.format("%s Action Type"),
		Values = { "Parry", "Dodge", "Start Block", "End Block" },
		Default = 1,
	})

	base:AddButton("Add Action To List", function()
		local action = Action.new()
		action._type = actionType.Value
		action.name = actionName.Value
		action.when = actionDelay.Value

		container:push(action)

		actionList:SetValues(container:names())
		actionList:SetValue({})
		actionList:Display()
	end)

	base:AddButton("Remove Action From List", function()
		local selectedActionName = actionList.Value
		if not selectedActionName then
			return Logger.longNotify("Please select an action to remove.")
		end

		local action = container:find(selectedActionName)
		if not action then
			return Logger.longNotify("The selected action '%s' does not exist in the list.", selectedActionName)
		end

		container:remove(action)

		actionList:SetValues(container:names())
		actionList:SetValue({})
		actionList:Display()
	end)
end

---Initialize animation section.
---@param identifier string
---@param groupbox table
---@param pair TimingContainerPair
function BuilderTab.initAnimationSection(identifier, groupbox, pair)
	local container = ActionContainer.new()
	local timing = AnimationTiming.new()

	local animationIdInput = groupbox:AddInput(Configuration.identify(identifier, "AnimationId"), {
		Text = "Animation ID",
	})

	local rpueToggle = groupbox:AddToggle(Configuration.identify(identifier, "RepeatParryUntilEnd"), {
		Text = "Repeat Parry Until Animation End",
		Default = false,
	})

	local rpueDepBoxOn = rpueToggle:AddDependencyBox()
	local rpueDepBoxOff = rpueToggle:AddDependencyBox()

	local rpdInput = rpueDepBoxOn:AddInput(Configuration.identify(identifier, "RepeatParryDelay"), {
		Text = "Repeat Parry Delay",
		Numeric = true,
	})

	BuilderTab.addActionBuilder(identifier, rpueDepBoxOff, container)

	rpueDepBoxOn:SetupDependencies({
		{ rpueToggle, true },
	})

	rpueDepBoxOff:SetupDependencies({
		{ rpueToggle, false },
	})

	groupbox:AddButton("Add Timing To List", function()
		timing.id = animationIdInput.Value
		timing.rpue = rpueToggle.Value
		timing.rpd = rpdInput.Value

		BuilderTab.baseBuilderTimingAdd(identifier, timing, container, groupbox, pair)
	end)

	groupbox:AddButton("Remove Timing From List", function()
		BuilderTab.baseBuilderTimingRemove(identifier, timing, groupbox, pair)
	end)

	local timingList = Options[Configuration.identify(identifier, "TimingList")]

	timingList.Callback = function()
		local name = timingList.Value
		if not name then
			return
		end

		local found = pair:config():find(name)
		if not found then
			return Logger.longNotify("The selected timing '%s' does not exist in the list.", name)
		end

		BuilderTab.writeTimingToBase(identifier, found)

		animationIdInput:SetValue(found.id)
		rpueToggle:SetValue(found.rpue)
		rpdInput:SetValue(found.rpd)
	end
end

---Initialize part section.
---@param identifier string
---@param groupbox table
---@param pair TimingContainerPair
function BuilderTab.initPartSection(identifier, groupbox, pair)
	local container = ActionContainer.new()
	local timing = PartTiming.new()

	local duihToggle = Options[Configuration.identify(identifier, "DelayUntilInHitbox")]
	local duihtDepBox = duihToggle:AddDependencyBox()

	duihtDepBox:AddInput(Configuration.identify(identifier, "TimingDelay"), {
		Text = "Timing Delay",
		Numeric = true,
	})

	duihtDepBox:SetupDependencies({
		{ duihToggle, false },
	})

	local partNameInput = groupbox:AddInput(Configuration.identify(identifier, "PartName"), {
		Text = "Part Name",
	})

	local partContentFilter = groupbox:AddDropdown(Configuration.identify(identifier, "PartContentFilter"), {
		Name = "Part Content Filter",
		Values = {},
		Default = nil,
		AllowNull = true,
		Multi = true,
	})

	local partContentName = groupbox:AddInput(Configuration.identify(identifier, "PartContentName"), {
		Text = "Part Content Name",
	})

	---@note: De-duplicate me?
	---@see: VisualsTab.addFilterESP

	groupbox:AddButton("Add Name To Filter", function()
		local partContentNameValue = partContentName.Value

		if #partContentNameValue <= 0 then
			return Logger.longNotify("Please enter a valid filter name.")
		end

		local partContentFilterValues = partContentFilter.Values

		if not table.find(partContentFilterValues, partContentNameValue) then
			table.insert(partContentFilterValues, partContentNameValue)
		end

		partContentFilter:SetValues(partContentFilterValues)
		partContentFilter:SetValue({})
		partContentFilter:Display()
	end)

	groupbox:AddButton("Remove Selected From Filter", function()
		local partContentFilterValues = partContentFilter.Values
		local selectedFilterNames = partContentFilter.Value

		for selectedFilterName, _ in next, selectedFilterNames do
			local selectedIndex = table.find(partContentFilterValues, selectedFilterName)
			if not selectedIndex then
				return Logger.longNotify("The selected filter name %s does not exist in the list", selectedFilterName)
			end

			table.remove(partContentFilterValues, selectedIndex)
		end

		partContentFilter:SetValues(partContentFilterValues)
		partContentFilter:SetValue({})
		partContentFilter:Display()
	end)

	local imddSlider = groupbox:AddSlider(Configuration.identify(identifier, "InitialMinimumDistance"), {
		Name = "Initial Minimum Distance",
		Min = 0,
		Max = 100,
		Suffix = "s",
		Default = 0,
	})

	local imxdSlider = groupbox:AddSlider(Configuration.identify(identifier, "InitialMaximumDistance"), {
		Name = "Initial Maximum Distance",
		Min = 0,
		Max = 10000,
		Suffix = "s",
		Default = 0,
	})

	BuilderTab.addActionBuilder(identifier, groupbox, container)

	groupbox:AddButton("Add Timing To List", function()
		timing.pname = partNameInput.Value
		timing.filter = partContentFilter.Values
		timing.imdd = imddSlider.Value
		timing.imxd = imxdSlider.Value

		BuilderTab.baseBuilderTimingAdd(identifier, timing, container, groupbox, pair)
	end)

	groupbox:AddButton("Remove Timing From List", function()
		BuilderTab.baseBuilderTimingRemove(identifier, timing, groupbox, pair)
	end)

	local timingList = Options[Configuration.identify(identifier, "TimingList")]

	timingList.Callback = function()
		local name = timingList.Value
		if not name then
			return
		end

		local found = pair:config():find(name)
		if not found then
			return Logger.longNotify("The selected timing '%s' does not exist in the list.", name)
		end

		BuilderTab.writeTimingToBase(identifier, found)

		partNameInput:SetValue(found.pname)
		imddSlider:SetValue(found.imdd)
		imxdSlider:SetValue(found.imxd)

		partContentFilter:SetValues(found.filter)
		partContentFilter:SetValue({})
		partContentFilter:Display()
	end
end

---Initialize sound section.
---@param identifier string
---@param groupbox table
---@param pair TimingContainerPair
function BuilderTab.initSoundSection(identifier, groupbox, pair)
	local container = ActionContainer.new()
	local timing = SoundTiming.new()

	local soundIdInput = groupbox:AddInput(Configuration.identify(identifier, "SoundId"), {
		Text = "Sound ID",
	})

	local rpueToggle = groupbox:AddToggle(Configuration.identify(identifier, "RepeatParryUntilEnd"), {
		Text = "Repeat Parry Until Sound End",
		Default = false,
	})

	local rpueDepBoxOn = rpueToggle:AddDependencyBox()
	local rpueDepBoxOff = rpueToggle:AddDependencyBox()

	local rpdInput = rpueDepBoxOn:AddInput(Configuration.identify(identifier, "RepeatParryDelay"), {
		Text = "Repeat Parry Delay",
		Numeric = true,
	})

	BuilderTab.addActionBuilder(identifier, rpueDepBoxOff, container)

	rpueDepBoxOn:SetupDependencies({
		{ rpueToggle, true },
	})

	rpueDepBoxOff:SetupDependencies({
		{ rpueToggle, false },
	})

	groupbox:AddButton("Add Timing To List", function()
		timing.id = soundIdInput.Value
		timing.rpue = rpueToggle.Value
		timing.rpd = rpdInput.Value

		BuilderTab.baseBuilderTimingAdd(identifier, timing, container, groupbox, pair)
	end)

	groupbox:AddButton("Remove Timing From List", function()
		BuilderTab.baseBuilderTimingRemove(identifier, timing, groupbox, pair)
	end)

	local timingList = Options[Configuration.identify(identifier, "TimingList")]

	timingList.Callback = function()
		local name = timingList.Value
		if not name then
			return
		end

		local found = pair:config():find(name)
		if not found then
			return Logger.longNotify("The selected timing '%s' does not exist in the list.", name)
		end

		BuilderTab.writeTimingToBase(identifier, found)

		soundIdInput:SetValue(found.id)
		rpueToggle:SetValue(found.rpue)
		rpdInput:SetValue(found.rpd)
	end
end

---Initialize effect section.
---@param identifier string
---@param groupbox table
---@param pair TimingContainerPair
function BuilderTab.initEffectSection(identifier, groupbox, pair)
	local container = ActionContainer.new()
	local timing = EffectTiming.new()

	local effectNameInput = groupbox:AddInput(Configuration.identify(identifier, "EffectName"), {
		Text = "Effect Name",
	})

	local rpueToggle = groupbox:AddToggle(Configuration.identify(identifier, "RepeatParryUntilEnd"), {
		Text = "Repeat Parry Until Effect End",
		Default = false,
	})

	local rpueDepBoxOn = rpueToggle:AddDependencyBox()
	local rpueDepBoxOff = rpueToggle:AddDependencyBox()

	local rpdInput = rpueDepBoxOn:AddInput(Configuration.identify(identifier, "RepeatParryDelay"), {
		Text = "Repeat Parry Delay",
		Numeric = true,
	})

	BuilderTab.addActionBuilder(identifier, rpueDepBoxOff, container)

	rpueDepBoxOn:SetupDependencies({
		{ rpueToggle, true },
	})

	rpueDepBoxOff:SetupDependencies({
		{ rpueToggle, false },
	})

	groupbox:AddButton("Add Timing To List", function()
		timing.ename = effectNameInput.Value
		timing.rpue = rpueToggle.Value
		timing.rpd = rpdInput.Value

		BuilderTab.baseBuilderTimingAdd(identifier, timing, container, groupbox, pair)
	end)

	groupbox:AddButton("Remove Timing From List", function()
		BuilderTab.baseBuilderTimingRemove(identifier, timing, groupbox, pair)
	end)

	local timingList = Options[Configuration.identify(identifier, "TimingList")]

	timingList.Callback = function()
		local name = timingList.Value
		if not name then
			return
		end

		local found = pair:config():find(name)
		if not found then
			return Logger.longNotify("The selected timing '%s' does not exist in the list.", name)
		end

		BuilderTab.writeTimingToBase(identifier, found)

		effectNameInput:SetValue(found.ename)
		rpueToggle:SetValue(found.rpue)
		rpdInput:SetValue(found.rpd)
	end
end

---Initialize tab.
---@param window table
function BuilderTab.init(window)
	-- Create tab.
	local tab = window:AddTab("Builder")

	-- Initialize sections.
	BuilderTab.initSaveManagerSection(tab:AddDynamicGroupbox("Save Manager"))
	BuilderTab.initMergeManagerSection(tab:AddDynamicGroupbox("Merge Manager"))
	BuilderTab.initLoggerSection(tab:AddDynamicGroupbox("Logger"))

	-- Initalize builder sections.
	BuilderTab.initAnimationSection(
		BuilderTab.initBuilderSection("Animation", tab:AddDynamicGroupbox("Animation"), SaveManager.as)
	)

	BuilderTab.initEffectSection(
		BuilderTab.initBuilderSection("Effect", tab:AddDynamicGroupbox("Effect"), SaveManager.es)
	)

	BuilderTab.initPartSection(BuilderTab.initBuilderSection("Part", tab:AddDynamicGroupbox("Part"), SaveManager.ps))

	BuilderTab.initSoundSection(BuilderTab.initBuilderSection("Sound", tab:AddDynamicGroupbox("Sound"), SaveManager.ss))
end

-- Return CombatTab module.
return BuilderTab
