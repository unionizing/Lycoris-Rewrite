---@class DrawingWrapper
---@field object table Underlying drawing object
---Wrapper of drawing object & allows for the use of default properties.
local DrawingWrapper = {}
DrawingWrapper.__index = DrawingWrapper

-- Cached drawing fonts.
local drawingFonts = Drawing.Fonts

---Remove drawing from being rendered and delete itself.
function DrawingWrapper:remove()
	if self.object ~= nil then
		self.object:Remove()
	end

	self.object = nil
	self = nil
end

---Get drawing object.
---@param key string
---@return any
function DrawingWrapper:get(key)
	return self.object[key]
end

---Set font in drawing object.
---@param font string
function DrawingWrapper:font(font)
	self:set("Font", drawingFonts[font])
end

---Set key in drawing object.
---@param key string
---@param value any
function DrawingWrapper:set(key, value)
	self.object[key] = value
end

---Create new drawing object.
---@param data table
---@return DrawingWrapper
function DrawingWrapper.new(data)
	local self = setmetatable({}, DrawingWrapper)
	self.object = Drawing.new(data.type)
	self:set("Visible", data.visible ~= nil and data.visible or true)
	self:set("Transparency", data.transparency ~= nil and data.transparency or 1.0)
	self:set("Color", data.color ~= nil and data.color or Color3.new(0.0, 0.0, 0.0))
	return self
end

-- Return DrawingWrapper module.
return DrawingWrapper
