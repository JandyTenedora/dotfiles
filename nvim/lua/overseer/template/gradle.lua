local overseer = require("overseer")
local constants = require("overseer.constants")
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local function get_gradlew(opts)
	return vim.fs.find("gradlew", { upward = true, type = "file", path = opts.dir })[1]
end

local commands = {
	{ args = { "build", "-x", "test", "-x", "integrationTest" }, tags = { TAG.BUILD }, label = "build (no tests)" },
	{ args = { "build" }, tags = { TAG.BUILD }, label = "build" },
	{ args = { "test" }, tags = { TAG.TEST }, label = "test" },
	{ args = { "clean" }, tags = { TAG.CLEAN }, label = "clean" },
	{ args = { "spotlessApply" }, label = "spotlessApply" },
	{ args = { "classes" }, tags = { TAG.BUILD }, label = "classes" },
	{ args = { "compileJava" }, tags = { TAG.BUILD }, label = "compileJava" },
}

return {
	cache_key = function(opts)
		return get_gradlew(opts)
	end,
	generator = function(opts, cb)
		local gradlew = get_gradlew(opts)
		if not gradlew then
			return "No gradlew found"
		end
		local cwd = vim.fs.dirname(gradlew)
		local ret = {}
		for _, command in ipairs(commands) do
			table.insert(ret, {
				name = string.format("gradle %s", command.label),
				tags = command.tags,
				builder = function()
					return {
						cmd = vim.list_extend({ gradlew }, command.args),
						cwd = cwd,
					}
				end,
			})
		end
		cb(ret)
	end,
}
