local M = {}

-- Initializes the search command for developer searching
M.init_search = function()
	local Job = require("plenary.job")
	local error = require("config.util").error

	vim.api.nvim_create_user_command("DevSearch", function()
		-- TODO! How to deal with error when executable not found?

		Job
			:new({
				command = "dev-search",
				args = { vim.fn.input("Search query: ") },
				on_stderr = function(err, data)
					error("Error executing dev-search with message: " .. err)
				end,
				on_stdout = function(err, data)
					error("Error executing dev-search with message: " .. err)
				end,
			})
			:start()
	end, { desc = "Send a call to developer search to local default browser" })
end

return M
