local core = l2df or require((...):match("(.-)core.+$") or "" .. "core")
assert(type(core) == "table" and core.version >= 1.0, "Entities works only with l2df v1.0 and higher")

local State = core.import "core.class.state"

local State = State:new()

	function State:persistentUpdate(entity, vars)
		-- body
	end

	function State:update(entity, vars)
		-- body
	end

return State