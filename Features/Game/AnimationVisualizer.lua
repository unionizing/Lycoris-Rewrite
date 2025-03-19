local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScreenGui"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local outer = Instance.new("Frame")
outer.Name = "Outer"
outer.BackgroundColor3 = Color3.new(1, 1, 1)
outer.Position = UDim2.new(0.27, 0, 0.216, 0)
outer.BorderColor3 = Color3.new()
outer.BorderSizePixel = 0
outer.Size = UDim2.new(0, 260, 0, 275)
outer.Parent = screenGui

local inner = Instance.new("Frame")
inner.Name = "Inner"
inner.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
inner.BorderMode = Enum.BorderMode.Inset
inner.BorderColor3 = Color3.new(0.196, 0.196, 0.196)
inner.BorderSizePixel = 2
inner.Size = UDim2.new(1, 0, 1.09, 2)
inner.Parent = outer

local animationVisualizer = Instance.new("TextLabel")
animationVisualizer.Name = "AnimationVisualizer"
animationVisualizer.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
animationVisualizer.TextColor3 = Color3.new(0.773, 0.0275, 0.329)
animationVisualizer.Text = "Animation Visualizer"
animationVisualizer.BackgroundColor3 = Color3.new()
animationVisualizer.BorderSizePixel = 0
animationVisualizer.BackgroundTransparency = 1
animationVisualizer.Position = UDim2.new(0, 5, 0, 5)
animationVisualizer.TextXAlignment = Enum.TextXAlignment.Left
animationVisualizer.BorderColor3 = Color3.new()
animationVisualizer.TextSize = 17
animationVisualizer.Size = UDim2.new(1, 0, 0, 20)
animationVisualizer.Parent = inner

local sliderOuter = Instance.new("Frame")
sliderOuter.Name = "SliderOuter"
sliderOuter.BackgroundColor3 = Color3.new(1, 1, 1)
sliderOuter.Position = UDim2.new(0.323, -78, 0.835, 24)
sliderOuter.BorderColor3 = Color3.new()
sliderOuter.BorderSizePixel = 0
sliderOuter.Size = UDim2.new(0, 247, 0, 15)
sliderOuter.Parent = inner

local sliderText = Instance.new("TextLabel")
sliderText.Name = "SliderText"
sliderText.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
sliderText.TextColor3 = Color3.new(1, 1, 1)
sliderText.Text = "2.500 / 5.000 (2500ms)"
sliderText.BackgroundTransparency = 1
sliderText.BackgroundColor3 = Color3.new(1, 1, 1)
sliderText.BorderSizePixel = 0
sliderText.BorderColor3 = Color3.new()
sliderText.TextSize = 12
sliderText.Size = UDim2.new(1, 0, 1, 0)
sliderText.Parent = sliderOuter

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.BorderMode = Enum.BorderMode.Inset
sliderFill.BorderColor3 = Color3.new(0.0706, 0.0706, 0.0706)
sliderFill.BackgroundColor3 = Color3.new(0.773, 0.0275, 0.329)
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.Parent = sliderOuter

local hideBorderRight = Instance.new("Frame")
hideBorderRight.Name = "HideBorderRight"
hideBorderRight.BackgroundColor3 = Color3.new(0.773, 0.0275, 0.329)
hideBorderRight.Position = UDim2.new(1, 0, 0, 0)
hideBorderRight.BorderColor3 = Color3.new()
hideBorderRight.BorderSizePixel = 0
hideBorderRight.Size = UDim2.new(0, 1, 1, 0)
hideBorderRight.Parent = sliderFill

local sliderInner = Instance.new("Frame")
sliderInner.Name = "SliderInner"
sliderInner.BorderColor3 = Color3.new(0.196, 0.196, 0.196)
sliderInner.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
sliderInner.Size = UDim2.new(1, 0, 1, 0)
sliderInner.Parent = sliderOuter

local frameBackwards = Instance.new("TextButton")
frameBackwards.Name = "FrameBackwards"
frameBackwards.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
frameBackwards.TextColor3 = Color3.new()
frameBackwards.Text = ""
frameBackwards.Position = UDim2.new(0.323, -78, 0.835, -2)
frameBackwards.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
frameBackwards.BorderColor3 = Color3.new(0.196, 0.196, 0.196)
frameBackwards.TextSize = 14
frameBackwards.Size = UDim2.new(0, 70, 0, 20)
frameBackwards.Parent = inner

local icon = Instance.new("ImageLabel")
icon.Name = "Icon"
icon.ScaleType = Enum.ScaleType.Crop
icon.BorderColor3 = Color3.new()
icon.BackgroundColor3 = Color3.new(1, 1, 1)
icon.Image = "rbxassetid://10734961526"
icon.BackgroundTransparency = 1
icon.Position = UDim2.new(0.5, -8, 0.5, -8)
icon.SizeConstraint = Enum.SizeConstraint.RelativeXX
icon.BorderSizePixel = 0
icon.Size = UDim2.new(0, 16, 0, 16)
icon.Parent = frameBackwards

local playStop = Instance.new("TextButton")
playStop.Name = "PlayStop"
playStop.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
playStop.TextColor3 = Color3.new()
playStop.BorderColor3 = Color3.new(0.196, 0.196, 0.196)
playStop.Text = ""
playStop.Position = UDim2.new(0.323, 0, 0.835, -2)
playStop.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
playStop.TextSize = 14
playStop.Size = UDim2.new(0, 91, 0, 20)
playStop.Parent = inner

local iconTwo = Instance.new("ImageLabel")
iconTwo.Name = "Icon"
iconTwo.BorderColor3 = Color3.new()
iconTwo.BackgroundColor3 = Color3.new(1, 1, 1)
iconTwo.Image = "rbxassetid://10734919336"
iconTwo.BackgroundTransparency = 1
iconTwo.Position = UDim2.new(0.5, -8, 0.5, -8)
iconTwo.SizeConstraint = Enum.SizeConstraint.RelativeXX
iconTwo.BorderSizePixel = 0
iconTwo.Size = UDim2.new(0, 16, 0, 16)
iconTwo.Parent = playStop

local viewportFrame = Instance.new("ViewportFrame")
viewportFrame.Name = "ViewportFrame"
viewportFrame.Visible = false
viewportFrame.BorderMode = Enum.BorderMode.Inset
viewportFrame.LightColor = Color3.new(0.549, 0.525, 0.435)
viewportFrame.Ambient = Color3.new(0.318, 0.318, 0.318)
viewportFrame.Position = UDim2.new(0, 4, 0, 26)
viewportFrame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
viewportFrame.BorderColor3 = Color3.new(0.196, 0.196, 0.196)
viewportFrame.Size = UDim2.new(1, -8, 0, 195)
viewportFrame.Parent = inner

local sliderTextTwo = Instance.new("TextLabel")
sliderTextTwo.Name = "SliderText"
sliderTextTwo.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
sliderTextTwo.TextColor3 = Color3.new(1, 1, 1)
sliderTextTwo.Text = "Speed (0.67)"
sliderTextTwo.BackgroundTransparency = 1
sliderTextTwo.BackgroundColor3 = Color3.new(1, 1, 1)
sliderTextTwo.BorderSizePixel = 0
sliderTextTwo.BorderColor3 = Color3.new()
sliderTextTwo.TextSize = 12
sliderTextTwo.Size = UDim2.new(0, 82, 0, 20)
sliderTextTwo.Parent = viewportFrame

local noViewportFrame = Instance.new("Frame")
noViewportFrame.Name = "NoViewportFrame"
noViewportFrame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
noViewportFrame.Position = UDim2.new(0, 4, 0, 26)
noViewportFrame.BorderColor3 = Color3.new(0.196, 0.196, 0.196)
noViewportFrame.BorderMode = Enum.BorderMode.Inset
noViewportFrame.Size = UDim2.new(1, -8, 0, 195)
noViewportFrame.Parent = inner

local textLabel = Instance.new("TextLabel")
textLabel.Name = "TextLabel"
textLabel.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.BorderColor3 = Color3.new()
textLabel.Text = "No Valid Playback Data"
textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
textLabel.BorderSizePixel = 0
textLabel.BackgroundTransparency = 1
textLabel.Position = UDim2.new(0.0968, 0, 0.369, 0)
textLabel.TextWrapped = true
textLabel.TextSize = 14
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.Parent = noViewportFrame

local color = Instance.new("Frame")
color.Name = "Color"
color.BackgroundColor3 = Color3.new(0.773, 0.0275, 0.329)
color.BorderColor3 = Color3.new()
color.BorderSizePixel = 0
color.Size = UDim2.new(1, 0, 0, 2)
color.Parent = inner

local frameForwards = Instance.new("TextButton")
frameForwards.Name = "FrameForwards"
frameForwards.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
frameForwards.TextColor3 = Color3.new()
frameForwards.Text = ""
frameForwards.Position = UDim2.new(0.323, 99, 0.835, -2)
frameForwards.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
frameForwards.BorderColor3 = Color3.new(0.196, 0.196, 0.196)
frameForwards.TextSize = 14
frameForwards.Size = UDim2.new(0, 69, 0, 20)
frameForwards.Parent = inner

local iconThree = Instance.new("ImageLabel")
iconThree.Name = "Icon"
iconThree.ScaleType = Enum.ScaleType.Crop
iconThree.BorderColor3 = Color3.new()
iconThree.BackgroundColor3 = Color3.new(1, 1, 1)
iconThree.Image = "rbxassetid://10734961809"
iconThree.BackgroundTransparency = 1
iconThree.Position = UDim2.new(0.5, -8, 0.5, -8)
iconThree.SizeConstraint = Enum.SizeConstraint.RelativeXX
iconThree.BorderSizePixel = 0
iconThree.Size = UDim2.new(0, 16, 0, 16)
iconThree.Parent = frameForwards

local animationTextbox = Instance.new("TextBox")
animationTextbox.Name = "AnimationTextbox"
animationTextbox.CursorPosition = -1
animationTextbox.TextColor3 = Color3.new(1, 1, 1)
animationTextbox.Text = "rbxassetid://0"
animationTextbox.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
animationTextbox.Position = UDim2.new(0.323, -78, 0.835, -24)
animationTextbox.BorderColor3 = Color3.new(0.196, 0.196, 0.196)
animationTextbox.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
animationTextbox.TextSize = 14
animationTextbox.Size = UDim2.new(0, 246, 0, 15)
animationTextbox.Parent = inner

--[[
    General positioning & scaling code would look like this for the camera

    local ViewportFrame = script.Parent.ViewportFrame
    local GiantDummy = ViewportFrame["Giant Dummy"]
    local HumanoidRootPart = GiantDummy["HumanoidRootPart"]

    local _, BoundingBoxSize = GiantDummy:GetBoundingBox()
    local Camera = Instance.new("Camera", ViewportFrame)
    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CFrame = CFrame.lookAt(HumanoidRootPart.Position - Vector3.new(0, 0, BoundingBoxSize.Magnitude), HumanoidRootPart.Position)

    ViewportFrame.CurrentCamera = Camera
]]
--
