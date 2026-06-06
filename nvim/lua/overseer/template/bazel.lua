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
		cb(ret)
	end,
}
