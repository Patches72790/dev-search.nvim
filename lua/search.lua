local M = {}

-- Initializes the search command for developer searching
local init_search = function()
	local error = require("config.util").error
	local make_browser_request = require("util").make_browser_request

	if vim.fn.executable("dev-search") == 0 then
		error("executable dev-search doesn't exist")
		return
	end

	vim.api.nvim_create_user_command(
		"DevSearch",
		make_browser_request,
		{ desc = "Send a developer search request to default browser" }
	)

	--	vim.api.nvim_create_user_command("DevSearch", function()
	--		-- TODO! How to deal with error when executable not found?
	--
	--		Job
	--			:new({
	--				command = "dev-search",
	--				args = { vim.fn.input("Search query: ") },
	--				on_stderr = function(err, data)
	--					error("Error executing dev-search with message: " .. err)
	--				end,
	--				on_stdout = function(err, data)
	--					error("Error executing dev-search with message: " .. err)
	--				end,
	--			})
	--			:start()
	--	end, { desc = "Send a call to developer search to local default browser" })
end

M.setup = function()
	init_search()
end

return M
