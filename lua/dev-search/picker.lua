local M = {}

local entry_display = require("telescope.pickers.entry_display")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")
local buffer_previewer = require("telescope.previewers").new_buffer_previewer
local action_state = require("telescope.actions.state")
local open_link_in_browser = require("dev-search.util").open_link_in_browser

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
			{ width = 20 },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		-- apply additional displays here
		return displayer({
			{ entry.value, "TelescopeResultsLineNr" },
			{ entry.prettyLink, "TelescopeResultsIdentifier" },
			entry.title,
		})
	end

	return function(entry)
		-- value, ordinal and display are all required
		-- the rest are defined as additional entries for your data type
		return make_entry.set_default_entry_mt({
			display = make_display,
			value = entry.value,
			ordinal = entry.value,
			title = entry.title,
			snippet = entry.snippet,
			prettyLink = entry.prettyLink,
			searchLink = entry.searchLink,
		})
	end
end

local function make_search_previewer(opts)
	-- add some text from search entry to buffer in previewer...
	return buffer_previewer({
		define_preview = function(self, entry, _)
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, false, {
				entry.snippet,
			})
		end,
		title = "Dev Search API Preview",
	})
end

local enter = function(_)
	-- open link of selected entry in browser...
	local entry = action_state.get_selected_entry()
	print("in do search entry")
	print(vim.inspect(entry))
	open_link_in_browser(entry.searchLink)()
end

local response_mapper = function()
	local count = 1
	return function(entry)
		return {
			value = (function()
				count = count + 1
				return count - 1
			end)(),
			title = entry.title,
			prettyLink = entry.displayLink,
			snippet = entry.snippet,
			searchLink = entry.link,
		}
	end
end

M.search_picker = function(opts)
	local search_response = opts.search_fn()
	local mapped_search_results = vim.tbl_map(response_mapper(), search_response["items"])

	pickers
		.new({
			prompt_title = "Dev Search Api",
			finder = finders.new_table({
				results = mapped_search_results,
				entry_maker = gen_from_search_results(opts),
			}),
			sorter = sorters.get_generic_fuzzy_sorter(opts),
			previewer = make_search_previewer(opts),
			attach_mappings = function(prompt_bufnr, map)
				map("i", "<CR>", enter)
				return true
			end,
		})
		:find()
end

return M
