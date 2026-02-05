local M = {}

M.config = {
	split = "auto", -- "vertical", "horizontal", "auto"
	keymap = "<leader>gl", -- set to nil to disable default keymap
	keys = {
		close = "q", -- set to nil to disable
		next_commit = "]c", -- set to nil to disable
		prev_commit = "[c", -- set to nil to disable
		yank_commit = "yc", -- set to nil to disable
		open_diff = "<CR>", -- set to nil to disable (requires diffview.nvim)
	},
}

local function is_git_repo()
	local result = vim.fn.systemlist({ "git", "rev-parse", "--is-inside-work-tree" })
	return vim.v.shell_error == 0 and result[1] == "true"
end

local function has_diffview()
	local ok, _ = pcall(require, "diffview")
	return ok
end

local function is_file_tracked(file)
	vim.fn.systemlist({ "git", "ls-files", "--error-unmatch", file })
	return vim.v.shell_error == 0
end

local function get_split_cmd()
	local split = M.config.split
	if split == "vertical" then
		return "botright vsplit"
	elseif split == "horizontal" then
		return "botright split"
	else -- auto
		local width = vim.api.nvim_win_get_width(0)
		local height = vim.api.nvim_win_get_height(0)
		if width > height * 2 then
			return "botright vsplit"
		else
			return "botright split"
		end
	end
end

function M.show_history()
	if not is_git_repo() then
		vim.notify("gitlineage: not inside a git repository", vim.log.levels.WARN)
		return
	end

	local file = vim.fn.expand("%:p")
	if file == "" then
		vim.notify("gitlineage: buffer has no file", vim.log.levels.WARN)
		return
	end

	-- Get relative path from git root for git log -L
	local git_root = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
	if vim.v.shell_error ~= 0 then
		vim.notify("gitlineage: failed to get git root", vim.log.levels.WARN)
		return
	end

	local rel_file = file:sub(#git_root + 2) -- +2 for the trailing slash
	if rel_file == "" then
		rel_file = vim.fn.expand("%")
	end

	if not is_file_tracked(rel_file) then
		vim.notify("gitlineage: file is not tracked by git", vim.log.levels.WARN)
		return
	end

	local l1 = vim.fn.getpos("v")[2]
	local l2 = vim.fn.getpos(".")[2]
	if l1 > l2 then
		l1, l2 = l2, l1
	end

	-- Validate line numbers
	if l1 < 1 or l2 < 1 then
		vim.notify("gitlineage: invalid line selection", vim.log.levels.WARN)
		return
	end

	local range_arg = l1 .. "," .. l2 .. ":" .. rel_file
	local output = vim.fn.systemlist({ "git", "log", "-L", range_arg })
	if vim.v.shell_error ~= 0 then
		vim.notify("gitlineage: git log -L failed", vim.log.levels.WARN)
		return
	end

	if #output == 0 then
		vim.notify("gitlineage: no history found for selection", vim.log.levels.INFO)
		return
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
	vim.bo[buf].modifiable = false
	vim.bo[buf].buflisted = false
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "git"
	vim.api.nvim_buf_set_name(buf, "gitlineage://" .. rel_file .. ":" .. l1 .. "-" .. l2)

	-- Buffer keymaps
	local keys = M.config.keys

	if keys.close then
		vim.keymap.set("n", keys.close, "<cmd>close<cr>", { buffer = buf, silent = true, desc = "Close" })
	end

	if keys.next_commit then
		vim.keymap.set("n", keys.next_commit, function()
			local found = vim.fn.search("^commit ", "W")
			if found == 0 then
				vim.notify("gitlineage: no more commits", vim.log.levels.INFO)
			end
		end, { buffer = buf, silent = true, desc = "Next commit" })
	end

	if keys.prev_commit then
		vim.keymap.set("n", keys.prev_commit, function()
			local found = vim.fn.search("^commit ", "bW")
			if found == 0 then
				vim.notify("gitlineage: already at first commit", vim.log.levels.INFO)
			end
		end, { buffer = buf, silent = true, desc = "Previous commit" })
	end

	if keys.yank_commit then
		vim.keymap.set("n", keys.yank_commit, function()
			local line = vim.api.nvim_get_current_line()
			local sha = line:match("^commit (%x+)")
			if sha then
				vim.fn.setreg('"', sha)
				vim.fn.setreg("+", sha)
				vim.notify("gitlineage: yanked " .. sha:sub(1, 8), vim.log.levels.INFO)
			else
				vim.notify("gitlineage: not on a commit line", vim.log.levels.WARN)
			end
		end, { buffer = buf, silent = true, desc = "Yank commit SHA" })
	end

	if keys.open_diff then
		vim.keymap.set("n", keys.open_diff, function()
			local line = vim.api.nvim_get_current_line()
			local sha = line:match("^commit (%x+)")
			if not sha then
				vim.notify("gitlineage: not on a commit line", vim.log.levels.WARN)
				return
			end
			if not has_diffview() then
				vim.notify(
					"gitlineage: diffview.nvim is required to view full diffs. "
						.. "Install from https://github.com/sindrets/diffview.nvim",
					vim.log.levels.WARN
				)
				return
			end
			-- Open diffview for this specific commit (SHA^! shows only that commit's changes)
			vim.cmd("DiffviewOpen " .. sha .. "^!")
		end, { buffer = buf, silent = true, desc = "Open commit diff (requires diffview.nvim)" })
	end

	vim.cmd(get_split_cmd())
	vim.api.nvim_win_set_buf(0, buf)
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	if M.config.keymap then
		vim.keymap.set("v", M.config.keymap, function()
			M.show_history()
		end, { desc = "Git history for selected lines" })
	end
end

return M
