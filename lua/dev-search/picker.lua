local M = {}

local entry_display = require("telescope.pickers.entry_display")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")

local make_search_result_entries = function()
	return {
		{ text = "test text", title = "Test Title 1", description = "Test description 1", url = "testurl.com" },
		{ text = "test text 2", title = "Test Title 2", description = "Test description 2", url = "testurl.com" },
		{ text = "test text 3", title = "Test Title 3", description = "Test description 3", url = "testurl.com" },
		{ text = "test text 4", title = "Test Title 4", description = "Test description 4", url = "testurl.com" },
	}
end

local gen_from_search_results = function(opts)
	local displayer = entry_display.create({
		separator = " | ",
		items = {
			{ width = 5 },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		return displayer({
			entry.title,
			entry.url,
		})
	end

	return function(entry)
		return make_entry.set_default_entry_mt({
			display = make_display,
			title = entry.title,
			description = entry.description,
		}, opts)
	end
end

M.search_picker = function(opts)
	-- TODO should be items results from search api call
	local search_results = make_search_result_entries()

	print(vim.inspect(search_results))
	pickers
		.new(opts, {
			prompt_title = "Search Api",
			finder = finders.new_table({
				results = search_results,
				entry_maker = gen_from_search_results(opts),
			}),
			sorter = conf.generic_sorter(opts),
			previewer = conf.grep_previewer(opts),
		})
		:find()
end

return M
