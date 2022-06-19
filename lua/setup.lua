local M = {}

local init_search = require("search").init_search

M.setup = function()
	init_search()
end

return M
