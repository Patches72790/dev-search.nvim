local M = {}

local Job = require("plenary.job")

local find_open_url_command = function()
	if vim.fn.has("mac") == 0 then
		return "open"
	elseif vim.fn.has("linux") == 0 then
		return "xdg-open"
	elseif vim.fn.has("win64") ~= 0 then
		return "start"
	else
		return nil
	end
end

M.make_browser_request = function()
	local url = "https://cse.google.com/cse?cx=c897a4eacb3fd1332"

	local url_command = find_open_url_command()

	if url_command == nil then
		return {
			error = true,
			message = "Error finding open url os command",
		}
	end

	return function()
		local query = "&q=" .. vim.fn.input("Dev search query: ")
		Job
			:new({
				command = url_command,
				args = { url .. query },
				on_stderr = function(err)
					error("Error executing dev-search with message: " .. err)
				end,
				on_stdout = function(err)
					error("Error executing dev-search with message: " .. err)
				end,
			})
			:start()
	end
end

return M
