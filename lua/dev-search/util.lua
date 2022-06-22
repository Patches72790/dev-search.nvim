local M = {}

local Job = require("plenary.job")

local find_open_url_command = function()
	if vim.fn.has("mac") == 1 then
		return "open"
	elseif vim.fn.has("linux") == 1 then
		return "xdg-open"
	elseif vim.fn.has("win64") ~= 0 then
		return "start"
	else
		return nil
	end
end

local build_search_url = function(search_table)
	local base_url = search_table["base_url"]
	local context_id = search_table["context_id"]
	if not base_url or not context_id then
		return "https://google.com/"
	end
	return base_url .. "/cse?cx=" .. context_id --https://cse.google.com/cse?cx=c897a4eacb3fd1332"
end

M.make_browser_request = function(search_table)
	local url = build_search_url(search_table)
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
