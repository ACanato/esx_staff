local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                             = nil
local PlayerData                = {}
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local DragStatus              	= {}
DragStatus.IsDragged          	= false
local draganim 					= false
local draw 						= false
local visiblePlayers 			= {}
local noclip				    = false
local noclip_speed 				= 3.0
local numRetries = 5
local distanceToCheck = 5.0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenstaffActionsMenu()
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'staff_actions',
		{
			title    = 'United Roleplay',
			description    = '🛠️discord.me/unitedroleplay21 - Menu Staff',
			align    = 'left',
			elements = {
		  	{label = _U('citizen_interaction'), value = 'citizen_interaction'},
		  	{label = _U('staff_assistant'), 	value = 'staff_assistant'},
		  	{label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
		  	{label = _U('object_spawner'),      value = 'object_spawner'},
			},
		},
		function(data, menu)

			if data.current.value == 'citizen_interaction' then

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'citizen_interaction',
					{
						title    = 'United Roleplay',
						description    = _U('citizen_interaction2'),
						align    = 'left',
						elements = {
							{label = _U('id_card'),     	value = 'identity_card'},
							{label = _U('search'),      	value = 'body_search'},
							{label = _U('handcuff'), 		value = 'handcuff'},
							{label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
							{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
							{label = _U('drag'),			value = 'drag'},
							{label = _U('fine'),            value = 'fine'}
						},
					},
					function(data2, menu2)

						local player, distance = ESX.Game.GetClosestPlayer()

						if distance ~= -1 and distance <= 3.0 then

							if data2.current.value == 'identity_card' then
								OpenIdentityCardMenu(player)
							end

							if data2.current.value == 'body_search' then
								OpenBodySearchMenu(player)
							end

							if data2.current.value == 'handcuff' then
								TriggerServerEvent('esx_staffjob:handcuff', GetPlayerServerId(player))
							end

							if data2.current.value == 'put_in_vehicle' then
								TriggerServerEvent('esx_staffjob:putInVehicle', GetPlayerServerId(player))
							end

							if data2.current.value == 'out_the_vehicle' then
								TriggerServerEvent('esx_staffjob:OutVehicle', GetPlayerServerId(player))
							end

							if data2.current.value == 'drag' then
								TriggerServerEvent('esx_staffjob:drag', GetPlayerServerId(player))
							end

							if data2.current.value == 'fine' then
								OpenFineMenu(player)
							end

						else
							ESX.ShowNotification(_U('no_players_nearby'))
						end

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

			end

			if data.current.value == 'staff_assistant' then
	
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'staff_assistant',
						{
							title    = 'United Roleplay',
							description    = _U('staff_assistant2'),
							align    = 'left',
							elements = {
								{label = _U('names'),     	value = 'names'},
								{label = _U('coords'),     	value = 'coords'},
								{label = _U('tpm'),     	value = 'tpm'},
								{label = _U('noclip'),     	value = 'noclip'},
								{label = _U('dv'),     		value = 'dv'}
							},
						},
						function(data2, menu2)
	
							if data2.current.value == 'names' then
								TriggerServerEvent('esx_staffjob:Names', GetPlayerServerId(player))
							end

							if data2.current.value == 'coords' then
								ToggleCoords(player)
							end

							if data2.current.value == 'tpm' then
								TeleportToWaypoint(player)
							end

							if data2.current.value == 'noclip' then
								admin_no_clip(player)
							end

							if data2.current.value == 'dv' then
								TriggerEvent("aprendidos:deleteVehicle")
							end
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
			end

			if data.current.value == 'vehicle_interaction' then

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'vehicle_interaction',
					{
						title    = 'United Roleplay',
						description    = _U('vehicle_interaction2'),
						align    = 'left',
						elements = {
						{label = _U('vehicle_flip'), value = 'vehicle_flip'},
						{label = _U('pick_lock'),  	 value = 'hijack_vehicle'},
					  	{label = _U('vehicle_info'), value = 'vehicle_infos'}
						},
					},
					function(data2, menu2)

						local playerPed = GetPlayerPed(-1)
						local coords    = GetEntityCoords(playerPed)
						local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

						if DoesEntityExist(vehicle) then

							local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

							if data2.current.value == 'vehicle_flip' then
								VehicleFlip(vehicleData)
							end

							if data2.current.value == 'vehicle_infos' then
								OpenVehicleInfosMenu(vehicleData)
							end

							if data2.current.value == 'hijack_vehicle' then

					      local playerPed = GetPlayerPed(-1)
					      local coords    = GetEntityCoords(playerPed)

					      if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

									local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)
					        
					        if DoesEntityExist(vehicle) then

					        	Citizen.CreateThread(function()

											TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

											exports['progressBars']:startUI(4000, "Destrancando Viatura")

											Wait(4000)

											ClearPedTasksImmediately(playerPed)

						        	SetVehicleDoorsLocked(vehicle, 1)
					            SetVehicleDoorsLockedForAllPlayers(vehicle, false)

					            TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))

					        	end)

					        end

					      end

							end

						else
							ESX.ShowNotification(_U('no_vehicles_nearby'))
						end

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

			end

			if data.current.value == 'object_spawner' then

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'citizen_interaction',
					{
						title    = 'United Roleplay',
						description    = _U('traffic_interaction'),
						align    = 'left',
						elements = {
					    {label = _U('cone'),     value = 'prop_roadcone02a'},
					    {label = _U('barrier'), value = 'prop_barrier_work06a'},
					    {label = _U('spikestrips'),    value = 'p_ld_stinger_s'},
					    {label = _U('box'),   value = 'prop_boxpile_07d'},
					    {label = _U('cash'),   value = 'hei_prop_cash_crate_half_full'}
						},
					},
					function(data2, menu2)


						local model     = data2.current.value
						local playerPed = GetPlayerPed(-1)
						local coords    = GetEntityCoords(playerPed)
						local forward   = GetEntityForwardVector(playerPed)
						local x, y, z   = table.unpack(coords + forward * 1.0)

						if model == 'prop_roadcone02a' then
							z = z - 2.0
						end

						ESX.Game.SpawnObject(model, {
							x = x,
							y = y,
							z = z
						}, function(obj)
							SetEntityHeading(obj, GetEntityHeading(playerPed))
							PlaceObjectOnGroundProperly(obj)
						end)

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

			end

		end,
		function(data, menu)
			
			menu.close()

		end
	)

end

RegisterNetEvent('esx_staffjob:drag')
AddEventHandler('esx_staffjob:drag', function(copID)
	if not IsHandcuffed then
		return
	end

	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else

				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_staffjob:OutVehicle') 
AddEventHandler('esx_staffjob:OutVehicle', function()     
	local playerPed = PlayerPedId()      

	if not IsPedSittingInAnyVehicle(playerPed) then         
		return    
	end      
	
	local vehicle = GetVehiclePedIsIn(playerPed, false)     
	TaskLeaveVehicle(playerPed, vehicle, 16) 
end)
------------------------------
--[[
RegisterNetEvent('esx_staffjob:OutVehicle')
AddEventHandler('esx_staffjob:OutVehicle', function()
	local playerPed = PlayerPedId()
	TriggerServerEvent('3dme:shareDisplay', 'Abre porta e retira do veiculo!')
	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)
--]]
------------------------------

function OpenIdentityCardMenu(player)

	ESX.TriggerServerCallback('esx_staffjob:getOtherPlayerData', function(data)

		local jobLabel = nil

		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
		else
			jobLabel = 'Job : ' .. data.job.label
		end

		local elements = {
			{label = _U('name') .. data.name, value = nil},
			{label = jobLabel,              value = nil},
		}

		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
		end

		if data.licenses ~= nil then

			table.insert(elements, {label = '--- Licenses ---', value = nil})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end

		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)

			end,
			function(data, menu)
				menu.close()
			end
		)

	end, GetPlayerServerId(player))

end

function OpenBodySearchMenu(player)

	ESX.TriggerServerCallback('esx_staffjob:getOtherPlayerData', function(data)

		local elements = {}
		
		local blackMoney = 0

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' then
				blackMoney = data.accounts[i].money
			end
		end

		table.insert(elements, {
			label          = _U('confiscate_dirty') .. blackMoney,
			value          = 'black_money',
			itemType       = 'item_account',
			amount         = blackMoney
		})

		table.insert(elements, {label = '--- Armas ---', value = nil})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
				value          = data.weapons[i].name,
				itemType       = 'item_weapon',
				amount         = data.ammo,
			})
		end

		table.insert(elements, {label = _U('inventory_label'), value = nil})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
					value          = data.inventory[i].name,
					itemType       = 'item_standard',
					amount         = data.inventory[i].count,
				})
			end
		end
		
		
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'body_search',
			{
				title    = _U('search'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)

				local itemType = data.current.itemType
				local itemName = data.current.value
				local amount   = data.current.amount

				if data.current.value ~= nil then

					TriggerServerEvent('esx_staffjob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

					OpenBodySearchMenu(player)

				end

			end,
			function(data, menu)
				menu.close()
			end
		)

	end, GetPlayerServerId(player))

end

function OpenFineMenu(player)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'fine',
		{
			title    = _U('fine'),
			align    = 'top-left',
			elements = {
		  	{label = _U('traffic_offense'),   value = 0},
			},
		},
		function(data, menu)
			
			OpenFineCategoryMenu(player, data.current.value)

		end,
		function(data, menu)
			menu.close()
		end
	)

end

function OpenFineCategoryMenu(player, category)

	ESX.TriggerServerCallback('esx_staffjob:getFineList', function(fines)

		local elements = {}
		
		for i=1, #fines, 1 do
			table.insert(elements, {
				label     = fines[i].label .. ' ' .. fines[i].amount ..'€',
				value     = fines[i].id,
				amount    = fines[i].amount,
				fineLabel = fines[i].label
			})
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'fine_category',
			{
				title    = _U('fine'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)

				local label  = data.current.fineLabel
				local amount = data.current.amount

				menu.close()

				if Config.EnablePlayerManagement then
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_staff', _U('fine_total') .. label, amount)
				else
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total') .. label, amount)
				end

				ESX.SetTimeout(300, function()
					OpenFineCategoryMenu(player, category)
				end)

			end,
			function(data, menu)
				menu.close()
			end
		)

	end, category)

end

-- Assistente Names
RegisterNetEvent('esx_staffjob:drawText')
AddEventHandler('esx_staffjob:drawText',function()
    if draw then
        draw = false
        -- TriggerEvent('chat:addMessage', { args = { 'United Roleplay ', 'Nomes Desativados' }, color = { 255, 50, 50 } })
    else
        draw = true
        -- TriggerEvent('chat:addMessage', { args = { 'United Roleplay ', 'Nomes Ativados' }, color = { 255, 50, 50 } })
    end
end)


function draw3DText(pos, text, options)
    options = options or { }
    local color = options.color or {r = 255, g = 255, b = 255, a = 255}
    local scaleOption = options.size or 0.8

    local camCoords      = GetGameplayCamCoords()
    local dist           = #(vector3(camCoords.x, camCoords.y, camCoords.z)-vector3(pos.x, pos.y, pos.z))
    local scale = (scaleOption / dist) * 4
    local fov   = (1 / GetGameplayCamFov()) * 100
    local scaleMultiplier = scale * fov
    SetDrawOrigin(pos.x, pos.y, pos.z, 0);
    SetTextProportional(0)
    SetTextScale(0.0 * scaleMultiplier, 0.60 * scaleMultiplier)
    SetTextColour(color.r,color.g,color.b,color.a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.NearPlayerTime or 500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local allPlayers = GetActivePlayers()
        for _, v in pairs(allPlayers) do
            local targetPed = GetPlayerPed(v)
            local targetCoords = GetEntityCoords(targetPed)
            if #(coords-targetCoords) < Config.DrawDistance then
                visiblePlayers[v] = v
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if draw then
            local currentCoords = GetEntityCoords(GetPlayerPed(PlayerId()))
            for _, v in pairs(visiblePlayers) do
                local ped = GetPlayerPed(v)
                local cords = GetEntityCoords(ped)
                if #(cords-currentCoords) < Config.DrawDistance then
                    draw3DText(cords, GetPlayerName(v)..' | '..GetPlayerServerId(v), {
                        size = Config.TextSize
                    })
                end
            end
        end
    end
end)
-- Assistente Names

-- TPM
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
    end
end)

TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_staffjob:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
            local WaypointHandle = GetFirstBlipInfoId(8)

            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end

                ESX.ShowNotification("Teletransportou-se")
            else
                ESX.ShowNotification("Precisas de marcar um local")
            end
        else
            ESX.ShowNotification("Não tens permissões para isso, burro")
        end
    end)
end

-- NoClip
function admin_no_clip()
	noclip = not noclip
	local ped = GetPlayerPed(-1)
	if noclip then
	  SetEntityInvincible(ped, true)
	  SetEntityVisible(ped, false, false)
	  Notify("Noclip ~g~Ativado")
	else
	  SetEntityInvincible(ped, false)
	  SetEntityVisible(ped, true, false)
	  Notify("Noclip ~r~Desativado")
	end
end
  
function getPosition()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	return x,y,z
end
  
function getCamDirection()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()
  
	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)
  
	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
	  x = x/len
	  y = y/len
	  z = z/len
	end
  
	return x,y,z
end
  
function isNoclip()
	return noclip
end


Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if noclip then
		local ped = GetPlayerPed(-1)
		local x,y,z = getPosition()
		local dx,dy,dz = getCamDirection()
		local speed = noclip_speed

		SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

		if IsControlPressed(0,32) then
		  x = x+speed*dx
		  y = y+speed*dy
		  z = z+speed*dz
		end
  
		if IsControlPressed(0,269) then
		  x = x-speed*dx
		  y = y-speed*dy
		  z = z-speed*dz
		end
  
		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
	  end
	end
  end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end
-- NoClip

-- DV
RegisterNetEvent( "aprendidos:deleteVehicle" )
AddEventHandler( "aprendidos:deleteVehicle", function()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            else 
                Notify( "Você deve estar no assento do motorista!" )
            end 
        else
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( ped, pos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            else 
                Notify( "~y~Você deve estar dentro ou perto de um veículo para apaga-lo." )
            end 
        end 
    end 
end )

function DeleteGivenVehicle( veh, timeoutMax )
    local timeout = 0 

    SetEntityAsMissionEntity( veh, true, true )
    DeleteVehicle( veh )

    if ( DoesEntityExist( veh ) ) then
        Notify( "~r~Falha ao apagar veículo, tentando novamente..." )

        while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
            DeleteVehicle( veh )

            if ( not DoesEntityExist( veh ) ) then 
                Notify( "Veículo ~r~aprendido." )
            end 

            timeout = timeout + 1 
            Citizen.Wait( 500 )

            if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
                Notify( "~r~Falha ao apagar veículo após " .. timeoutMax .. " tentativas." )
            end 
        end 
    else 
        Notify( "Veículo ~r~aprendido." )
    end 
end 

function GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    
    if ( IsEntityAVehicle( vehicle ) ) then 
        return vehicle
    end 
end

function Notify( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end
-- DV

-- Coords
local coordsVisible = false

function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.600, 0.600)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(1, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.36, 0.05)
end

Citizen.CreateThread(function()
    while true do
		
		if coordsVisible then

			local playerPed = PlayerPedId()
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
			local playerH = GetEntityHeading(playerPed)

			DrawGenericText(("~g~X~r~ %s ~m~| ~p~Y~r~ %s ~m~| ~g~Z~r~ %s ~m~"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ)))
		end

		Citizen.Wait(0)
	end
end)

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

ToggleCoords = function()
	coordsVisible = not coordsVisible
end
-- Coords

-- Flip Vehicle
function VehicleFlip()

    local player = GetPlayerPed(-1)
    posdepmenu = GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
	if carTargetDep ~= nil then
			platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
	end
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    playerCoords = playerCoords + vector3(0, 2, 0)
	
	SetEntityCoords(carTargetDep, playerCoords)
	
	Notify("Veículo virado com ~g~Sucesso")

end
-- Flip Vehicle

function OpenVehicleInfosMenu(vehicleData)

	local playerPed = GetPlayerPed(-1)

	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)

		exports['progressBars']:startUI(4000, "Retirando as Informações da Viatura")

		Wait(4000)

		ClearPedTasksImmediately(playerPed)
	end)

	ESX.TriggerServerCallback('esx_staffjob:getVehicleInfos', function(infos)
		
		Wait(4000)
		
		local elements = {}

		table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})
--[[
		if infos.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
		end
--]]
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_infos',
			{
				title    = 'United Roleplay',
				description    = _U('vehicle_info'),
				align    = 'left',
				elements = elements,
			},
			nil,
			function(data, menu)
				menu.close()
			end
		)

	end, vehicleData.plate)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer 
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('esx_staffjob:hasExitedMarker', function(station, part, partNum)
	CurrentAction = nil
end)

AddEventHandler('esx_staffjob:hasEnteredEntityZone', function(entity)

	local playerPed = GetPlayerPed(-1)

	if PlayerData.job ~= nil and PlayerData.job.name == 'staff' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_object')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle,  i,  true,  1000)
			end

		end

	end

end)

AddEventHandler('esx_staffjob:hasExitedEntityZone', function(entity)

	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end

end)

RegisterNetEvent('esx_staffjob:handcuff')
AddEventHandler('esx_staffjob:handcuff', function()

	IsHandcuffed    = not IsHandcuffed;
	local playerPed = GetPlayerPed(-1)

	Citizen.CreateThread(function()

		if IsHandcuffed then
			
			RequestAnimDict('mp_arresting')
			
			while not HasAnimDictLoaded('mp_arresting') do
				Wait(100)
			end
			
			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			SetEnableHandcuffs(playerPed, true)
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed,  true)
		
		else
			
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed,  true)
			FreezeEntityPosition(playerPed, false)
		
		end

	end)
end)

RegisterNetEvent('esx_staffjob:putInVehicle')
AddEventHandler('esx_staffjob:putInVehicle', function()

	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

		local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)
    
    if DoesEntityExist(vehicle) then

    	local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    	local freeSeat = nil

    	for i=maxSeats - 1, 0, -1 do
    		if IsVehicleSeatFree(vehicle,  i) then
    			freeSeat = i
    			break
    		end
    	end

    	if freeSeat ~= nil then
    		TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
    	end

    end

  end	

end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsHandcuffed then
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		if PlayerData.job ~= nil and PlayerData.job.name == 'staff' then

			local playerPed = GetPlayerPed(-1)
			local coords    = GetEntityCoords(playerPed)

		end

	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()

	while true do

		Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'staff' then

			local playerPed      = GetPlayerPed(-1)
			local coords         = GetEntityCoords(playerPed)
			local isInMarker     = false
			local currentStation = nil
			local currentPart    = nil
			local currentPartNum = nil
			local hasExited = false

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
				
				if
					(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_staffjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum
				
				TriggerEvent('esx_staffjob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				
				HasAlreadyEnteredMarker = false
				
				TriggerEvent('esx_staffjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

		end

	end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
	
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work06a',
		'p_ld_stinger_s',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full'
	}

	while true do

		Citizen.Wait(0)

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			
			local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)
			
			if DoesEntityExist(object) then

				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end

			end

		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then

 			if LastEntity ~= closestEntity then
				TriggerEvent('esx_staffjob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end

		else

			if LastEntity ~= nil then
				TriggerEvent('esx_staffjob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end

		end

	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'staff' and (GetGameTimer() - GUI.Time) > 150 then

				if CurrentAction == 'delete_vehicle' then

					if
						GetEntityModel(vehicle) == GetHashKey('staff')  or
						GetEntityModel(vehicle) == GetHashKey('staff2') or
						GetEntityModel(vehicle) == GetHashKey('staff3') or
						GetEntityModel(vehicle) == GetHashKey('staff4') or
						GetEntityModel(vehicle) == GetHashKey('staffb') or
						GetEntityModel(vehicle) == GetHashKey('stafft')
					then
						TriggerServerEvent('esx_service:disableService', 'staff')
					end
					
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end

				if CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()
				
			end

		end

		if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'staff' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'staff_actions') and (GetGameTimer() - GUI.Time) > 150 then
			OpenstaffActionsMenu()
			GUI.Time = GetGameTimer()
		end

	end
end)