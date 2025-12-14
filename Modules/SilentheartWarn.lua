---@type Action
local Action = getfenv().Action

-- Services.
local players = game:GetService("Players")

---Look for attachment -> recolor.
---@return ParticleEmitter?
local function getRecolorEmitter()
	local character = players.LocalPlayer.Character
	if not character then
		return
	end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	for _, child in next, hrp:GetChildren() do
		if not child:IsA("Attachment") then
			continue
		end

		local recolor = child:FindFirstChild("Recolor")
		if not recolor then
			continue
		end

		return recolor
	end
end

---Module function.
---@param self EffectDefender
---@param timing EffectTiming
return function(self, timing)
	local hrp = players.LocalPlayer.Character and players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local recolor = nil

	repeat
		-- Wait.
		task.wait()

		-- Get recolor emitter.
		recolor = getRecolorEmitter()
	until recolor

	local action = Action.new()
	action._when = 250
	action._type = "Parry"
	action.ihbc = true
	action.name = string.format("(%.6f - %.6f) Dynamic Relentless Hunt Timing", recolor.Speed.Min, recolor.Speed.Max)
	return self:action(timing, action)
end
