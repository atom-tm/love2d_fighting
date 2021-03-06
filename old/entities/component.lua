local core = l2df or require((...):match("(.-)core.+$") or "" .. "core")
assert(type(core) == "table" and core.version >= 1.0, "Core.Entities.Component works only with l2df v1.0 and higher")

local General = core.import "core.class.general"
local helper = core.import "helper"

local hook = helper.hook
local copyTable = helper.copyTable

local Component = General:extend()

	function Component:init(entity)
		local class = self
		while class and not class:isTypeOf(General) do
			for k, v in pairs(class) do
				if k:sub(1, 1) ~= "_" and k ~= "super" and k ~= "init" then
					if type(v) == "function" then
						hook(entity, k, v)
					else
						entity[k] = copyTable(v, entity[k])
					end
				end
			end
			class = class.___class
		end
	end

return Component