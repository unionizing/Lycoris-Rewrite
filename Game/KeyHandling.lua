-- KeyHandler related stuff is handled here.
local KeyHandling = {}

-- Fetch environment.
local environment = getgenv and getgenv() or _G
if not environment then
	return
end

-- Services.
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Instances.
local modules = replicatedStorage:WaitForChild("Modules")
local clientModuleManager = modules:WaitForChild("ClientManager")
local persistence = modules:WaitForChild("Persistence")

-- Modules.
local integrity = persistence:WaitForChild("Integrity")
local keyHandler = clientModuleManager:WaitForChild("KeyHandler")

---Get the stack of the KeyHandler module.
---@return table
function KeyHandling.getStack()
	local keyHandlerModule = require(keyHandler)
	return debug.getupvalue(getrawmetatable(debug.getupvalue(keyHandlerModule, 8)).__index, 1)[1][1]
end

---Get the Heaven and Hell remotes.
---@return Instance, Instance
function KeyHandling.getAntiCheatRemotes()
	local stack = KeyHandling.getStack()
	return stack[86], stack[85]
end

---Get the 'khGetRemote' funciton.
---@return function
function KeyHandling.getRemoteRaw()
	local keyHandlerModule = require(keyHandler)
	if not keyHandlerModule then
		return
	end

	local keyHandlerObject = keyHandlerModule()
	if not keyHandlerObject then
		return
	end

	return keyHandlerObject[1]
end

---Get remote from a specific remote name.
---@param remoteName string
---@return Instance|nil
function KeyHandling.getRemote(remoteName)
	local integrityModule = require(integrity)
	if not integrityModule then
		return
	end

	local keyHandlerKey = integrityModule()
	if not keyHandlerKey then
		return
	end

	local khGetRemote = KeyHandling.getRemoteRaw()
	if not khGetRemote then
		return
	end

	return khGetRemote(remoteName, keyHandlerKey)
end

-- Return KeyHandling module.
return KeyHandling
