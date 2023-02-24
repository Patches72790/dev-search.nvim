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

M.open_link_in_browser = function(link)
	local url_command = find_open_url_command()
	return function()
		Job:new({
			command = url_command,
			args = { link },
			on_stderr = function(_)
				error("Error executing dev-search")
			end,
			on_stdout = function(_)
				error("Error executing dev-search")
			end,
		}):start()
	end
end

local function encodeURI(str)
	local encodingsMap = {
		[" "] = "%20",
		["\t"] = "%09",
		["\n"] = "%A",
	}
	-- TODO => implement encoding
	return str
end

local function get_encoded_query_input()
	-- this requires re-architecting some of my code
	-- to work with this ui input callback
	-- the gain is that we can use a pretty vim ui instead of command line search
	vim.ui.input({
		prompt = "Dev search api query: ",
	}, function(input)
		return input
	end)
end

M.make_search_api_request = function(search_table)
	local api_url = build_api_search_url(search_table)

	return function()
		local query_input = "&q=" .. vim.fn.input("Dev search api query: ")
		local encodedQuery = encodeURI(query_input)
		local url = api_url .. encodedQuery
		print(url)
		local result = require("plenary.curl").get(url)
		local json = vim.json.decode(result["body"])
		return json
	end
end

return M
