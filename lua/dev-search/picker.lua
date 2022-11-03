local M = {}

local pickers = require("telescope.picker")
local previewers = require("telescope.previewers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local conf = require("telescope.config").values

M.search_picker = function(opts)
	local search_finder = finders.new_job(function(prompt)
		if not prompt or prompt == "" then
			return nil
		end
	end)
	pickers.new(opts, {
		prompt_title = "Search Api",
		finder = finders.new_table({ results = search_results }),
	})
end

return M
