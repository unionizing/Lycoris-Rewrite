-- Timestamp.
local lastIceHeroTimestamp = nil

---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	if self:distance(self.entity) > 80 then
		return
	end

	if lastIceHeroTimestamp and os.clock() - lastIceHeroTimestamp <= 1.0 then
		return
	end

	self:hook("target", function()
		return true
	end)

	lastIceHeroTimestamp = os.clock()

	timing.fhb = false

	local action = Action.new()
	action._when = 500
	action._type = "Parry"
	action.hitbox = Vector3.new(50, 50, 50)
	action.name = "Ice Hero Blade Parry (1)"
	self:action(timing, action)

	local actionTwo = Action.new()
	actionTwo._when = 1000
	actionTwo._type = "Parry"
	action.hitbox = Vector3.new(50, 50, 50)
	action.name = "Ice Hero Blade Parry (2)"
	self:action(timing, actionTwo)

	local actionThree = Action.new()
	actionThree._when = 1500
	actionThree._type = "Parry"
	action.hitbox = Vector3.new(50, 50, 50)
	action.name = "Ice Hero Blade Parry (3)"
	self:action(timing, actionThree)

	local actionFour = Action.new()
	actionFour._when = 2000
	actionFour._type = "Parry"
	action.hitbox = Vector3.new(50, 50, 50)
	action.name = "Ice Hero Blade Parry (4)"
	self:action(timing, actionFour)
end
