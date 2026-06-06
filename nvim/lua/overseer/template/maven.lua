local constants = require("overseer.constants")
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local function get_pom(opts)
	return vim.fs.find("pom.xml", { upward = true, type = "file", path = opts.dir })[1]
end

local commands = {
	{ args = { "compile" }, tags = { TAG.BUILD }, label = "compile" },
	{ args = { "test" }, tags = { TAG.TEST }, label = "test" },
	{ args = { "clean" }, tags = { TAG.CLEAN }, label = "clean" },
	{ args = { "verify" }, label = "verify" },
	{ args = { "package", "-DskipTests" }, tags = { TAG.BUILD }, label = "package (no tests)" },
	{ args = { "install", "-DskipTests" }, label = "install (no tests)" },
}

return {
	cache_key = function(opts)
		return get_pom(opts)
	end,
	generator = function(opts, cb)
		if vim.fn.executable("mvn") == 0 then
			return 'Command "mvn" not found'
		end
		local pom = get_pom(opts)
		if not pom then
			return "No pom.xml found"
		end
		local cwd = vim.fs.dirname(pom)
		local ret = {}
		for _, command in ipairs(commands) do
			table.insert(ret, {
				name = string.format("mvn %s", command.label),
				tags = command.tags,
				builder = function()
					return {
						cmd = vim.list_extend({ "mvn" }, command.args),
						cwd = cwd,
					}
				end,
			})
		end
		cb(ret)
	end,
}
