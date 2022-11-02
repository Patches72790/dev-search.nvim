local M = {}

local init_settings = require("dev-search.settings").initialize_settings
local init_search = require("dev-search.search").init_search

--[[
    Provide a search object of the form
    search {
        base_url = "https://google.com",
        context_id = "cx_id_string",
        api_key = "secret_api_key_string",
        rest_api_url = "https://www.googleapis.com/customsearch/v1?"
    }
--]]
M.setup = function(search_table)
	init_settings(search_table.settings)
	init_search()
end

return M
