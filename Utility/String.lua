local String = {}

-- Generate mapping.
local charByteMap = {}

for idx = 0, 255 do
	charByteMap[string.char(idx)] = idx
end

---String to byte array.
---@param str string
---@return table
function String.tba(str)
	local chars = {}
	local idx = 1

	if #str == 0 then
		return {}
	end

	repeat
		chars[idx] = charByteMap[str:sub(idx, idx)]
		idx = idx + 1
	until idx == #str + 1

	return chars
end

-- Return String module.
return String
