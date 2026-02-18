---@type Action
local Action = getfenv().Action

-- Services.
local players = game:GetService("Players")

---Module function.
---@param self EffectDefender
---@param timing EffectTiming
return function(self, timing)
    local selfCharacter = players.LocalPlayer.Character;
	if self.owner ~= selfCharacter then
		return
	end


    local effectData = self.data;

    local telegraphType = effectData.telegraph;
    local part = effectData.part;

    if part and part:IsDescendantOf(selfCharacter) and part.Name == "HumanoidRootPart" then --Weapon Manual Telegraph (caster: self.character & part: hrp)
        local dur = effectData.dur; --note: if you are working on this module, the real game code has a or 0.5 here, but it's not needed for weapon manual.
        if dur ~= 1 then
            return;
        end

        if not table.find({
            "dodge_only",
            "block_only",
            "parry_only"
        }, telegraphType) then return; end
        
	    self:hook("target", function(_)
	    	return true
	    end)

	    local action = Action.new()
	    action._when = 950 -- it is 1s but we do want to parry earlier due to the fact the user might not have 'Ping Compensation' on.
	    action._type = telegraphType == "dodge_only" and "Dodge" or "Parry"
	    action.ihbc = true
	    action.name = "Dynamic Weapon Manual Timing"       
        
        return self:action(timing, action)
    end

	return;
end
