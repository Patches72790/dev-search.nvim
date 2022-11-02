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
	return base_url .. "/cse?cx=" .. context_id
end

local build_api_search_url = function(search_table)
	local context_id = search_table["context_id"]
	local rest_api_url = search_table["rest_api_url"]
	local api_key = search_table["api_key"]

	return rest_api_url .. "key=" .. api_key .. "&cx=" .. context_id
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
		Job:new({
			command = url_command,
			args = { url .. query },
			on_stderr = function(_)
				error("Error executing dev-search")
			end,
			on_stdout = function(_)
				error("Error executing dev-search")
			end,
		}):start()
	end
end

M.make_search_api_request = function(search_table)
	local api_url = build_api_search_url(search_table)

	return function()
		local query_input = "&q=" .. vim.fn.input("Dev search api query: ")
		local url = api_url .. query_input
		print(url)
		local result = require("plenary.curl").get(url)
		local json = vim.json.decode(result["body"])
		print(vim.inspect(json["items"][1]))
	end
end

return M
