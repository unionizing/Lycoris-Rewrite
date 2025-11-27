---@type Action
local Action = getfenv().Action

---Module function.
---@param self PartDefender
---@param timing PartTiming
return function(self, timing)
	-- Glacial Arc starts creating new parts that are ordered least to smallest
	local model = self.part.Parent
	if not model then
		return
	end

	if #model:GetChildren() <= 2 then
		return
	end

	if self:distance(self.part) >= 15 then
		return
	end

	local action = Action.new()
	action._when = 0
	action._type = "Start Block"
	action.ihbc = true
	action.name = "Dynamic Glacial Arc Timing"
	self:action(timing, action)

	local actionEnd = Action.new()
	actionEnd._when = 300
	actionEnd._type = "End Block"
	actionEnd.ihbc = true
	actionEnd.name = "Dynamic Glacial Arc End Timing"
	return self:action(timing, actionEnd)
end
