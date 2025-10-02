---@type Action
local Action = getfenv().Action

-- Services.
local players = game:GetService("Players")

---Module function.
---@param self EffectDefender
---@param timing EffectTiming
return function(self, timing)
	if self.owner ~= players.LocalPlayer.Character then
		return
	end

	self:hook("target", function(_)
		return true
	end)

	local action = Action.new()
	action._when = (self.data.Time - self.data.Window) * 1000
	action._type = "Parry"
	action.ihbc = true
	action.name = "Dynamic Display Thorns Timing"
	return self:action(timing, action)
end
