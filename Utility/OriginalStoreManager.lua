---@module Utility.OriginalStore
local OriginalStore = require("Utility/OriginalStore")

---@class OriginalStoreManager
---@param inner OriginalStore[]
local OriginalStoreManager = {}
OriginalStoreManager.__index = OriginalStoreManager

---Forget data value.
---@param data table|Instance
OriginalStoreManager.forget = LPH_NO_VIRTUALIZE(function(self, data)
	self.inner[data] = nil
end)

---Mark data value.
---@param data table|Instance
---@param index any
OriginalStoreManager.mark = LPH_NO_VIRTUALIZE(function(self, data, index)
	local object = self.inner[data] or OriginalStore.new()

	object:mark(data, index)

	self.inner[data] = object
end)

---Add data value.
---@param data table|Instance
---@param index any
---@param value any
OriginalStoreManager.add = LPH_NO_VIRTUALIZE(function(self, data, index, value)
	local object = self.inner[data] or OriginalStore.new()

	object:set(data, index, value)

	self.inner[data] = object
end)

---Get data values.
---@return OriginalStore[]
OriginalStoreManager.data = LPH_NO_VIRTUALIZE(function(self)
	return self.inner
end)

---Get data value.
---@param data table|Instance
---@return OriginalStore
OriginalStoreManager.get = LPH_NO_VIRTUALIZE(function(self, data)
	return self.inner[data]
end)

---Restore data values.
OriginalStoreManager.restore = LPH_NO_VIRTUALIZE(function(self)
	for _, store in next, self.inner do
		store:restore()
	end
end)

---Detach OriginalStoreManager object.
OriginalStoreManager.detach = LPH_NO_VIRTUALIZE(function(self)
	for _, store in next, self.inner do
		store:detach()
	end

	self.inner = {}
end)

---Create new OriginalStoreManager object.
---@return OriginalStoreManager
OriginalStoreManager.new = LPH_NO_VIRTUALIZE(function()
	local self = setmetatable({}, OriginalStoreManager)
	self.inner = {}
	return self
end)

-- Return OriginalStoreManager module.
return OriginalStoreManager
