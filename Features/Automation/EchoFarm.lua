-- EchoFarm module.
local EchoFarm = { voiding = false }

---@module Utility.PersistentData
local PersistentData = require("Utility/PersistentData")

---@module Utility.Finder
local Finder = require("Utility/Finder")

---@module Game.Wipe
local Wipe = require("Game/Wipe")

---@module Features.Game.Tweening
local Tweening = require("Features/Game/Tweening")

---@module Utility.Table
local Table = require("Utility/Table")

---@module Game.ServerHop
local ServerHop = require("Game/ServerHop")

---@module Utility.TaskSpawner
local TaskSpawner = require("Utility/TaskSpawner")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Features.Automation.AutoLoot
local AutoLoot = require("Features/Automation/AutoLoot")

---@module Features.Automation.Objects.AutoLootOptions
local AutoLootOptions = require("Features/Automation/Objects/AutoLootOptions")

-- Services.
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Constants.
local EASTERN_PLACE_ID = 6473861193
local TITUS_PLACE_ID = 8668476218
local DEBUGGING_MODE = true

-- Maid.
local echoFarmMaid = Maid.new()

-- Currently running?
local running = false

---Telemetry log.
local function telemetryLog(...)
	if not DEBUGGING_MODE then
		return
	end

	Logger.warn(...)

	task.wait(1)
end

---Handle CharacterCreation state.
function EchoFarm.ccreation()
	local requests = replicatedStorage:WaitForChild("Requests")
	local characterCreator = requests:WaitForChild("CharacterCreator")
	local pickSpawn = characterCreator:WaitForChild("PickSpawn")
	local finishCreation = characterCreator:WaitForChild("FinishCreation")
	local toggleMetaModifier = requests:WaitForChild("ToggleMetaModifier")

	local success = pickSpawn:InvokeServer("Merit")
	if not success then
		return error("Does the user not have the 'Fort Merit' spawn?")
	end

	toggleMetaModifier:FireServer("All")

	repeat
		task.wait()
	until finishCreation:InvokeServer()
end

---Go to the Titus fight.
---@param tdata table Fake data.
function EchoFarm.titus(tdata)
	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	local positions = {
		-- From spawn, we need to be up in the jar, so we won't be seen.
		CFrame.new(-7518.70, 4825.71, 3483.19),

		-- Then, tween above the gate.
		CFrame.new(-6877.09, 4825.71, 2829.91),

		-- Teleport ourselves down.
		CFrame.new(-6877.50, 329.94, 2829.21),
	}

	-- Humanoid root part.
	local character = players.LocalPlayer.Character
	local humanoidRootPart = character and character:WaitForChild("HumanoidRootPart")

	-- First position.
	local firstPosition = positions[1].Position

	firstPosition = Vector3.new(firstPosition.X, humanoidRootPart.Position.Y, firstPosition.Z)

	-- If we're not near the filltered first position, skip that position.
	if not Finder.near(firstPosition, 100) then
		table.remove(positions, 1)
	end

	-- Move towards each position. Don't stop when we reach the last one.
	telemetryLog("(EchoFarm) Moving to Titus gate.")

	for idx, cframe in next, positions do
		Tweening.goal(string.format("EF_TweenToGate_%i", idx), cframe, idx ~= #positions)
	end

	-- We wait until we've reached the last position.
	telemetryLog("(EchoFarm) Waiting to reach gate.")

	Tweening.wait(string.format("EF_TweenToGate_%i", #positions))

	-- Is anyone near here?
	telemetryLog("(EchoFarm) Checking if anyone is near the gate.")

	local map = workspace:WaitForChild("Map")
	local meritEntry = map:WaitForChild("MeritEntry")
	local interactPrompt = meritEntry:FindFirstChildWhichIsA("ProximityPrompt")

	-- Are we not near the gate at all?
	if not Finder.near(meritEntry.Position, 50) then
		return error("We are not near the 'MeritEntry' model.")
	end

	-- Is someone already here?
	telemetryLog("(EchoFarm) Checking if anyone is near the gate.")

	if Finder.pnear(meritEntry.Position, 100) then
		return ServerHop.hop(data.slot, true)
	end

	-- Keep trying to interact with the prompt and teleport us there.
	telemetryLog("(EchoFarm) Interacting with gate.")

	while task.wait() do
		fireproximityprompt(interactPrompt)
	end
end

---Wait for a chest to spawn on us.
---@param tdata table Fake data.
---@return Instance
function EchoFarm.wfc(tdata)
	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	local character = players.LocalPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	local startTimestamp = os.clock()
	local voidingTicks = 0

	while task.wait() do
		if os.clock() - startTimestamp >= 60 then
			return ServerHop.hop(data.slot, false)
		end

		EchoFarm.voiding = voidingTicks % 10 == 0
		voidingTicks = voidingTicks + 1

		local chest = Finder.chest(humanoidRootPart.Position, 300)
		if not chest then
			continue
		end

		return chest
	end

	return nil
end

---Wait for ChoicePrompt by interacting with a chest.
---@param chest Instance
---@return Instance?
function EchoFarm.wcp(chest)
	local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")
	local interactPrompt = chest:WaitForChild("InteractPrompt")

	while task.wait() do
		fireproximityprompt(interactPrompt)

		local prompt = playerGui:FindFirstChild("ChoicePrompt")
		if not prompt then
			continue
		end

		return prompt
	end

	return nil
end

---Kill titus.
---@param tdata table Fake data.
function EchoFarm.ktitus(tdata)
	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	-- Enable voiding.
	telemetryLog("(EchoFarm) Enabling voiding.")

	EchoFarm.voiding = true
	AutoLoot.ignore = true

	-- Is anyone with us?
	telemetryLog("(EchoFarm) Checking if anyone is in the dungeon with us.")

	if #players:GetPlayers() > 1 then
		return ServerHop.hop(data.slot, false)
	end

	-- Wait for chest to spawn near us.
	telemetryLog("(EchoFarm) Waiting for chest to spawn on us.")

	local chest = EchoFarm.wfc(tdata)
	if not chest then
		return error("No chest found on us.")
	end

	-- Keep interacting until we get a choice prompt.
	telemetryLog("(EchoFarm) Interacting with chest.")

	local choicePrompt = EchoFarm.wcp(chest)
	if not choicePrompt then
		return error("No ChoicePrompt found after interacting with chest.")
	end

	-- Process chest.
	telemetryLog("(EchoFarm) Processing chest.")

	AutoLoot.process(choicePrompt, AutoLootOptions.new(0, 0, {}, true))

	-- Wait until we're finished.
	telemetryLog("(EchoFarm) Waiting until auto loot is finished.")

	repeat
		task.wait()
	until not AutoLoot.active()

	-- Check if we have an enchant stone.
	telemetryLog("(EchoFarm) Checking for enchant stone.")

	local backpack = players.LocalPlayer:WaitForChild("Backpack")
	local stone, _ = Table.find(backpack:GetChildren(), function(item)
		return item.Name:match("Enchant Stone")
	end)

	if not stone then
		return ServerHop.hop(data.slot, false)
	end

	-- Mark a kill.
	telemetryLog("(EchoFarm) Marking Titus kill.")

	if not tdata then
		PersistentData.stf("efdata", "tkill", true)
	end

	-- Tween to the exit.
	telemetryLog("(EchoFarm) Tweening to dungeon exit.")

	local detainmentCore = workspace:WaitForChild("DetainmentCore")
	local dungeonExit = detainmentCore:WaitForChild("DungeonExit")
	Tweening.goal("EF_TweenToExit", CFrame.new(dungeonExit.Position), false)
end

---Wait until Stiletto is bought and in inventory.
---@param prompt ProximityPrompt
---@return Tool?
function EchoFarm.wts(prompt)
	while task.wait() do
		-- Fire.
		fireproximityprompt(prompt)

		-- Check for Stiletto in backpack.
		local stiletto = Finder.tool("Stiletto")
		if not stiletto then
			continue
		end

		-- Return it, if it exists.
		return stiletto
	end

	return nil
end

---End the cycle and wipe the character.
---@param tdata table Fake data.
function EchoFarm.cend(tdata)
	-- Log.
	telemetryLog("(EchoFarm) Invoking cycle end.")

	-- Invoke wipe and clear Titus kill marker.
	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	if not tdata then
		PersistentData.stf("efdata", "tkill", false)
	end

	Wipe.invoke(data.slot)
end

---Titus killed.
---@todo: Make it remember which state it was previously at. Perhaps, this should actually be an FSM, then.
---@todo: Selling stuff is actually super buggy. Sometimes it doesn't sell, doesn't detect proper items, and doesn't even handle legendary items properly.
---@todo: Sometimes, it can buy multiple stilletos. Need to fix that.
---@todo: The ending part is horrible. Never waits for the enchant. Never waits for the Idol. Needs to be fixed.
---@param tdata table Fake data.
function EchoFarm.tkilled(tdata)
	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	-- Handler for any choice prompts.
	local localPlayer = players.LocalPlayer
	local playerGui = localPlayer:WaitForChild("PlayerGui")
	local choicePromptResponse = true
	local choicePromptSignal = nil

	choicePromptSignal = playerGui.DescendantAdded:Connect(function(descendant)
		if descendant.Name ~= "Choice" then
			return
		end

		if not descendant:IsA("RemoteEvent") then
			return
		end

		local choicePrompt = descendant.Parent
		if not choicePrompt then
			return
		end

		repeat
			-- Fire to close prompt.
			descendant:FireServer(choicePromptResponse)

			-- Wait.
			task.wait()
		until not choicePrompt.Parent
	end)

	-- Check if anyone is near the Antiquarian.
	telemetryLog("(EchoFarm) Checking if anyone is near the Antiquarian.")

	local npcs = workspace:WaitForChild("NPCs")
	local antiquarian = npcs:WaitForChild("Antiquarian")
	local interactPrompt = antiquarian:WaitForChild("InteractPrompt")

	if Finder.pnear(antiquarian:GetPivot().Position, 100) then
		return ServerHop.hop(data.slot, true)
	end

	-- Tween to the Antiquarian and sell stuff.
	telemetryLog("(EchoFarm) Tweening to Antiquarian.")

	local antiquarianTweens = {
		CFrame.new(-6877.09, 4825.71, 2829.91),
		CFrame.new(-7512.59, 4825.71, 3351.31),
		CFrame.new(-7512.62, 25.36, 3351.15),
	}

	for idx, cframe in next, antiquarianTweens do
		Tweening.goal(string.format("EF_TweenToAntiquarian_%i", idx), cframe, idx ~= #antiquarianTweens)
	end

	Tweening.wait(string.format("EF_TweenToAntiquarian_%i", #antiquarianTweens))

	local info = replicatedStorage:WaitForChild("Info")
	local dataReplication = require(info:WaitForChild("DataReplication"))
	local currentData = dataReplication.GetData()

	local requests = game.ReplicatedStorage:WaitForChild("Requests")
	local sellItem = requests:WaitForChild("SellItem")
	local itemsToSell = {}

	for _, item in game.Players.LocalPlayer.Backpack:GetChildren() do
		if not item:IsA("Tool") then
			continue
		end

		if not item:FindFirstChild("Sellable") then
			continue
		end

		if item.Name:match("Enchant Stone") or item.Name:match("Stiletto") or item.Name:match("Idol") then
			continue
		end

		if item.Name:match("Imperator") or item.Name:match("Imperial") then
			continue
		end

		itemsToSell[#itemsToSell + 1] = item
	end

	while currentData.Notes < 15 do
		-- Fire their prompt.
		fireproximityprompt(interactPrompt)

		-- Sell items.
		if next(itemsToSell) and #itemsToSell < 200 then
			sellItem:FireServer("BatchSell", itemsToSell)
		end

		-- Wait.
		task.wait()
	end

	Tweening.stop(string.format("EF_TweenToAntiquarian_%i", #antiquarianTweens))

	-- Check if anyone is at the Stiletto vendor.
	local shops = workspace:WaitForChild("Shops")
	local stilettoPurchase = shops:WaitForChild("Stiletto")

	if Finder.pnear(stilettoPurchase:GetPivot().Position, 100) then
		return ServerHop.hop(data.slot, true)
	end

	-- Tween to the Stiletto.
	telemetryLog("(EchoFarm) Tweening to Stiletto.")

	local stilettoTweens = {
		CFrame.new(-7512.62, 4825.36, 3351.15),
		CFrame.new(-7241.25, 4825.93, 2667.78),
		CFrame.new(-7241.25, 563.93, 2667.78),
	}

	for idx, cframe in next, stilettoTweens do
		Tweening.goal(string.format("EF_TweenToStiletto_%i", idx), cframe, idx ~= #stilettoTweens)
	end

	Tweening.wait(string.format("EF_TweenToStiletto_%i", #stilettoTweens))

	-- Buy the Stiletto.
	telemetryLog("(EchoFarm) Buying Stiletto.")

	local sInteractPrompt = stilettoPurchase:WaitForChild("InteractPrompt")
	local stiletto = EchoFarm.wts(sInteractPrompt)

	Tweening.stop(string.format("EF_TweenToStiletto_%i", #stilettoTweens))
	Tweening.goal("EF_TweenInAir", CFrame.new(-7241.25, 4825.93, 2667.78), false)

	-- Use the Stiletto and Enchant Stone.
	telemetryLog("(EchoFarm) Using Stiletto and Enchant Stone.")

	local humanoid = players.LocalPlayer.Character and players.LocalPlayer.Character:FindFirstChild("Humanoid")
	if not humanoid then
		return error("No humanoid found in character.")
	end

	humanoid:EquipTool(stiletto)

	local stilettoEquipped = Finder.etool("Stiletto")
	if not stilettoEquipped then
		return error("No stiletto found equipped.")
	end

	stilettoEquipped:Activate()

	local enchantStone = Finder.tool("Enchant Stone")
	if not enchantStone then
		return error("No enchant stone found in backpack.")
	end

	humanoid:EquipTool(enchantStone)

	local enchantStoneEquipped = Finder.etool("Enchant Stone")
	if not enchantStoneEquipped then
		return error("No enchant stone found equipped.")
	end

	enchantStoneEquipped:Activate()

	-- Check for Idol of Yun-Shul.
	telemetryLog("(EchoFarm) Checking for Idol of Yun-Shul.")

	choicePromptResponse = "Give me relief from my Flaws."

	local idolOfYunShul = Finder.tool("Idol of Yun'Shul")

	if idolOfYunShul then
		humanoid:EquipTool(idolOfYunShul)
	end

	local equippedIdol = Finder.etool("Idol of Yun'Shul")

	if equippedIdol then
		equippedIdol:Activate()
	end

	-- Stop handling choice prompts.
	choicePromptSignal:Disconnect()

	-- Invoke end.
	EchoFarm.cend(tdata)
end

---Start the EchoFarm module.
function EchoFarm.start()
	local localPlayer = players.LocalPlayer
	if not localPlayer then
		return
	end

	local data = PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	if not data.slot then
		return error("No data slot found for EchoFarm.")
	end

	if running then
		return
	end

	running = true

	PersistentData.set("efdata", data)

	if localPlayer:GetAttribute("GameLoaded") == "CharacterCreation" then
		data.wiped = true
	end

	if not data.wiped then
		return Wipe.invoke(data.slot)
	end

	if localPlayer:GetAttribute("GameLoaded") == "CharacterCreation" then
		return echoFarmMaid:mark(TaskSpawner.spawn("EchoFarm_CCreation", EchoFarm.ccreation))
	end

	if game.PlaceId == EASTERN_PLACE_ID and not data.tkill then
		return echoFarmMaid:mark(TaskSpawner.spawn("EchoFarm_Titus", EchoFarm.titus))
	end

	if game.PlaceId == TITUS_PLACE_ID then
		return echoFarmMaid:mark(TaskSpawner.spawn("EchoFarm_Dungeon_KillTitusFSM", EchoFarm.ktitus))
	end

	if game.PlaceId == EASTERN_PLACE_ID and data.tkill then
		return echoFarmMaid:mark(TaskSpawner.spawn("EchoFarm_Eastern_KilledTitusFSM", EchoFarm.tkilled))
	end
end

---Invoke the EchoFarm module.
function EchoFarm.invoke()
	PersistentData.set("efdata", {
		-- Have we killed Titus?
		tkill = false,

		-- Have we done atleast one wipe to do initial setup?
		wiped = false,

		-- What is the current slot that we are farming on?
		slot = players.LocalPlayer:GetAttribute("DataSlot"),
	})

	EchoFarm.start()
end

---Stop the EchoFarm module.
function EchoFarm.stop()
	if not running then
		return
	end

	running = false

	-- Clear persistent data.
	PersistentData.set("efdata", nil)

	-- Stop all tasks.
	echoFarmMaid:clean()

	-- Cancel all tweens related to EchoFarm.
	for idx, _ in next, Tweening.queue do
		if not idx:match("EF") then
			continue
		end

		Tweening.cancel(idx)
	end
end

-- Return EchoFarm module.
return EchoFarm
