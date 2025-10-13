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

		-- Server hop slot.
		shslot = nil,

		-- Servers to ignore when server hopping.
		sblacklist = {},

		-- Wipe slot.
		wslot = nil,

		-- Echo farm data.
		efdata = nil,
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

---Set a field in a table that is in persistent data.
---@param field string
---@param key string
---@param value any
function PersistentData.stf(field, key, value)
	local tbl = PersistentData.get(field)

	if type(tbl) ~= "table" then
		return error(string.format("PersistentData field '%s' is not a table.", tostring(field)))
	end

	tbl[key] = value

	PersistentData.set(field, tbl)
end

---Change a field in the persistent data.
---@param field string
---@param value any
function PersistentData.set(field, value)
	-- Set persistent field.
	PersistentData._data[field] = value

	-- Save the persistent data.
	local saveSuccess, saveResult = pcall(
		memStorageService.SetItem,
		memStorageService,
		"LYCORIS_PERSISTENT_DATA",
		Serializer.marshal(PersistentData._data)
	)

	if not saveSuccess then
		return Logger.warn("(%s) Failed to set PersistentData snapshot.", tostring(saveResult))
	end

	Logger.warn("(%s) Successfully set PersistentData snapshot.", tostring(saveResult))
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
