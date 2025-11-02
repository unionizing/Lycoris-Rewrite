-- AntiAFK module. This module is queued so if we have multiple features that require it, it won't conflict.
---@note: You should never leave the service access running here. Use a direct reference because we would want to know if they add any detections targeting this feature.
local AntiAFK = { wanters = {} }

---@module Utility.Signal
local Signal = require("Utility/Signal")

---@module Utility.Maid
local Maid = require("Utility/Maid")

-- Services.
local players = game:GetService("Players")

-- Maids.
local afkMaid = Maid.new()

---Add a "wanter" for AntiAFK.
function AntiAFK.start(identifier)
	AntiAFK.wanters[identifier] = true
end

-- Remove a "wanter" for AntiAFK.
function AntiAFK.stop(identifier)
	AntiAFK.wanters[identifier] = nil
end

---Initialize AntiAFK module.
function AntiAFK.init()
	local idledSignal = Signal.new(players.LocalPlayer.Idled)

	idledSignal:connect("AntiAFK_OnIdled", function()
		if not AntiAFK.wanters or #AntiAFK.wanters == 0 then
			return
		end

		local virtualUser = game:GetService("VirtualUser")
		virtualUser:CaptureController()
		virtualUser:ClickButton2(Vector2.new())
	end)
end

---Stop AntiAFK module.
function AntiAFK.detach()
	afkMaid:clean()
end

-- Return AntiAFK module.
return AntiAFK
