local constants = require("overseer.constants")
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local function get_workspace(opts)
	return vim.fs.find(
		{ "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE" },
		{ upward = true, type = "file", path = opts.dir }
	)[1]
end

---@return nil|string
local function get_component_path()
	local bufpath = vim.api.nvim_buf_get_name(0)
	if bufpath == "" then
		return nil
	end
	local build = vim.fs.find("BUILD.bazel", { upward = true, type = "file", path = vim.fs.dirname(bufpath) })[1]
	if not build then
		return nil
	end
	local workspace = vim.fs.find({ "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE" }, { upward = true, type = "file", path = vim.fs.dirname(build) })[1]
	if not workspace then
		return nil
	end
	local root = vim.fs.dirname(workspace)
	local rel = vim.fs.dirname(build):sub(#root + 2)
	return rel
end

local commands = {
	{ args = { "build", "//..." }, tags = { TAG.BUILD }, label = "build //..." },
	{ args = { "test", "//..." }, tags = { TAG.TEST }, label = "test //..." },
	{ args = { "clean" }, tags = { TAG.CLEAN }, label = "clean" },
	{ args = { "run", "//:format", "--" }, label = "format" },
}

return {
	cache_key = function(opts)
		return get_workspace(opts)
	end,
	generator = function(opts, cb)
		if vim.fn.executable("bazel") == 0 then
			return 'Command "bazel" not found'
		end
		local workspace = get_workspace(opts)
		if not workspace then
			return "No MODULE.bazel or WORKSPACE found"
		end
		local cwd = vim.fs.dirname(workspace)
		local ret = {}
		for _, command in ipairs(commands) do
			table.insert(ret, {
				name = string.format("bazel %s", command.label),
				tags = command.tags,
				builder = function()
					return {
						cmd = vim.list_extend({ "bazel" }, command.args),
						cwd = cwd,
					}
				end,
			})
		end

		local component = get_component_path()
		if component then
			table.insert(ret, {
				name = string.format("bazel build //%s", component),
				tags = { TAG.BUILD },
				builder = function()
					return {
						cmd = { "bazel", "build", string.format("//%s/...", component) },
						cwd = cwd,
					}
				end,
			})
			table.insert(ret, {
				name = string.format("bazel test //%s", component),
				tags = { TAG.TEST },
				builder = function()
					return {
						cmd = { "bazel", "test", string.format("//%s/...", component) },
						cwd = cwd,
					}
				end,
			})
			table.insert(ret, {
				name = string.format("setup java IDE //%s", component),
				builder = function()
					return {
						cmd = { "bazel", "run", "//tools/ide:setup_component", "--", component },
						cwd = cwd,
					}
				end,
			})
		end

		cb(ret)
	end,
}
