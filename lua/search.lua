local M = {}

-- Initializes the search command for developer searching
local init_search = function()
	local error = require("config.util").error
	local make_browser_request = require("util").make_browser_request

	if vim.fn.executable("dev-search") == 0 then
		error("executable dev-search doesn't exist")
		return
	end

	local browser_request_fn = make_browser_request()

	if type(browser_request_fn) == "table" then
		error("Error creating browser request function: " .. browser_request_fn.message)
	end

	vim.api.nvim_create_user_command(
		"DevSearch",
		browser_request_fn,
		{ desc = "Send a developer search request to default browser" }
	)
end

M.setup = function()
	init_search()
end

return M
