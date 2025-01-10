---@module Features.Combat.Objects.Defender
local Defender = require("Features/Combat/Objects/Defender")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.Signal
local Signal = require("Utility/Signal")

---@module Game.Timings.SaveManager
local SaveManager = require("Game/Timings/SaveManager")

---@module Features.Combat.Targeting
local Targeting = require("Features/Combat/Targeting")

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

---@module Utility.InstanceWrapper
local InstanceWrapper = require("Utility/InstanceWrapper")

---@module Utility.TaskSpawner
local TaskSpawner = require("Utility/TaskSpawner")

---@module Game.InputClient
local InputClient = require("Game/InputClient")

---@class AnimatorDefender: Defender
---@field animator Animator
---@field entity Model
---@field heffects Instance[]
---@field track AnimationTrack?
---@field maid Maid
local AnimatorDefender = setmetatable({}, { __index = Defender })
AnimatorDefender.__index = AnimatorDefender

-- Services.
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

---Logger notify.
---@param timing AnimationTiming
---@param str string
function AnimatorDefender:log(timing, str, ...)
	Logger.notify("[%s] %s", timing.name, string.format(str, ...))
end

---Check if we're in a valid state to proceed with the action.
---@param action Action
---@return boolean
function AnimatorDefender:valid(action)
	if not self.track then
		return Logger.notify("No current track.")
	end

	if not self.entity then
		return Logger.notify("No entity found.")
	end

	local target = Targeting.find(self.entity)
	if not target then
		return Logger.notify("Not a viable target.")
	end

	local character = players.LocalPlayer.Character
	if not character then
		return Logger.notify("No character found.")
	end

	local hbStartPosition = target.root.CFrame * CFrame.new(0, 0, -(action.hitbox.Z / 2))

	local overlapParams = OverlapParams.new()
	overlapParams.FilterDescendantsInstances = { character }
	overlapParams.FilterType = Enum.RaycastFilterType.Include

	local visualizationPart = InstanceWrapper.create(self.maid, "VisualizationPart", "Part")
	visualizationPart.Size = action.hitbox
	visualizationPart.CFrame = hbStartPosition
	visualizationPart.Transparency = 0.85
	visualizationPart.Color = Color3.fromRGB(255, 0, 0)
	visualizationPart.Parent = workspace
	visualizationPart.Anchored = true
	visualizationPart.CanCollide = false
	visualizationPart.Material = Enum.Material.SmoothPlastic

	if #workspace:GetPartBoundsInBox(hbStartPosition, action.hitbox, overlapParams) <= 0 then
		return Logger.notify("Not inside of the hitbox.")
	end

	local targetInstance = self.entity:FindFirstChild("Target")
	if targetInstance and targetInstance.Value ~= self.entity and Configuration.toggleValue("CheckTargetingValue") then
		return Logger.notify("Not being targeted.")
	end

	if not self.track.IsPlaying then
		return Logger.notify("Animation stopped playing.")
	end

	local effectReplicator = replicatedStorage:FindFirstChild("EffectReplicator")
	if not effectReplicator then
		return Logger.notify("No effect replicator found.")
	end

	local effectReplicatorModule = require(effectReplicator)
	if not effectReplicatorModule then
		return Logger.notify("No effect replicator module found.")
	end

	if effectReplicatorModule:FindEffect("Parry") or effectReplicatorModule:FindEffect("Dodge") then
		return Logger.notify("Effect list has 'Parry' or 'Dodge' effect.")
	end

	if
		#self.heffects >= 1
		and (players:GetPlayerFromCharacter(self.entity) or self.entity:FindFirstChild("HumanController"))
	then
		return Logger.notify("Entity got attack cancelled.")
	end

	return true
end

---Check if the initial state is valid.
---@param timing AnimationTiming
---@return boolean
function AnimatorDefender:initial(timing)
	local entity = self.animator:FindFirstAncestorWhichIsA("Model")
	if not entity then
		return false
	end

	local entRootPart = entity:FindFirstChild("HumanoidRootPart")
	if not entRootPart then
		return false
	end

	local localCharacter = players.LocalPlayer.Character
	if not localCharacter then
		return false
	end

	local localRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
	if not localRootPart then
		return false
	end

	local distance = (entRootPart.Position - localRootPart.Position).Magnitude

	if distance < timing.imdd then
		return false
	end

	if distance > timing.imxd then
		return false
	end

	return true
end

---Repeat until parry end.
---@param track AnimationTrack
---@param timing AnimationTiming
function AnimatorDefender:rpue(track, timing)
	local index = 0

	while self.track.IsPlaying do
		task.wait(timing:rpd() - self:ping())

		if not self:initial(timing) then
			continue
		end

		index = index + 1

		self:log(timing, "Action 'RPUE Parry' is being executed at index %d.", index)

		InputClient.parry()
	end
end

---Process animation track.
---@param track AnimationTrack
function AnimatorDefender:process(track)
	if track.Priority == Enum.AnimationPriority.Core then
		return
	end

	local localCharacter = players.LocalPlayer.Character
	if localCharacter and self.entity == localCharacter then
		return
	end

	---@type AnimationTiming
	local timing = SaveManager.as:index(tostring(track.Animation.AnimationId))
	if not timing then
		return
	end

	if not self:initial(timing) then
		return
	end

	---@note: Clean up previous tasks that are still waiting or suspended because they're in a different track.
	self.tasks:clean()
	self.track = track
	self.heffects = {}

	---@note: Start processing the timing. Add the actions if we're not RPUE.
	if not timing.rpue then
		return self:actions(timing)
	end

	local rtask = TaskSpawner.delay(
		string.format("RPUE_%s", timing.name),
		timing:rsd() - self:ping(),
		self.rpue,
		self,
		track,
		timing
	)

	self:log(
		timing,
		"Added RPUE '%s' (%.2fs, then every %.2fs) with relevant ping subtracted.",
		timing.name,
		timing:rsd(),
		timing:rpd()
	)

	self.tasks:mark(rtask)
end

---Detach AnimatorDefender object.
function AnimatorDefender:detach()
	self.tasks:clean()
	self.maid:clean()
	self = nil
end

---Create new AnimatorDefender object.
---@param animator Animator
---@return AnimatorDefender
function AnimatorDefender.new(animator)
	local entity = animator:FindFirstAncestorWhichIsA("Model")
	if not entity then
		return error(string.format("AnimatorDefender.new(%s) - no entity.", animator:GetFullName()))
	end

	local self = setmetatable(Defender.new(), AnimatorDefender)
	local animationPlayed = Signal.new(animator.AnimationPlayed)
	local entityDescendantAdded = Signal.new(entity.DescendantAdded)

	self.track = nil
	self.animator = animator
	self.entity = entity

	self.heffects = {}
	self.maid = Maid.new()

	self.maid:mark(entityDescendantAdded:connect("AnimatorDefender_OnDescendantAdded", function(descendant)
		if
			descendant.Name ~= "PunchBlood"
			and descendant.Name ~= "PunchEffect"
			and descendant.Name ~= "BloodSpray"
			and not (descendant:IsA("ParticleEmitter") and descendant.Texture == "rbxassetid://7216855595")
		then
			return
		end

		self.heffects[#self.heffects + 1] = descendant
	end))

	self.maid:mark(animationPlayed:connect("AnimatorDefender_OnAnimationPlayed", function(track)
		self:process(track)
	end))

	return self
end

-- Return AnimatorDefender module.
return AnimatorDefender
