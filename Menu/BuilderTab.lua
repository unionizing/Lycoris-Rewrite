---@module Game.Timings.SaveManager
local SaveManager = require("Game/Timings/SaveManager")

---@module Menu.Objects.AnimationBuilderSection
local AnimationBuilderSection = require("Menu/Objects/AnimationBuilderSection")

---@module Menu.Objects.SoundBuilderSection
local SoundBuilderSection = require("Menu/Objects/SoundBuilderSection")

---@module Menu.Objects.EffectBuilderSection
local EffectBuilderSection = require("Menu/Objects/EffectBuilderSection")

---@module Menu.Objects.PartBuilderSection
local PartBuilderSection = require("Menu/Objects/PartBuilderSection")

---@module Game.Timings.AnimationTiming
local AnimationTiming = require("Game/Timings/AnimationTiming")

---@module Game.Timings.EffectTiming
local EffectTiming = require("Game/Timings/EffectTiming")

---@module Game.Timings.PartTiming
local PartTiming = require("Game/Timings/PartTiming")

---@module Game.Timings.SoundTiming
local SoundTiming = require("Game/Timings/SoundTiming")

---@module Game.Timings.ModuleManager
local ModuleManager = require("Game/Timings/ModuleManager")

---@module Features.Game.AnimationVisualizer
local AnimationVisualizer = require("Features/Game/AnimationVisualizer")

---@module GUI.Library
local Library = require("GUI/Library")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.Signal
local Signal = require("Utility/Signal")

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

---@module Utility.InstanceWrapper
local InstanceWrapper = require("Utility/InstanceWrapper")

-- Services.
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- Simulation state.
local builderMaid = Maid.new()
local simulationMaid = Maid.new()

local function runSimulationStep()
	if not Configuration.expectToggleValue("ShowHitboxSimulation") then
		return simulationMaid:clean()
	end

	local character = players.LocalPlayer.Character
	if not character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	local type = Configuration.expectOptionValue("HS_HitboxType") or "Block"
	local size = Vector3.new(
		Configuration.expectOptionValue("HS_HitboxSizeX") or 4,
		Configuration.expectOptionValue("HS_HitboxSizeY") or 4,
		Configuration.expectOptionValue("HS_HitboxSizeZ") or 4
	)

	local fd = Configuration.expectToggleValue("HS_FacingOffset")
	local soffset = Configuration.expectOptionValue("HS_ShiftOffset") or 0
	local cframe = root.CFrame

	-- Calculate CFrame.
	local usedCFrame = cframe

	if fd then
		usedCFrame = usedCFrame * CFrame.new(0, 0, -(size.Z / 2))
	end

	if soffset and soffset ~= 0 then
		usedCFrame = usedCFrame * CFrame.new(0, 0, soffset)
	end

	-- Visualize.
	local simulationPart = InstanceWrapper.create(simulationMaid, "SimulationPart", "Part", workspace)
	simulationPart.Anchored = true
	simulationPart.CanCollide = false
	simulationPart.CanQuery = false
	simulationPart.Size = size
	simulationPart.CanTouch = false
	simulationPart.Material = Enum.Material.ForceField
	simulationPart.CastShadow = false
	simulationPart.Transparency = 0.5
	simulationPart.Parent = workspace

	if type == "Block" then
		simulationPart.Shape = Enum.PartType.Block
		simulationPart.CFrame = usedCFrame
	elseif type == "Ball" then
		simulationPart.Shape = Enum.PartType.Ball
		simulationPart.CFrame = usedCFrame
	elseif type == "Cylinder" then
		simulationPart.Shape = Enum.PartType.Cylinder
		simulationPart.CFrame = usedCFrame * CFrame.Angles(0, 0, math.rad(90))
	end

	-- Detection.
	local instances = {}
	local live = workspace:WaitForChild("Live")

	for _, child in next, live:GetChildren() do
		if child == character then
			continue
		end

		instances[#instances + 1] = child
	end

	local overlapParams = OverlapParams.new()
	overlapParams.FilterDescendantsInstances = instances
	overlapParams.FilterType = Enum.RaycastFilterType.Include

	local parts = workspace:GetPartsInPart(simulationPart, overlapParams)

	if #parts > 0 then
		simulationPart.Color = Color3.fromRGB(0, 255, 0)
	else
		simulationPart.Color = Color3.fromRGB(255, 0, 0)
	end
end

-- BuilderTab module.
local BuilderTab = {
	abs = nil,
	ebs = nil,
	pbs = nil,
	sbs = nil,
}

---Refresh builder lists.
function BuilderTab.refresh()
	if BuilderTab.abs then
		BuilderTab.abs:reset()
		BuilderTab.abs:refresh()
	end

	if BuilderTab.ebs then
		BuilderTab.ebs:reset()
		BuilderTab.ebs:refresh()
	end

	if BuilderTab.pbs then
		BuilderTab.pbs:reset()
		BuilderTab.pbs:refresh()
	end

	if BuilderTab.sbs then
		BuilderTab.sbs:reset()
		BuilderTab.sbs:refresh()
	end
end

---Initialize save manager section.
---@param groupbox table
function BuilderTab.initSaveManagerSection(groupbox)
	local pasToggle = groupbox:AddToggle("PeriodicAutoSave", {
		Text = "Auto Save Periodically",
		Default = true,
	})

	local pasDepBox = groupbox:AddDependencyBox()

	pasDepBox:AddSlider("PeriodicAutoSaveInterval", {
		Text = "Auto Save Interval",
		Min = 1,
		Max = 240,
		Rounding = 0,
		Suffix = "s",
		Default = 60,
	})

	pasDepBox:SetupDependencies({
		{ pasToggle, true },
	})

	local configName = groupbox:AddInput("ConfigName", {
		Text = "Config Name",
	})

	local configList = groupbox:AddDropdown("ConfigList", {
		Text = "Config List",
		Values = SaveManager.list(),
		AllowNull = true,
	})

	groupbox
		:AddButton("Create Config", function()
			SaveManager.create(configName.Value)
			SaveManager.refresh(configList)
		end)
		:AddButton({
			Text = "Load Config",
			DoubleClick = true,
			Func = function()
				SaveManager.load(configList.Value)
				BuilderTab.refresh()
			end,
		})

	groupbox:AddButton({
		Text = "Overwrite Config",
		DoubleClick = true,
		Func = function()
			SaveManager.save(configList.Value)
		end,
	})

	groupbox:AddButton({
		Text = "Clear Config",
		DoubleClick = true,
		Func = function()
			SaveManager.clear(configList.Value)
		end,
	})

	groupbox:AddButton("Refresh List", function()
		SaveManager.refresh(configList)

		if Options.MergeConfigList then
			SaveManager.refresh(Options.MergeConfigList)
		end

		BuilderTab.refresh()
	end)

	groupbox:AddButton("Set To Auto Load", function()
		SaveManager.autoload(configList.Value)
	end)
end

---Initialize logger section.
---@param groupbox table
function BuilderTab.initLoggerSection(groupbox)
	local animVisualizerToggle = groupbox:AddToggle("ShowAnimationVisualizer", {
		Text = "Show Animation Visualizer",
		Default = false,
		Callback = AnimationVisualizer.visible,
	})

	animVisualizerToggle:AddKeyPicker(
		"AnimationVisualizerKeyBind",
		{ Default = "N/A", SyncToggleState = true, Text = "Animation Visualizer" }
	)

	local showLoggerToggle = groupbox:AddToggle("ShowLoggerWindow", {
		Text = "Show Logger Window",
		Default = false,
		Callback = function(value)
			Library.InfoLoggerFrame.Visible = value
		end,
	})

	showLoggerToggle:AddKeyPicker(
		"ShowLoggerWindowKeyBind",
		{ Default = "N/A", SyncToggleState = true, Text = "Logger Window" }
	)

	groupbox:AddSlider("MinimumLoggerDistance", {
		Text = "Minimum Logger Distance",
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "m",
		Default = 0,
	})

	groupbox:AddSlider("MaximumLoggerDistance", {
		Text = "Maximum Logger Distance",
		Min = 0,
		Max = 1000,
		Rounding = 0,
		Suffix = "m",
		Default = 0,
	})

	local blacklistedKeys = groupbox:AddDropdown("BlacklistedKeys", {
		Text = "Blacklisted Keys",
		Default = {},
		Values = Library:KeyBlacklists(),
		Multi = true,
	})

	groupbox:AddButton("Remove Selected Keys", function()
		for selected, _ in next, blacklistedKeys.Value do
			Library.InfoLoggerData.KeyBlacklistList[selected] = nil
		end

		blacklistedKeys:SetValues(Library:KeyBlacklists())
		blacklistedKeys:SetValue({})
		blacklistedKeys:Display()
	end)
end

---Initialize Module Manager section.
---@param groupbox table
function BuilderTab.initModuleManagerSection(groupbox)
	local moduleList = groupbox:AddDropdown("ModuleList", {
		Text = "Module List",
		Values = ModuleManager.loaded(),
		AllowNull = true,
		Multi = false,
	})

	groupbox:AddButton("Refresh List", function()
		-- Refresh manager.
		ModuleManager.refresh()

		-- Set loaded modules.
		moduleList:SetValues(ModuleManager.loaded())
		moduleList:SetValue(nil)
		moduleList:Display()
	end)
end

---Initialize Hitbox Simulation section.
---@param groupbox table
function BuilderTab.initHitboxSimulationSection(groupbox)
	groupbox:AddToggle("ShowHitboxSimulation", {
		Text = "Show Hitbox Simulation",
		Default = false,
	})

	groupbox:AddDropdown("HS_HitboxType", {
		Text = "Hitbox Type",
		Values = { "Block", "Ball", "Cylinder" },
		Default = "Block",
	})

	groupbox:AddSlider("HS_HitboxSizeX", {
		Text = "Hitbox Size X",
		Min = 0.1,
		Max = 100,
		Default = 4,
		Rounding = 1,
	})

	groupbox:AddSlider("HS_HitboxSizeY", {
		Text = "Hitbox Size Y",
		Min = 0.1,
		Max = 100,
		Default = 4,
		Rounding = 1,
	})

	groupbox:AddSlider("HS_HitboxSizeZ", {
		Text = "Hitbox Size Z",
		Min = 0.1,
		Max = 100,
		Default = 4,
		Rounding = 1,
	})

	groupbox:AddToggle("HS_FacingOffset", {
		Text = "Hitbox Facing Offset",
		Default = false,
	})

	groupbox:AddSlider("HS_ShiftOffset", {
		Text = "Hitbox Shift Offset",
		Min = -10,
		Max = 10,
		Default = 0,
		Rounding = 1,
	})
end

---Initialize tab.
---@param window table
function BuilderTab.init(window)
	-- Create tab.
	local tab = window:AddTab("Builder")

	-- Initialize sections.
	BuilderTab.initSaveManagerSection(tab:AddDynamicGroupbox("Save Manager"))
	BuilderTab.initModuleManagerSection(tab:AddDynamicGroupbox("Module Manager"))
	BuilderTab.initLoggerSection(tab:AddDynamicGroupbox("Logger"))
	BuilderTab.initHitboxSimulationSection(tab:AddDynamicGroupbox("Hitbox Simulation"))

	-- Create builder sections.
	BuilderTab.abs =
		AnimationBuilderSection.new("Animation", tab:AddDynamicTabbox(), SaveManager.as, AnimationTiming.new())
	BuilderTab.pbs = PartBuilderSection.new("Part", tab:AddDynamicTabbox(), SaveManager.ps, PartTiming.new())
	BuilderTab.ebs = EffectBuilderSection.new("Effect", tab:AddDynamicTabbox(), SaveManager.es, EffectTiming.new())
	BuilderTab.sbs = SoundBuilderSection.new("Sound", tab:AddDynamicTabbox(), SaveManager.ss, SoundTiming.new())

	-- Initialize builder sections.
	BuilderTab.abs:init()
	BuilderTab.ebs:init()
	BuilderTab.pbs:init()
	BuilderTab.sbs:init()

	-- Signals.
	local renderStepped = Signal.new(runService.RenderStepped)
	builderMaid:mark(renderStepped:connect("BuilderTab_RunSimulationStep", runSimulationStep))
end

---Detach tab.
function BuilderTab.detach()
	builderMaid:clean()
	simulationMaid:clean()
end

-- Return CombatTab module.
return BuilderTab
