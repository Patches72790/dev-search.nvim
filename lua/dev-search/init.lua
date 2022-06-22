local M = {}

local init_search = require("search").init_search

--
-- Provide a search object of the form
-- search {
-- base_url = "https://google.com"
-- context_id = "12345"
-- }
M.setup = function(search_table)
	init_search(search_table.settings)
end

return M
