-- PlayerTab module.
local PlayerTab = {}

---Initialize movement section.
---@param groupbox table
function PlayerTab.initMovementSection(groupbox)
	local atbDepBox = groupbox:AddDependencyBox()
	local speedDepBox = groupbox:AddDependencyBox()
	local flyDepBox = groupbox:AddDependencyBox()
	local noclipDepBox = groupbox:AddDependencyBox()
	local infiniteJumpDepBox = groupbox:AddDependencyBox()
	local agilitySpoofDepBox = groupbox:AddDependencyBox()

	groupbox
		:AddToggle("Speedhack", {
			Text = "Speedhack",
			Tooltip = "Modify your character's velocity while moving.",
			Default = false,
		})
		:AddKeyPicker("SpeedhackKeybind", { Default = "X", SyncToggleState = true, Text = "Speedhack" })

	speedDepBox:AddSlider("SpeedhackSpeed", {
		Text = "Speedhack Speed",
		Default = 200,
		Min = 0,
		Max = 300,
		Suffix = "studs/s",
		Rounding = 0,
	})

	groupbox
		:AddToggle("Fly", {
			Text = "Fly",
			Tooltip = "Set your character's velocity while moving to imitate flying.",
			Default = false,
		})
		:AddKeyPicker("FlyKeybind", { Default = "CapsLock", SyncToggleState = true, Text = "Fly" })

	flyDepBox:AddSlider("FlySpeed", {
		Text = "Fly Speed",
		Default = 200,
		Min = 0,
		Max = 300,
		Suffix = "studs/s",
		Rounding = 0,
	})

	flyDepBox:AddSlider("FlyUpSpeed", {
		Text = "Spacebar Fly Speed",
		Default = 150,
		Min = 0,
		Max = 300,
		Suffix = "studs/s",
		Rounding = 0,
	})

	groupbox
		:AddToggle("NoClip", {
			Text = "NoClip",
			Tooltip = "Disable collision(s) for your character.",
			Default = false,
		})
		:AddKeyPicker("NoClipKeybind", { Default = "CapsLock", SyncToggleState = true, Text = "NoClip" })

	noclipDepBox:AddToggle("NoClipCollisionsKnocked", {
		Text = "Collisions While Knocked",
		Tooltip = "Enable collisions while knocked.",
		Default = false,
	})

	groupbox
		:AddToggle("AttachToBack", {
			Text = "Attach To Back",
			Tooltip = "Start following the nearest entity based on a distance and height offset.",
			Default = false,
		})
		:AddKeyPicker("AttachToBackKeybind", { Default = "[", SyncToggleState = true, Text = "Attach To Back" })

	groupbox:AddToggle("InfiniteJump", {
		Text = "Infinite Jump",
		Tooltip = "Boost your velocity while the jump key is held.",
		Default = false,
	})

	infiniteJumpDepBox:AddSlider("InfiniteJumpBoost", {
		Text = "Infinite Jump Boost",
		Default = 50,
		Min = 0,
		Max = 500,
		Suffix = "studs/s",
		Rounding = 0,
	})

	atbDepBox:AddSlider("BackOffset", {
		Text = "Distance To Entity",
		Default = 5,
		Min = -30,
		Max = 30,
		Suffix = "studs",
		Rounding = 0,
	})

	atbDepBox:AddSlider("HeightOffset", {
		Text = "Height Offset",
		Default = 0,
		Min = -30,
		Max = 30,
		Suffix = "studs",
		Rounding = 0,
	})

	groupbox:AddToggle("AgilitySpoof", {
		Text = "Agility Spoofer",
		Tooltip = "Set your Agility investment points to boost movement realistically.",
		Default = false,
	})

	agilitySpoofDepBox:AddSlider("AgilitySpoof", {
		Text = "Agility Value",
		Default = 0,
		Min = 0,
		Max = 200,
		Suffix = "pts",
		Rounding = 0,
	})

	groupbox
		:AddToggle("TweenToObjectives", {
			Text = "Tween To Objectives",
			Tooltip = "Smoothly move to objectives inside of Ethiron and Chaser's boss fights.",
			Default = false,
		})
		:AddKeyPicker(
			"TweenToObjectivesKeybind",
			{ Default = "V", SyncToggleState = true, Text = "Tween To Objectives" }
		)

	groupbox:AddToggle("AutoSprint", {
		Text = "Auto Sprint",
		Tooltip = "Instantly invoke a sprint when pressing a key in any direction.",
		Default = false,
	})

	---@todo: Add removals section.
	---@todo: After, add ESP.

	infiniteJumpDepBox:SetupDependencies({
		{ Toggles.InfiniteJump, true },
	})

	speedDepBox:SetupDependencies({
		{ Toggles.Speedhack, true },
	})

	flyDepBox:SetupDependencies({
		{ Toggles.Fly, true },
	})

	noclipDepBox:SetupDependencies({
		{ Toggles.NoClip, true },
	})

	atbDepBox:SetupDependencies({
		{ Toggles.AttachToBack, true },
	})
end

---Initialize tab.
function PlayerTab.init(window)
	-- Create tab.
	local tab = window:AddTab("Player")

	-- Initialize sections.
	PlayerTab.initMovementSection(tab:AddLeftGroupbox("Movement"))
end

-- Return PlayerTab module.
return PlayerTab
