local Buffer = {}

---@param cframe CFrame
local function makeNetworkable(cframe)
	local position = cframe.Position
	local axis, angle = cframe:ToAxisAngle()

	local halfAngle = angle * 0.5
	local sinHalf = math.sin(halfAngle)

	local x = axis.X * sinHalf
	local y = axis.Y * sinHalf
	local z = axis.Z * sinHalf

	return {
		Position = position,
		Rotation = { x = x, y = y, z = z },
	}
end

---@param cframe CFrame
local function makeYawNet(cframe)
	local _, yaw, _ = cframe:ToEulerAnglesYXZ()
	return {
		Position = cframe.Position,
		RotationY = yaw,
	}
end

---@param snapshotBuffer buffer
---@param offset number
---@param timestamp number
---@param cframe CFrame
---@param id number
local function packSnapshot(snapshotBuffer, offset, timestamp, cframe, id)
	buffer.writef32(snapshotBuffer, offset + 0, timestamp)
	buffer.writef32(snapshotBuffer, offset + 4, cframe.Position.X)
	buffer.writef32(snapshotBuffer, offset + 8, cframe.Position.Y)
	buffer.writef32(snapshotBuffer, offset + 12, cframe.Position.Z)

	if false then
		local networkable = makeNetworkable(cframe)

		local mappedX = math.map(networkable.Rotation.x, -1, 1, 0, 2 ^ 16 - 1)
		local mappedY = math.map(networkable.Rotation.y, -1, 1, 0, 2 ^ 16 - 1)
		local mappedZ = math.map(networkable.Rotation.z, -1, 1, 0, 2 ^ 16 - 1)

		buffer.writeu16(snapshotBuffer, offset + 16, mappedX)
		buffer.writeu16(snapshotBuffer, offset + 18, mappedY)
		buffer.writeu16(snapshotBuffer, offset + 20, mappedZ)
		buffer.writeu16(snapshotBuffer, offset + 22, id)
	else
		local networkable = makeYawNet(cframe)
		local mappedRotationY = math.map(networkable.RotationY, -math.pi, math.pi, 0, 2 ^ 16 - 1)
		buffer.writeu16(snapshotBuffer, offset + 16, mappedRotationY)
		buffer.writeu16(snapshotBuffer, offset + 18, id)
	end
end

---@param targetCFrame CFrame
---@return buffer
function Buffer.GetBufferCFrame(targetCFrame)
	local offset = 0
	local snapshotBuffer = packSnapshot(buffer.create(20), offset, os.clock(), targetCFrame, math.random(0, 25555))
	offset = offset + 20

	return snapshotBuffer
end

return Buffer