---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.TaskSpawner
local TaskSpawner = require("Utility/TaskSpawner")

---@class FiniteState
---@field identifier string
---@field callback function(self: FiniteState): any
---@field maid Maid
local FiniteState = {}
FiniteState.__index = FiniteState

---Detach a finite state.
function FiniteState:detach()
	self.maid:clean()
end

---Start a finite state.
---@param machine FiniteStateMachine The machine who started us.
function FiniteState:start(machine)
	self.maid:add(
		TaskSpawner.spawn(string.format("FiniteStateCallback_%s", self.identifier), self.callback, self, machine)
	)
end

---Create a new finite state.
---@param identifier string
---@param callback function(self: FiniteState): any
---@return any
function FiniteState.new(identifier, callback)
	local self = setmetatable({}, FiniteState)
	self.identifier = identifier
	self.callback = callback
	self.maid = Maid.new()
	return self
end

-- Return FiniteState module.
return FiniteState
