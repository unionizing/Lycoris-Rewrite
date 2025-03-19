return LPH_NO_VIRTUALIZE(function()
	-- Safe configuration getter methods.
	-- The menu is the last thing initialized in the script.
	local Configuration = {}

	---Expect toggle value.
	---@param key string
	---@return any?
	function Configuration.expectToggleValue(key)
		if not Toggles then
			return nil
		end

		local toggle = Toggles[key]

		if not toggle then
			return nil
		end

		return toggle.Value
	end

	---Expect option value.
	---@param key string
	---@return any?
	function Configuration.expectOptionValue(key)
		if not Options then
			return nil
		end

		local option = Options[key]

		if not option then
			return nil
		end

		return option.Value
	end

	---Identify element.
	---@param identifier string
	---@param topLevelIdentifier string
	---@return string
	function Configuration.identify(identifier, topLevelIdentifier)
		return identifier .. topLevelIdentifier
	end

	---Fetch toggle value.
	---@param identifier string
	---@param topLevelIdentifier string
	---@return any
	function Configuration.idToggleValue(identifier, topLevelIdentifier)
		if not Toggles then
			return nil
		end

		local toggle = Toggles[identifier .. topLevelIdentifier]
		if not toggle then
			return nil
		end

		return toggle.Value
	end

	---Fetch option value.
	---@param identifier string
	---@param topLevelIdentifier string
	---@return any
	function Configuration.idOptionValue(identifier, topLevelIdentifier)
		if not Options then
			return nil
		end

		local option = Options[identifier .. topLevelIdentifier]
		if not option then
			return nil
		end

		return option.Value
	end

	---Fetch option values.
	---@param identifier string
	---@param topLevelIdentifier string
	---@return any
	function Configuration.idOptionValues(identifier, topLevelIdentifier)
		if not Options then
			return nil
		end

		local option = Options[identifier .. topLevelIdentifier]
		if not option then
			return nil
		end

		return option.Values
	end

	-- Return Configuration module.
	return Configuration
end)()
