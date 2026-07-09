local constants = require("overseer.constants")
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local function get_cargo_toml(opts)
	return vim.fs.find("Cargo.toml", { upward = true, type = "file", path = opts.dir })[1]
end

local commands = {
	{ args = { "check" }, tags = { TAG.BUILD }, label = "check" },
	{ args = { "build" }, tags = { TAG.BUILD }, label = "build" },
	{ args = { "build", "--release" }, tags = { TAG.BUILD }, label = "build --release" },
	{ args = { "run" }, label = "run" },
	{ args = { "test" }, tags = { TAG.TEST }, label = "test" },
	{ args = { "fmt" }, label = "fmt" },
	{ args = { "clippy" }, label = "clippy" },
	{ args = { "clean" }, tags = { TAG.CLEAN }, label = "clean" },
}

return {
	cache_key = function(opts)
		return get_cargo_toml(opts)
	end,
	generator = function(opts, cb)
		if vim.fn.executable("cargo") == 0 then
			return 'Command "cargo" not found'
		end
		local cargo_toml = get_cargo_toml(opts)
		if not cargo_toml then
			return "No Cargo.toml found"
		end
		local cwd = vim.fs.dirname(cargo_toml)
		local ret = {}
		for _, command in ipairs(commands) do
			table.insert(ret, {
				name = string.format("cargo %s", command.label),
				tags = command.tags,
				params = {
					args = { type = "string", default = "", desc = "Extra arguments" },
				},
				builder = function(params)
					local cmd = vim.list_extend({ "cargo" }, command.args)
					if params.args and params.args ~= "" then
						for arg in params.args:gmatch("%S+") do
							table.insert(cmd, arg)
						end
					end
					return {
						cmd = cmd,
						cwd = cwd,
					}
				end,
			})
		end
		cb(ret)
	end,
}
