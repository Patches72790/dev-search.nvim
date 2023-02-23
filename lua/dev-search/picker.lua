local M = {}

local entry_display = require("telescope.pickers.entry_display")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")
local buffer_previewer = require("telescope.previewers").new_buffer_previewer

local make_search_result_entries = function()
	return {
		{
			value = 1,
			text = "test text",
			title = "Test Title 1",
			description = "Test description 1",
			url = "testurl.com",
		},
		{
			value = 2,
			text = "test text 2",
			title = "Test Title 2",
			description = "Test description 2",
			url = "testurl.com",
		},
		{
			value = 3,
			text = "test text 3",
			title = "Test Title 3",
			description = "Test description 3",
			url = "testurl.com",
		},
		{
			value = 4,
			text = "test text 4",
			title = "Test Title 4",
			description = "Test description 4",
			url = "testurl.com",
		},
	}
end

local gen_from_search_results = function(opts)
	-- this defines your column layout, each width table a column
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 2 },
			{ width = 15 },
			{ width = 25 },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		-- apply additional displays here
		return displayer({
			{ entry.value, "TelescopeResultsLineNr" },
			{ entry.ordinal, "TelescopeResultsIdentifier" },
			entry.description,
			entry.url,
		})
	end

	return function(entry)
		-- value, ordinal and display are all required
		-- the rest are defined as additional entries
		return make_entry.set_default_entry_mt({
			value = entry.value,
			ordinal = entry.title,
			display = make_display,
			url = entry.url,
			description = entry.description,
		})
	end
end

M.search_picker = function(opts)
	-- TODO should be items results from search api call
	local search_results = make_search_result_entries()

	local previewer = buffer_previewer({
		define_preview = function(self, entry, status)
			--print(vim.inspect(entry))
			return entry
		end,
		title = "Dev Search API Preview",
	})
	pickers
		.new({
			prompt_title = "Dev Search Api",
			finder = finders.new_table({
				results = search_results,
				entry_maker = gen_from_search_results(opts),
			}),
			sorter = sorters.get_generic_fuzzy_sorter(opts),
			previewer = previewer,
		})
		:find()
end

return M
