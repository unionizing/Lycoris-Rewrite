---@type Action
local Action = getfenv().Action

-- Services.
local players = game:GetService("Players")

---Module function.
---@param self PartDefender
---@param timing PartTiming
return function(self, timing)
	local humanoid = players.LocalPlayer
		and players.LocalPlayer.Character
		and players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	for _, track in next, humanoid:GetPlayingAnimationTracks() do
		if track.Animation.AnimationId == "rbxassetid://7585268054" then
			return
		end
	end

	repeat
		task.wait()
	until not self.part.Parent or self:distance(self.part) < 20

	local firstAction = Action.new()
	firstAction._when = 100
	firstAction._type = "Start Block"
	firstAction.name = "Tornado Start Block Timing"
	self:action(timing, firstAction)

	local secondAction = Action.new()
	secondAction._when = 4200
	secondAction._type = "End Block"
	secondAction.name = "Tornado End Block Timing"
	return self:action(timing, secondAction)
end
