local M = {}

local Job = require("plenary.job")

M.make_browser_request = function()
	local url = "https://cse.google.com/cse?cx=c897a4eacb3fd1332"
	local query = "&q=" .. vim.fn.input("Dev search query: ")

	Job
		:new({
			command = "open " .. url .. query,
			on_stderr = function(err)
				error("Error executing dev-search with message: " .. err)
			end,
			on_stdout = function(err)
				error("Error executing dev-search with message: " .. err)
			end,
		})
		:start()
end

return M
