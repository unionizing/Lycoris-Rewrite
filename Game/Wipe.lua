-- Wipe module.
local Wipe = {}

-- Constants.
local LOBBY_PLACE_ID = 4111023553
local FRAGMENTS_OF_SELF_POS = Vector3.new(2910.00, 1133.03, 1474.00)

---@module Utility.PersistentData
local PersistentData = require("Utility/PersistentData")

---@module Utility.Finder
local Finder = require("Utility/Finder")

---@module Game.ServerHop
local ServerHop = require("Game/ServerHop")

---@module Utility.Logger
local Logger = require("Utility/Logger")

-- Debugging mode.
local DEBUGGING_MODE = true

-- Services.
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

---Telemetry log.
local function telemetryLog(...)
	if not DEBUGGING_MODE then
		return
	end

	Logger.warn(...)

	task.wait(1)
end

---Wait until we're in the fragments of self area.
function Wipe.pwait()
	local slot = PersistentData.get("wslot")
	if not slot then
		return error("No wipe slot set in PersistentData.")
	end

	local startTimestamp = os.clock()

	while task.wait() do
		if os.clock() - startTimestamp >= 30 then
			return ServerHop.hop(slot, true)
		end

		if Finder.near(FRAGMENTS_OF_SELF_POS, 500) then
			break
		end
	end
end

---Start the process for wiping a slot in the depths.
function Wipe.depths()
	-- Request start.
	local requests = replicatedStorage:WaitForChild("Requests")
	local startMenu = requests:WaitForChild("StartMenu")
	local start = startMenu:WaitForChild("Start")

	telemetryLog("(Depths) Requesting start.")

	start:FireServer()

	-- Wait until our character is in the fragments of self area.
	Wipe.pwait()

	-- Look for people in the Fragments of Self area.
	telemetryLog("(Depths) Looking for anyone in the Fragments of Self area.")

	local wslot = PersistentData.get("wslot")
	if not wslot then
		return error("No wipe slot set in PersistentData.")
	end

	if Finder.pnear(FRAGMENTS_OF_SELF_POS, 500) then
		return ServerHop.hop(wslot, true)
	end

	-- Attempt to repeatedly teleport and interact.
	local npcs = workspace:WaitForChild("NPCs")
	local selfNpc = npcs:WaitForChild("Self")
	local selfCFrame = selfNpc:GetPivot()
	local character = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
	local dialogueEvent = requests:WaitForChild("SendDialogue")
	local interactPrompt = selfNpc:WaitForChild("InteractPrompt")
	local getScore = requests:WaitForChild("GetScore")
	local scoreReceived = false

	getScore.OnClientEvent:Connect(function(_)
		telemetryLog("(Depths) Received score data.")
		scoreReceived = true
	end)

	telemetryLog("(Depths) Teleporting and interacting with Self NPC.")

	while task.wait() do
		-- Teleport to NPC.
		character:PivotTo(selfCFrame * CFrame.new(0, 0, 2))

		-- Fire prompt.
		fireproximityprompt(interactPrompt)

		-- Send the dialogue event for [The End] so we can get wiped.
		dialogueEvent:FireServer({
			["choice"] = "[The End]",
		})

		-- Break if we've received score data.
		if scoreReceived then
			break
		end
	end

	telemetryLog("(Depths) Wiped slot. Server hopping after removing marker.")

	-- Add or remove markers.
	PersistentData.set("wslot", nil)

	if PersistentData.get("efdata") then
		PersistentData.stf("efdata", "wiped", true)
	end

	-- Server hop.
	ServerHop.hop(wslot, true)
end

---Start the process for wiping a slot in the lobby.
function Wipe.lobby()
	telemetryLog("(Lobby) (Step 1) Wiping slot in lobby.")

	-- Keep attempting to wipe the slot until successful.
	local requests = replicatedStorage:WaitForChild("Requests")
	local wipeSlot = requests:WaitForChild("WipeSlot")

	local wslot = PersistentData.get("wslot")
	if not wslot then
		return error("No wipe slot set in PersistentData.")
	end

	repeat
		task.wait()
	until wipeSlot:InvokeServer(wslot)

	telemetryLog("(Lobby) (Step 2) Wiped slot. Server hopping.")

	-- Server hop.
	ServerHop.hop(wslot, false)
end

---Invoke a wipe for a specific slot.
---@param slot string The data slot to wipe.
function Wipe.invoke(slot)
	-- Mark slot.
	PersistentData.set("wslot", slot)

	telemetryLog("(Invoke) (Step 1) Marked slot %s in data.", slot)

	-- If we're in the lobby, continue there.
	if game.PlaceId == LOBBY_PLACE_ID then
		return Wipe.lobby()
	end

	-- Otherwise, return to the lobby first.
	return ServerHop.rlobby()
end

-- Return Wipe module.
return Wipe
