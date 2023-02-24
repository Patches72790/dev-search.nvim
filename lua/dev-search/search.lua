local M = {}

-- Initializes the search command for developer searching
-- Args:
--  search_table is a table with base url and context id
--
--  Returns nothing, only creates user command for dev search
M.init_search = function()
	local make_browser_request = require("dev-search.util").make_browser_request
	local make_search_api_request = require("dev-search.util").make_search_api_request
	local search_picker = require("dev-search.picker").search_picker

	local search_settings = require("dev-search.settings").get_search_settings()
	local browser_request_fn = make_browser_request(search_settings)
	local search_api_request_fn = make_search_api_request(search_settings)

	if type(browser_request_fn) == "table" then
		vim.api.nvim_notify(
			"Error creating browser request function: " .. browser_request_fn.message,
			vim.log.levels.ERROR
		)
	end

	vim.api.nvim_create_user_command(
		"DevSearch",
		browser_request_fn,
		{ desc = "Send a developer search request to default browser" }
	)

	vim.api.nvim_create_user_command(
		"DevSearchApi",
		search_api_request_fn,
		{ desc = "Make a request to the developer search API" }
	)

	vim.api.nvim_create_user_command("TelescopeDevSearch", function()
		search_picker({
			search_fn = search_api_request_fn,
		})
	end, { desc = "Search api results with telescope" })
end

return M
