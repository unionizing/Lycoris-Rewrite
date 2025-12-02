---@class Action
local Action = getfenv().Action

---@module Modules.Globals.Mantra
local Mantra = getfenv().Mantra

---@class Signal
local Signal = getfenv().Signal

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	timing.ffh = true
	timing.pfh = true
	timing.fhb = true
	timing.rpue = false
	timing.duih = true
	timing.hitbox = Vector3.new(32, 32, 32)

	local action = Action.new()
	action._when = 200
	action._type = "Start Block"
	action.name = "Ice Carve Start"
	self:action(timing, action)

	local hrp = self.entity:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local humanoid = self.entity:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	repeat
		task.wait()
	until not self.track.IsPlaying

	local activeAnim = nil

	for _, animTrack in next, humanoid:GetPlayingAnimationTracks() do
		if animTrack.Animation.AnimationId ~= "rbxassetid://15714151635" then
			continue
		end

		activeAnim = animTrack
		break
	end

	if activeAnim then
		repeat
			task.wait()
		until not activeAnim.IsPlaying

		task.wait(0.7)
	end

	local actionEnd = Action.new()
	actionEnd._when = 0
	actionEnd._type = "End Block"
	actionEnd.ihbc = true
	actionEnd.name = "Ice Carve End"
	self:action(timing, actionEnd)
end
