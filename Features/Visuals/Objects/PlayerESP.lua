---@module Features.Visuals.Objects.EntityESP
local EntityESP = require("Features/Visuals/Objects/EntityESP")

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

---@module Game.PlayerScanning
local PlayerScanning = require("Game/PlayerScanning")

---@class PlayerESP: EntityESP
local PlayerESP = setmetatable({}, { __index = EntityESP })
PlayerESP.__index = PlayerESP
PlayerESP.__type = "PlayerESP"

-- Services.
local players = game:GetService("Players")

-- Formats.
local ESP_HEALTH = "[%i/%i]"
local ESP_POWER = "[Power %i]"
local ESP_DANGER_TIME = "[%s]"

---Check if a player has an oath.
---@return boolean
local hasOath = LPH_NO_VIRTUALIZE(function(player)
	local backpack = player:FindFirstChildOfClass("Backpack")
	if not backpack then
		return false
	end

	for _, instance in next, backpack:GetChildren() do
		if not instance.Name:match("Oath") then
			continue
		end

		return true
	end

	return false
end)

---Update PlayerESP.
---@param self PlayerESP
PlayerESP.update = LPH_NO_VIRTUALIZE(function(self)
	local localPlayer = players.LocalPlayer
	local localCharacter = localPlayer.Character

	local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
	local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

	if not localRoot then
		return self:visible(false)
	end

	if not localHumanoid then
		return self:visible(false)
	end

	local entity = self.entity
	local player = self.player
	local identifier = self.identifier

	local humanoid = entity:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return self:visible(false)
	end

	local root = entity:FindFirstChild("HumanoidRootPart")
	if not root then
		return self:visible(false)
	end

	if
		PlayerScanning.isAlly(player)
		and Configuration.idToggleValue(identifier, "HideIfAlly")
		and Configuration.idToggleValue(identifier, "MarkAllies")
	then
		return self:visible(false)
	end

	-- Update text.
	local state = "NEUTRAL"
	local delta = localHumanoid.Health - humanoid.Health
	local color = Color3.new(1, 1, 1)

	if delta < 0 then
		state = "UNDER"
	end

	if delta < -50 then
		color = Color3.new(1, 0, 0)
	end

	if delta > 0 then
		state = "OVER"
	end

	if delta > 50 then
		color = Color3.new(0, 1, 0)
	end

	local fcontainer = self.fcontainer
	local flabel = fcontainer and fcontainer:FindFirstChildOfClass("TextLabel")
	local distance = (localRoot.Position - root.Position).Magnitude

	if fcontainer and flabel then
		-- Update flag text.
		self:utext(fcontainer, string.format("%s\n%iHP", state, math.ceil(delta)))

		-- Text size.
		flabel.Position = UDim2.new(0, 2, 0, flabel.TextSize + 2)
		flabel.TextColor3 = color

		-- Visibility?
		fcontainer.Visible = Configuration.idToggleValue(identifier, "ShowHealthComparison") and distance <= 150
	end

	-- Bar mapping.
	local mapping = {
		["ArmorBar"] = { container = self.abar, vstore = self.entity:FindFirstChild("Armor") },
		["PostureBar"] = { container = self.pbar, vstore = self.entity:FindFirstChild("BreakMeter") },
		["BloodBar"] = { container = self.bbar, vstore = self.entity:FindFirstChild("Blood") },
		["TempoBar"] = { container = self.tbar, vstore = self.entity:FindFirstChild("Tempo") },
		["SanityBar"] = { container = self.sbar, vstore = self.entity:FindFirstChild("Sanity") },
	}

	for idx, data in next, mapping do
		local container = data.container
		if not container then
			continue
		end

		-- Visibility?
		container.Visible = Configuration.idToggleValue(identifier, idx)

		-- Modify size.
		self.mbs(container, false, data.vstore and data.vstore.Value / data.vstore.MaxValue or 0.0)

		local bar = self.gb(container)
		if not bar then
			continue
		end

		-- Bar color.
		bar.BackgroundColor3 = Configuration.idOptionValue(identifier, idx .. "Color") or Color3.new(0.0, 0.0, 0.0)
	end

	local level = entity:GetAttribute("Level") or -1
	local playerNameType = Configuration.idOptionValue(identifier, "PlayerNameType")
	local playerName = "Unknown Player"

	if playerNameType == "Character Name" then
		playerName = player:GetAttribute("CharacterName")
	elseif playerNameType == "Roblox Display Name" then
		playerName = player.DisplayName
	elseif playerNameType == "Roblox Username" then
		playerName = player.Name
	end

	if Configuration.expectToggleValue("InfoSpoofing") and Configuration.expectToggleValue("SpoofOtherPlayers") then
		playerName = "Linoria V2 On Top"
	end

	self.label = playerName

	local tags = { ESP_HEALTH:format(humanoid.Health or -1, humanoid.MaxHealth or -1), ESP_POWER:format(level) }

	local dangerTime = humanoid:GetAttribute("DangerExpiration")
	local dangerTimeLeft = dangerTime and math.ceil(dangerTime - workspace:GetServerTimeNow())

	if Configuration.idToggleValue(identifier, "ShowDangerTime") and dangerTimeLeft and dangerTimeLeft >= 0 then
		tags[#tags + 1] = ESP_DANGER_TIME:format(
			dangerTimeLeft >= 60 and os.date("%Mm %Ss", dangerTimeLeft) or os.date("%Ss", dangerTimeLeft)
		)
	end

	EntityESP.update(self, tags)

	local label = self.ncontainer:FindFirstChildOfClass("TextLabel")
	if not label then
		return
	end

	local backpack = player:FindFirstChildOfClass("Backpack")
	if not backpack then
		return
	end

	if Configuration.idToggleValue(identifier, "MarkSackUsers") and entity:FindFirstChild("Sack") then
		label.TextColor3 = Configuration.idOptionValue(identifier, "SackColor")
	end

	if Configuration.idToggleValue(identifier, "MarkOathUsers") and hasOath(player) then
		label.TextColor3 = Configuration.idOptionValue(identifier, "OathColor")
	end

	if Configuration.idToggleValue(identifier, "MarkAllies") and PlayerScanning.isAlly(player) then
		label.TextColor3 = Configuration.idOptionValue(identifier, "AllyColor")
	end

	local dlabel = self.dcontainer:FindFirstChildOfClass("TextLabel")
	if dlabel then
		dlabel.TextColor3 = label.TextColor3
	end
end)

---Add extra elements.
PlayerESP.extra = LPH_NO_VIRTUALIZE(function(self)
	self.abar = self:add("ArmorBar", "left", 6, function(container)
		self:cgb(container, false, true, Color3.new(1, 1, 1))
	end)

	self.pbar = self:add("PostureBar", "bottom", 3, function(container)
		self:cgb(container, false, false, Color3.new(1, 1, 1))
	end)

	self.bbar = self:add("BloodBar", "bottom", 3, function(container)
		self:cgb(container, false, false, Color3.new(1, 1, 1))
	end)

	self.tbar = self:add("TempoBar", "bottom", 3, function(container)
		self:cgb(container, false, false, Color3.new(1, 1, 1))
	end)

	self.sbar = self:add("SanityBar", "bottom", 3, function(container)
		self:cgb(container, false, false, Color3.new(1, 1, 1))
	end)

	self.fcontainer = self:add("Flags", "right", 16, function(container)
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = container
		TextLabel.Text = "NEUTRAL\n0HP"
		TextLabel.Size = UDim2.new(0, 400, 1, 0)
		TextLabel.AnchorPoint = Vector2.new(0.0, 0.5)
		TextLabel.Position = UDim2.new(0, 2, 0, 8 + 2)
		TextLabel.BackgroundTransparency = 1.0
		TextLabel.TextStrokeColor3 = Color3.new(0.0, 0.0, 0.0)
		TextLabel.TextStrokeTransparency = 0.0
		TextLabel.TextColor3 = Color3.new(1.0, 1.0, 1.0)
		TextLabel.TextSize = 8
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextWrapped = false
		TextLabel.Font = Enum.Font.Code
	end)
end)

---Create new PlayerESP object.
---@param identifier string
---@param player Player
---@param character Model
function PlayerESP.new(identifier, player, character)
	local self = setmetatable(EntityESP.new(character, identifier, "Unknown Player"), PlayerESP)
	self.player = player
	self.identifier = identifier

	if character and character:IsA("Model") and not Configuration.expectOptionValue("NoPersisentESP") then
		character.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
	end

	self:setup()
	self:build()
	self:update()

	return self
end

-- Return PlayerESP module.
return PlayerESP
