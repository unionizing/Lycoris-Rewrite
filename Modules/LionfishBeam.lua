---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local charging = false

	timing.imb = true

	while task.wait() do
		local _, _, z = self.entity:GetPivot():ToOrientation()

		-- ok, so the first part of the beam is the charge. we must detect the peak in which he starts fully charging his beam.
		if not charging and z <= -1.7 then
			charging = true
		end

		-- if there is no charge, continue.
		if not charging then
			continue
		end

		-- after that, we must detect the release. his release is at around -0.9 so if we're below that, we can continue.
		if z <= -0.9 then
			continue
		end

		local root = self.entity:FindFirstChild("HumanoidRootPart")
		if not root then
			continue
		end

		local corrupted = root:FindFirstChild("Fog")
		local glacial = self.entity.Name:match("ice")

		local action = Action.new()
		action._when = 150
		action._type = "Forced Full Dodge"
		action.hitbox = Vector3.new(50, 100, 130)
		action.name = "Lionfish Beam Dodge"

		if glacial then
			action.name = "Glacial Lionfish Beam Dodge"
			action._when = 150
		elseif corrupted then
			action.name = "Corrupted Lionfish Beam Dodge"
			action._when = 150
		end

		return self:action(timing, action)
	end
end
