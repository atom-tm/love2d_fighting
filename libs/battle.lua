function BattleProcessing()

	ControlCheck() -- функция проверки управления для всех игроков

	local remove_list = {} -- список объектов для удаления
	local creating_list = {} -- список объектов для создания

	for en_id = 1, #entity_list do -- для каждого из объектов в игре
		if entity_list[en_id] ~= "nil" and entity_list[en_id] ~= nil then -- если объект существует

			local en = entity_list[en_id] -- получаем объект
			local frame = GetFrame(en) -- получаем фрейм объекта

			if en.physic == true then -- если физика включена
				Gravity(en_id) -- функция ответственная за гравитацию
			end

			if (en.vel_x ~= 0) or (en.vel_y ~= 0) then -- если объект имеет скорость
				Motion(en, dt) -- функция ответственная за передвижение
			end

			if en.collision then -- если коллизии включены, выполняется проверка на наличие коллайдеров в текущем кадре. если коллайдеры имеются, они заносятся в списки для дальнейшей обработки
				if (en.arest == 0) and (frame.itr_radius > 0) then
					table.insert(collisioners.itr, en_id)
				end
				if (en.vrest == 0) and (frame.body_radius > 0) then
					table.insert(collisioners.body, en_id)
				end
				if (frame.platform_radius > 0) then
					table.insert(collisioners.platform, en_id)
				end
			end

			if en.wait == 0 then -- если вайт подошёл к концу, переходим в указанный кадр
				if en.next_frame == 0 then
					table.insert(remove_list, en_id)
				else
					SetFrame(en, en.next_frame)
				end
			else en.wait = en.wait - 1 end
		end
	end

	CollisionersProcessing()

	RemoveProcessing(remove_list) -- функция удаления объектов, помеченых к удалению



end


function CreateProcessing ()


end


function RemoveProcessing (list) -- функция предназначена для единовременного удаления из памяти всех объектов, помеченных к удалению, а так же для сборки оставшегося после них мусора
-------------------------------------
	for object = 1, #list do
		RemoveEntity(list[object])
	end
	collectgarbage()
end