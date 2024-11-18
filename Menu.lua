-- Menu module.
local Menu = {}

---@module GUI.ThemeManager
local ThemeManager = require("GUI/ThemeManager")

---@module GUI.SaveManager
local SaveManager = require("GUI/SaveManager")

---@module GUI.Library
local Library = require("GUI/Library")

---@module Menu.CombatTab
local CombatTab = require("Menu/CombatTab")

---@module Menu.AutomationTab
local AutomationTab = require("Menu/AutomationTab")

---@module Menu.PlayerTab
local PlayerTab = require("Menu/PlayerTab")

---@module Menu.VisualsTab
local VisualsTab = require("Menu/VisualsTab")

---@module Menu.SettingsTab
local SettingsTab = require("Menu/SettingsTab")

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.Signal
local Signal = require("Utility/Signal")

-- Services.
local runService = game:GetService("RunService")

-- Signals.
local renderStepped = Signal.new(runService.RenderStepped)

-- Maids.
local menuMaid = Maid.new()

-- Timestamp.
local sloganTimestamp = os.clock()

---Initialize menu.
function Menu.init()
	-- Create window.
	local window = Library:CreateWindow({
		Title = "Biggie Smalls Hack",
		Center = true,
		AutoShow = false,
		TabPadding = 8,
		MenuFadeTime = 0.0,
	})

	---@note: How the menu will be structured from now on:
	-- All keybinds will be using the AddKeyPicker function on the objects themselves - not as a seperate tab.
	-- Combat tab which houses auto-parry, logging, and other combat-related features.
	-- Player tab which houses auto-sprint, infinite-jump, and other player-related features.
	-- Visuals tab which houses ESP, Tracers, Emotes, Unlocked Zoom Limits and other visual-related features.
	-- Exploits tab which houses mob voiding, mob TPing, and other exploit-related features.
	-- Automation tab which houses auto-farm, auto-maestro, auto-quest, and other automation-related features.
	-- Settings tab which houses keybinds, UI settings, and other settings-related features.

	---@note: Knocked ownership will be in the exploits section - it's not included as a player feature.

	-- Configure ThemeManager.
	ThemeManager:SetLibrary(Library)
	ThemeManager:SetFolder("Lycoris-Rewrite")

	-- Configure SaveManager.
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetFolder("Lycoris-Rewrite")

	-- Initialize all tabs.
	CombatTab.init(window)
	AutomationTab.init(window)
	PlayerTab.init(window)
	VisualsTab.init(window)
	SettingsTab.init(window)

	-- Slogans.
	local slogans = {
		"Get good, get 'Biggie Smalls Hack' today.",
		"What, the third rewrite in a row?",
		"God, I need better slogans.",
		"Chicken... chicken wings.",
		"I love Pistachio Ice Cream.",
		"Is this a good slogan?",
		"I'm running out of ideas.",
		"Please help me escape the Temu factory.",
		"A chinese tracker unit is on your way.",
		"No updates for the next 9 years.",
	}

	-- Slogan loop.
	menuMaid:add(renderStepped:connect("Menu_SloganLoop", function()
		-- Check if we can change the slogan.
		if os.clock() - sloganTimestamp < 5 then
			return
		end

		-- Get random slogan.
		local slogan = string.format("Biggie Smalls Hack - %s", slogans[math.random(1, #slogans)])

		-- Log slogan.
		window:SetWindowTitle(slogan)

		-- Update timestamp.
		sloganTimestamp = os.clock()
	end))

	-- Configure Library.
	Library.ToggleKeybind = Options.MenuKeybind

	-- Load auto-load config.
	SaveManager:LoadAutoloadConfig()

	-- Log menu initialization.
	Logger.warn("Menu initialized.")
end

---Detach menu.
function Menu.detach()
	menuMaid:clean()

	Library:Unload()

	Logger.warn("Menu detached.")
end

-- Return Menu module.
return Menu
