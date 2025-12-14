---@class Action
local Action = getfenv().Action

---@class Signal
local Signal = getfenv().Signal

---@class Maid
local Maid = getfenv().Maid

---@class TerrainListener
local TerrainListener = getfenv().TerrainListener

-- Listener object.
local tlistener = TerrainListener.new("ShadowSludge")

---Module function.
---@param self EffectDefender
---@param timing EffectTiming
return function(self, timing)
	if self:distance(self.owner) >= 50 then
		return
	end

	local humanoidRootPart = self.owner:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	local terrain = workspace:FindFirstChild("Terrain")
	if not terrain then
		return
	end

	tlistener:connect(function(child)
		if child.Name ~= "REP_EMIT" then
			return
		end

		if not child:IsA("Attachment") then
			return
		end

		task.wait(0.02)

		if (child.Position - humanoidRootPart.Position).Magnitude >= 5 then
			return
		end

		if self:distance(self.owner) >= 50 then
			return
		end

		timing.fhb = false

		local action = Action.new()
		action._when = 0
		action._type = "Parry"
		action.ihbc = true
		action.name = "Dynamic Shadow Sludge Timing"
		self:action(timing, action)
	end)
end
