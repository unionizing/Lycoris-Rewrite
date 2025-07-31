---@class HitboxOptions
---@note: Options for the hitbox check.
---@field part BasePart? If this is specified and it exists, it will be used for the position.
---@field cframe CFrame? Else, the part's CFrame will be used.
---@param timing Timing|EffectTiming|AnimationTiming|SoundTiming
---@field action Action?
---@field filter Instance[]
---@field spredict boolean If true, a check will run for predicted positions.
---@field entity Model? The entity for extrapolation.
local HitboxOptions = {}
HitboxOptions.__index = HitboxOptions

---@module Features.Combat.Objects.Defender
local Defender = require("Features/Combat/Objects/Defender")

-- Services.
local collectionService = game:GetService("CollectionService")
local players = game:GetService("Players")

---Get extrapolated position.
---@return CFrame
HitboxOptions.extrapolate = LPH_NO_VIRTUALIZE(function(self)
	if not self.part then
		return error("HitboxOptions.extrapolate - unimplemented for CFrame")
	end

	if not self.entity then
		return error("HitboxOptions.extrapolate - no entity specified")
	end

	-- Calculate send delay for the target entity.
	local player = players:GetPlayerFromCharacter(self.entity)
	local sd = player and player:GetAttribute("AveragePing") or 0.0

	-- Finally, calculate the final replication position delay by adding our receive delay onto their send delay.
	local fsecs = sd + Defender.rdelay()

	-- Return the extrapolated position.
	return self.part.CFrame + (self.part.AssemblyLinearVelocity * fsecs)
end)

---Get position.
---@return CFrame
HitboxOptions.pos = LPH_NO_VIRTUALIZE(function(self)
	if self.cframe then
		return self.cframe
	end

	if self.part then
		return self.part.CFrame
	end

	return error("HitboxOptions.pos - impossible condition")
end)

---Create new HitboxOptions object.
---@param target Instance|CFrame
---@param timing Timing|EffectTiming|AnimationTiming|SoundTiming
---@param filter Instance[]?
---@return HitboxOptions
HitboxOptions.new = LPH_NO_VIRTUALIZE(function(target, timing, filter)
	local self = setmetatable({}, HitboxOptions)
	self.part = typeof(target) == "Instance" and target:IsA("BasePart") and target
	self.cframe = typeof(target) == "CFrame" and target
	self.timing = timing
	self.action = nil
	self.filter = filter or {}
	self.spredict = false
	self.entity = nil

	if not self.part and not self.cframe then
		return error("HitboxOptions: No part or CFrame specified.")
	end

	if filter then
		return self
	end

	local character = players.LocalPlayer.Character
	if not character then
		return self
	end

	for _, instance in next, collectionService:GetTagged("CanHit") do
		local model = instance:FindFirstAncestorWhichIsA("Model")
		if not model or model ~= character then
			continue
		end

		table.insert(self.filter, instance)
	end

	return self
end)

-- Return HitboxOptions module.
return HitboxOptions
