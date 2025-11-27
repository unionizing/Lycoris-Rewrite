---@type Action
local Action = getfenv().Action

---@module Modules.Globals.Weapon
local Weapon = getfenv().Weapon

-- Services.
local players = game:GetService("Players")

---@module Utility.Signal
local Signal = getfenv().Signal

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local data = Weapon.data(self.entity)
	if not data then
		return
	end

	local ehrp = self.entity:FindFirstChild("HumanoidRootPart")
	if not ehrp then
		return
	end

	local character = players.LocalPlayer.Character
	if not character then
		return
	end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local hasNemesisEye = false

	for _, inst in next, hrp:GetChildren() do
		if inst.Name ~= "REP_EMIT" then
			continue
		end

		local emitter = inst:FindFirstChildWhichIsA("ParticleEmitter")
		if not emitter then
			continue
		end

		if emitter.Texture ~= "rbxassetid://11889781532" then
			continue
		end

		hasNemesisEye = true
		break
	end

	local action = Action.new()
	action._when = 350
	action._type = "Parry"
	action.hitbox = Vector3.new(15, 15, 15)
	action.name = "Dynamic Katana Crit Timing"

	if data.nemesis and hasNemesisEye then
		action._when = 550
		action.ihbc = true
	end

	local onDescendantAdded = Signal.new(self.entity.DescendantAdded)

	self.tmaid:add(onDescendantAdded:connect("KatanaCritical_DetectManiKatti", function(child)
		local current = self.tasks[#self.tasks]
		if not current then
			return
		end

		if child.Name ~= "CLIENT_SOUND_5033483075" then
			return
		end

		current:cancel()
	end))

	return self:action(timing, action)
end
