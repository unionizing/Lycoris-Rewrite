---@module Features.Visuals.Objects.PositionESP
local PositionESP = require("Features/Visuals/Objects/PositionESP")

---@module Menu.VisualsTab
local VisualsTab = require("Menu/VisualsTab")

---@module Game.PlayerScanning
local PlayerScanning = require("Game/PlayerScanning")

---@class PlayerESP: PositionESP
---@field baseLabel string
---@field player Player
---@field character Model
---@field identifier string
local PlayerESP = setmetatable({}, { __index = PositionESP })
PlayerESP.__index = PlayerESP
PlayerESP.__type = "PlayerESP"

-- Formats.
local ESP_HEALTH = "[%i/%i]"
local ESP_POWER = "[Power %i]"
local ESP_TEMPO = "[%i%% tempo]"
local ESP_BLOOD = "[%i%% blood]"
local ESP_POSTURE = "[%i%% posture]"
local ESP_HEALTH_PERCENTAGE = "[%i%% health]"
local ESP_HEALTH_BARS = "[%.1f bars]"

---Update PlayerESP.
function PlayerESP:update()
	local model = self.character
	local player = self.player
	local identifier = self.identifier

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return self:hide()
	end

	local level = model:GetAttribute("Level") or -1
	local playerNameType = VisualsTab.optionValue(identifier, "PlayerNameType")
	local playerName = "Unknown Player"

	if playerNameType == "Character Name" then
		playerName = player:GetAttribute("CharacterName")
	elseif playerNameType == "Roblox Display Name" then
		playerName = player.DisplayName
	elseif playerNameType == "Roblox Username" then
		playerName = player.Name
	end

	self.label = playerName

	local health = humanoid.Health
	local maxHealth = humanoid.MaxHealth

	local tags = { ESP_HEALTH:format(health or -1, maxHealth or -1), ESP_POWER:format(level) }

	if VisualsTab.toggleValue(identifier, "ShowTempo") then
		local tempoValue = model:FindFirstChild("Tempo")
		local percentage = tempoValue and (tempoValue.Value / tempoValue.MaxValue * 100)
		tags[#tags + 1] = tempoValue and ESP_TEMPO:format(percentage) or "[Unknown Tempo]"
	end

	if VisualsTab.toggleValue(identifier, "ShowBlood") then
		local bloodValue = model:FindFirstChild("Blood")
		local percentage = bloodValue and (bloodValue.Value / bloodValue.MaxValue * 100)
		tags[#tags + 1] = bloodValue and ESP_BLOOD:format(percentage) or "[Unknown Blood]"
	end

	if VisualsTab.toggleValue(identifier, "ShowPosture") then
		local breakMeterValue = model:FindFirstChild("BreakMeter")
		local percentage = breakMeterValue and (breakMeterValue.Value / breakMeterValue.MaxValue * 100)
		tags[#tags + 1] = breakMeterValue and ESP_POSTURE:format(percentage) or "[Unknown Posture]"
	end

	if VisualsTab.toggleValue(identifier, "ShowHealthPercentage") then
		local percentage = health / maxHealth * 100
		tags[#tags + 1] = ESP_HEALTH_PERCENTAGE:format(percentage)
	end

	if VisualsTab.toggleValue(identifier, "ShowHealthBars") then
		local healthPercentage = health / maxHealth
		local healthInBars = math.clamp(healthPercentage / 0.20, 0, 5)
		tags[#tags + 1] = ESP_HEALTH_BARS:format(healthInBars)
	end

	local modelPosition = model:GetPivot().Position
	local usedPosition = nil

	local mapPosition = model:GetAttribute("MapPos")
	if not mapPosition then
		tags[#tags + 1] = "[Not Loaded]"
	end

	local humanoidRootPart = model:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart and mapPosition then
		usedPosition = Vector3.new(mapPosition.X, modelPosition.Y, mapPosition.Z)
		tags[#tags + 1] = "[Unknown Height]"
	else
		usedPosition = modelPosition
	end

	PositionESP.update(self, usedPosition, tags)

	if not VisualsTab.toggleValue(identifier, "MarkAllies") then
		return
	end

	if not PlayerScanning.isAlly(player) then
		return
	end

	local baseText = self:getDrawing("baseText")
	baseText:set("Color", VisualsTab.optionValue(identifier, "AllyColor"))
end

---Create new PlayerESP object.
---@param identifier string
---@param player Player
---@param character Model
function PlayerESP.new(identifier, player, character)
	local self = setmetatable(PositionESP.new(identifier, "Unknown Player"), PlayerESP)
	self.player = player
	self.character = character
	self.identifier = identifier

	if character and character:IsA("Model") then
		character.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
	end

	return self
end

-- Return PlayerESP module.
return PlayerESP
