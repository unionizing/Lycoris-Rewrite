---@module Utility.Serializer
local Serializer = require("Utility/Serializer")

---@module Utility.Deserializer
local Deserializer = require("Utility/Deserializer")

---@module Utility.String
local String = require("Utility/String")

---@module Utility.Logger
local Logger = require("Utility/Logger")

-- PersistentData module.
local PersistentData = {
	_data = {
		-- First timestamp of when Lycoris was loaded.
		fli = nil,

		-- The last used slot.
		lus = nil,

		-- Echo farm persistence - did we trigger a server hop from wiping our character or distance? If so, skip the wipe slot handler.
		shw = false,

		-- Echo farm persistence - do we need to activate on initialization?
		aei = false,

		-- Bestiary data.
		best = nil,
	},
}

-- Services.
local memStorageService = game:GetService("MemStorageService")

---Get a field in the persistent data.
---@param field string
---@return any
function PersistentData.get(field)
	return PersistentData._data[field]
end

---Change a field in the persistent data.
---@param field string
---@param value any
function PersistentData.set(field, value)
	-- Set persistent field.
	PersistentData._data[field] = value

	-- Save the persistent data.
	memStorageService:SetItem("LYCORIS_PERSISTENT_DATA", Serializer.marshal(PersistentData._data))
end

---Initialize PersistentData module.
function PersistentData.init()
	local hasSuccess, hasResult = pcall(memStorageService.HasItem, memStorageService, "LYCORIS_PERSISTENT_DATA")
	if not hasSuccess then
		return hasResult and Logger.warn("(%s) Failed to check for PersistentData snapshot.", tostring(hasResult))
	end

	local itemSuccess, itemResult = pcall(memStorageService.GetItem, memStorageService, "LYCORIS_PERSISTENT_DATA")
	if not itemSuccess then
		return Logger.warn("(%s) Failed to get PersistentData snapshot", tostring(itemResult))
	end

	if itemResult == nil or itemResult == "" then
		return Logger.warn("PersistentData snapshot is missing or empty.")
	end

	local success, result = pcall(Deserializer.unmarshal_one, String.tba(itemResult))
	if not success then
		return Logger.warn("(%s) Failed to deserialize PersistentData snapshot.", tostring(result))
	end

	Logger.warn("(%s) Successfully loaded PersistentData snapshot.", tostring(result))

	PersistentData._data = result
end

-- Return PersistentData module.
return PersistentData
