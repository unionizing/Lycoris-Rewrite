-- Finder utility is handled here.
local Finder = {}

-- Services.
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

---Check if we are near a position of a specified position.
---@param position Vector3
---@param range number
---@return boolean
Finder.near = LPH_NO_VIRTUALIZE(function(position, range)
	local localCharacter = players.LocalPlayer.Character
	if not localCharacter then
		return false
	end

	local localRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
	if not localRootPart then
		return false
	end

	return (position - localRootPart.Position).Magnitude <= range
end)

---Is a player within X studs of the specified position?
---@param position Vector3
---@param range number
---@return Player|nil
Finder.pnear = LPH_NO_VIRTUALIZE(function(position, range)
	for _, player in next, players:GetPlayers() do
		if player == players.LocalPlayer then
			continue
		end

		local character = player.Character
		if not character then
			continue
		end

		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if not rootPart then
			continue
		end

		if (position - rootPart.Position).Magnitude > range then
			continue
		end

		return player
	end

	return nil
end)

---Find an entity by its name.
---@param name string The name of the entity to find. It is matched.
---@return Model?
Finder.entity = LPH_NO_VIRTUALIZE(function(name)
	local live = workspace:FindFirstChild("Live")
	if not live then
		return nil
	end

	for _, child in next, live:GetChildren() do
		if not child.Name:match(name) then
			continue
		end

		return child
	end
end)

---Get the nearest area marker.
---@param position Vector3 The position to check from.
---@return Model?
Finder.marker = LPH_NO_VIRTUALIZE(function(position)
	local markerWorkspace = replicatedStorage:FindFirstChild("MarkerWorkspace")
	if not markerWorkspace then
		return nil
	end

	local areaMarkers = markerWorkspace:WaitForChild("AreaMarkers")
	if not areaMarkers then
		return nil
	end

	local nearestAreaMarker = nil
	local nearestDistance = nil

	for _, marker in next, areaMarkers:GetDescendants() do
		if not marker:IsA("Part") then
			continue
		end

		local distance = (position - marker.Position).Magnitude

		if nearestDistance and distance >= nearestDistance then
			continue
		end

		nearestAreaMarker = marker
		nearestDistance = distance
	end

	return nearestAreaMarker
end)

---Find the first tool equipped by a user by name.
---@param name string The name of the tool to find. It is matched.
---@return Tool?
Finder.etool = LPH_NO_VIRTUALIZE(function(name)
	local character = players.LocalPlayer.Character
	if not character then
		return nil
	end

	for _, item in next, character:GetChildren() do
		if not item:IsA("Tool") then
			continue
		end

		if not item.Name:match(name) then
			continue
		end

		return item
	end

	return nil
end)

---Find the first tool in a backpack by name.
---@param name string The name of the tool to find. It is matched.
---@return Tool?
Finder.tool = LPH_NO_VIRTUALIZE(function(name)
	local backpack = players.LocalPlayer:FindFirstChild("Backpack")
	if not backpack then
		return nil
	end

	for _, item in next, backpack:GetChildren() do
		if not item:IsA("Tool") then
			continue
		end

		if not item.Name:match(name) then
			continue
		end

		return item
	end

	return nil
end)

---Get the nearest chest from a position.
---@param position Vector3 The position to check from.
---@param range number The maximum distance to check.
---@return Model?
Finder.chest = LPH_NO_VIRTUALIZE(function(position, range)
	local thrown = workspace:FindFirstChild("Thrown")
	if not thrown then
		return nil
	end

	local nearestChest = nil
	local nearestDistance = nil

	for _, chest in next, thrown:GetChildren() do
		if not chest:IsA("Model") then
			continue
		end

		local distance = (position - chest:GetPivot().Position).Magnitude

		if range and distance > range then
			continue
		end

		if nearestDistance and distance >= nearestDistance then
			continue
		end

		nearestChest = chest
		nearestDistance = distance
	end

	return nearestChest
end)

---Give an instance & a filter & a distance, return a sorted-by-distance list of parts which pass the filter and are within the distance.
---@param instance Instance The instance to check from.
---@param filter fun(part: BasePart): boolean A filter function which returns true if the part should be included.
---@param distance number The maximum distance in studs.
---@return BasePart[]
Finder.sdparts = LPH_NO_VIRTUALIZE(function(instance, filter, distance)
	local localCharacter = players.LocalPlayer.Character
	local localRootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
	if not localRootPart then
		return
	end

	local validParts = {}
	local partsToDistance = {}

	for _, part in next, instance:GetChildren() do
		if not part:IsA("BasePart") then
			continue
		end

		if not filter(part) then
			continue
		end

		local pdistance = (part.Position - instance.Position).Magnitude

		if pdistance > distance then
			continue
		end

		validParts[#validParts + 1] = part
		partsToDistance[part] = pdistance
	end

	table.sort(validParts, function(partOne, partTwo)
		return partsToDistance[partOne] < partsToDistance[partTwo]
	end)

	return validParts
end)

---This function is sorted from the nearest to the farthest player.
---Get players within a certain range in studs from the local player.
---@param range number
---@return Model[]
Finder.gpir = LPH_NO_VIRTUALIZE(function(range)
	local live = workspace:FindFirstChild("Live")
	if not live then
		return
	end

	local localCharacter = players.LocalPlayer.Character
	local localRootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
	if not localRootPart then
		return
	end

	local playersInRange = {}
	local playersDistance = {}

	for _, player in next, players:GetPlayers() do
		if player == players.LocalPlayer then
			continue
		end

		local character = player.Character
		if not character then
			continue
		end

		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if not rootPart then
			continue
		end

		local playerDistance = (rootPart.Position - localRootPart.Position).Magnitude
		if playerDistance > range then
			continue
		end

		table.insert(playersInRange, player)

		playersDistance[player] = playerDistance
	end

	table.sort(playersInRange, function(playerOne, playerTwo)
		return playersDistance[playerOne] < playersDistance[playerTwo]
	end)

	return playersInRange
end)

---This function is sorted from the nearest to the farthest entity.
---Get entity within a certain range in studs from the local player.
---@param range number
---@param pfilter boolean If true, filter out all players from the search.
---@return Model[]
Finder.geir = LPH_NO_VIRTUALIZE(function(range, pfilter)
	local live = workspace:FindFirstChild("Live")
	if not live then
		return
	end

	local localCharacter = players.LocalPlayer.Character
	local localRootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
	if not localRootPart then
		return
	end

	local entitiesInRange = {}
	local entitiesDistance = {}

	for _, entity in next, live:GetChildren() do
		if entity == localCharacter then
			continue
		end

		local rootPart = entity:FindFirstChild("HumanoidRootPart")
		if not rootPart then
			continue
		end

		local entityDistance = (rootPart.Position - localRootPart.Position).Magnitude
		if entityDistance > range then
			continue
		end

		table.insert(entitiesInRange, entity)

		entitiesDistance[entity] = entityDistance
	end

	table.sort(entitiesInRange, function(mobOne, mobTwo)
		return entitiesDistance[mobOne] < entitiesDistance[mobTwo]
	end)

	if not pfilter then
		return entitiesInRange
	end

	local list = {}

	for _, entity in next, entitiesInRange do
		if players:GetPlayerFromCharacter(entity) then
			continue
		end

		table.insert(list, entity)
	end

	return list
end)

-- Return Finder module.
return Finder
