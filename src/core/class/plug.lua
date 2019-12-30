--- Plug class
-- @classmod l2df.core.class.plug
-- @author Kasai
-- @copyright Atom-TM 2019

local core = l2df or require(((...):match('(.-)core.+$') or '') .. 'core')
assert(type(core) == 'table' and core.version >= 1.0, 'Plugs works only with l2df v1.0 and higher')

local Class = core.import 'core.class'
local Plug = Class:extend()

    function Plug:init()

    end

return Plug