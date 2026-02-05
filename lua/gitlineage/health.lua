local M = {}

local health = vim.health

M.check = function()
	health.start("gitlineage.nvim")

	-- Check Neovim version
	if vim.fn.has("nvim-0.7.0") == 1 then
		health.ok("Neovim >= 0.7.0")
	else
		health.error("Neovim >= 0.7.0 required")
	end

	-- Check git is available
	local git_version = vim.fn.systemlist({ "git", "--version" })
	if vim.v.shell_error == 0 and git_version[1] then
		health.ok("git found: " .. git_version[1])
	else
		health.error("git not found in PATH")
	end

	-- Check if current directory is a git repo
	local in_repo = vim.fn.systemlist({ "git", "rev-parse", "--is-inside-work-tree" })
	if vim.v.shell_error == 0 and in_repo[1] == "true" then
		health.ok("Current directory is a git repository")
	else
		health.info("Current directory is not a git repository (gitlineage only works in git repos)")
	end

	-- Check optional dependency: diffview.nvim
	local has_diffview, _ = pcall(require, "diffview")
	if has_diffview then
		health.ok("diffview.nvim found (open_diff feature available)")
	else
		health.info("diffview.nvim not found (open_diff feature disabled)")
		health.info("  Install from: https://github.com/sindrets/diffview.nvim")
	end

	-- Check configuration
	local ok, gitlineage = pcall(require, "gitlineage")
	if ok then
		health.ok("gitlineage loaded")
		health.info("split: " .. gitlineage.config.split)
		health.info("keymap: " .. (gitlineage.config.keymap or "disabled"))
		health.info("keys.close: " .. (gitlineage.config.keys.close or "disabled"))
		health.info("keys.next_commit: " .. (gitlineage.config.keys.next_commit or "disabled"))
		health.info("keys.prev_commit: " .. (gitlineage.config.keys.prev_commit or "disabled"))
		health.info("keys.yank_commit: " .. (gitlineage.config.keys.yank_commit or "disabled"))
		health.info("keys.open_diff: " .. (gitlineage.config.keys.open_diff or "disabled"))
	else
		health.error("Failed to load gitlineage module")
	end
end

return M
