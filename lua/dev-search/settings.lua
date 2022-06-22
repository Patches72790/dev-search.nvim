local M = {}

local search_settings = {}

M.initialize_settings = function(new_settings)
	search_settings = new_settings
end

M.get_search_settings = function()
	return search_settings
end

return M
