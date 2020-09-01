--- Physics and collisions manager
-- @classmod l2df.manager.physix
-- @author Abelidze
-- @author Kasai
-- @copyright Atom-TM 2020

local core = l2df or require(((...):match('(.-)manager.+$') or '') .. 'core')
assert(type(core) == 'table' and core.version >= 1.0, 'PhysixManager works only with l2df v1.0 and higher')

local helper = core.import 'helper'

local Cube = core.import 'class.component.physix.cube'
local Grid = core.import 'class.component.physix.grid'

local pairs = _G.pairs
local setmetatable = _G.setmetatable
local max = math.max
local min = math.min

local requireFile = helper.requireFile
local requireFolder = helper.requireFolder

local width = 16
local space = { }
local movable = { }
local layer_collisions = { {'itr','bdy'} }
local traverse, collide, move

local Manager = { }

	---
	-- @param string layer
	-- @param table collider
	function Manager:add(layer, collider)
		local c = collider
		space[layer] = space[layer] or { grid = { }, items = { } }
		local s = space[layer]
		local items = s.items
		items[#items + 1] = c
		traverse(s.grid, c, function (cell) cell[#cell + 1] = c end)
	end

	function Manager:move(obj, world)
		if not (obj and world) then return end
		movable[#movable + 1] = { obj, world }
	end

	function Manager.convert(value)
		return value * 60
	end

	function Manager:update(dt)
		local obj, world
		collide()
		for i = 1, #movable do
			move(dt, movable[i][1], movable[i][2])
			movable[i] = nil
		end
	end

	traverse = function (grid, cell, callback)
		local c, sz, szy = cell
		local cx, cy, cz, cw, ch, cd = Grid:toCellCube(width, c.x, c.y, c.z, c.w, c.h, c.d)
		for z = cz, cz + cd - 1 do
			grid[z] = grid[z] or { }
			sz = grid[z]
			for y = cy, cy + ch - 1 do
				sz[y] = sz[y] or { }
				szy = sz[y]
				for x = cx, cx + cw - 1 do
					szy[x] = szy[x] or { }
					-- or setmetatable({ }, {__mode = 'v'})
					callback(szy[x])
				end
			end
		end
	end

	collide = function ()
		local s = space
		for i = 1, #layer_collisions do
			local i1 = layer_collisions[i][1]
			local i2 = layer_collisions[i][2]
			local l1 = s[i1]
			local l2 = s[i2]
			if l1 and l2 then
				local c1
				for j = 1, #l1.items do
					c1 = l1.items[j]
					traverse(l2.grid, c1, function (cell)
						local c2, _
						for k = 1, #cell do
							c2 = cell[k]
							if Cube:isIntersecting(c1.x, c1.y, c1.z, c1.w, c1.h, c1.d, c2.x, c2.y, c2.z, c2.w, c2.h, c2.d) then
								_ = c1.action and c1.action(c1.owner, c2.owner, c1, c2)
								_ = c2.action and c2.action(c2.owner, c1.owner, c2, c1)
							end
						end
					end)
				end
			end
		end
		for i, x in pairs(s) do
			x.grid = { }
			x.items = { }
		end
	end

	move = function (dt, obj, world)
		local data = obj.data

		data.x = data.x + (Manager.convert(data.dx) + data.vx) * dt
		data.y = data.y + (Manager.convert(data.dy) + data.vy) * dt
		data.z = data.z + (Manager.convert(data.dz) + data.vz) * dt

		local borders = world.borders

		data.x = borders.x1 and max(borders.x1, data.x) or data.x
		data.x = borders.x2 and min(borders.x2, data.x) or data.x

		data.vx = borders.x1 and data.x <= borders.x1 and 0 or data.vx
		data.vx = borders.x2 and data.x >= borders.x2 and 0 or data.vx

		data.y = borders.y1 and max(borders.y1, data.y) or data.y
		data.y = borders.y2 and min(borders.y2, data.y) or data.y

		data.vy = borders.y1 and data.y <= borders.y1 and 0 or data.vy
		data.vy = borders.y2 and data.y >= borders.y2 and 0 or data.vy

		data.z = borders.z1 and max(borders.z1, data.z) or data.z
		data.z = borders.z2 and min(borders.z2, data.z) or data.z

		data.vz = borders.z1 and data.z <= borders.z1 and 0 or data.vz
		data.vz = borders.z2 and data.z >= borders.z2 and 0 or data.vz

		data.mx, data.my, data.mz = 0, 0, 0
		data.dx, data.dy, data.dz = 0, 0, 0
	end

return Manager