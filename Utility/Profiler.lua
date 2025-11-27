return LPH_NO_VIRTUALIZE(function()
	-- Profile code time.
	-- Determine what parts of our script are lagging us through the microprofiler.
	local Profiler = {}

	---Runs a function with a specified profiler label.
	---@todo: This breaks on yielding functions.
	---@param label string
	---@param functionToProfile function
	function Profiler.run(label, functionToProfile, ...)
		local okay = shared and typeof(shared.Lycoris) == "table" and not shared.Lycoris.silent

		-- Profile under label.
		if okay then
			debug.profilebegin(label)
		end

		-- Call function to profile.
		local ret_values = table.pack(functionToProfile(...))

		-- End most recent profiling.
		if okay then
			debug.profileend()
		end

		-- Return values.
		return unpack(ret_values)
	end

	---Wrap function in a profiler statement with label.
	---@param label string
	---@param functionToProfile function
	---@return function
	function Profiler.wrap(label, functionToProfile)
		return function(...)
			return Profiler.run(label, functionToProfile, ...)
		end
	end

	-- Return profiler module.
	return Profiler
end)()
