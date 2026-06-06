local constants = require("overseer.constants")
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local function get_build_sbt(opts)
	return vim.fs.find("build.sbt", { upward = true, type = "file", path = opts.dir })[1]
end

local commands = {
	{ args = { "compile" }, tags = { TAG.BUILD }, label = "compile" },
	{ args = { "test" }, tags = { TAG.TEST }, label = "test" },
	{ args = { "clean" }, tags = { TAG.CLEAN }, label = "clean" },
	{ args = { "verify" }, label = "verify" },
	{ args = { "scalafmtAll" }, label = "scalafmtAll" },
	{ args = { "scalafmtCheckAll" }, label = "scalafmtCheckAll" },
	{ args = { "publish" }, label = "publish" },
	{ args = { "publishLocal" }, label = "publishLocal" },
}

return {
	cache_key = function(opts)
		return get_build_sbt(opts)
	end,
	generator = function(opts, cb)
		if vim.fn.executable("sbt") == 0 then
			return 'Command "sbt" not found'
		end
		local build_sbt = get_build_sbt(opts)
		if not build_sbt then
			return "No build.sbt found"
		end
		local cwd = vim.fs.dirname(build_sbt)
		local ret = {}
		for _, command in ipairs(commands) do
			table.insert(ret, {
				name = string.format("sbt %s", command.label),
				tags = command.tags,
				builder = function()
					return {
						cmd = vim.list_extend({ "sbt" }, command.args),
						cwd = cwd,
					}
				end,
			})
		end
		cb(ret)
	end,
}
