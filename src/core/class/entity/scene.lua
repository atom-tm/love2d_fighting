local core = l2df or require((...):match("(.-)core.+$") or "" .. "core")
assert(type(core) == "table" and core.version >= 1.0, "Entities works only with l2df v1.0 and higher")

local Entity = core.import "core.class.entity"
local Print = core.import "core.class.component.print"

local Scene = Entity:extend()

    function Scene:init(text)
        self:addComponent(Print(text))
    end


return Scene