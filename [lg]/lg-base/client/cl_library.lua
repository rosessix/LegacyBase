LG.Library = {}

--[[
    Enable pvp.
]]

CreateThread(function()
    local player = PlayerId()
    local playerPed = GetPlayerPed(-1)
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(playerPed, true, true)
end)

function LG.Library:LoadModel(model)
    local tries = 0
    print(model)
    RequestModel(model)

    while not HasModelLoaded(model) and tries < 500 do
        tries = tries + 1
        Citizen.Wait(1)
    end

    if tries >= 500 then
        LG.Logs:Log('error', 'Failed to load model: ^' .. tostring(model)..'^7')
        return false
    end
    SetModelAsNoLongerNeeded(model)
    return true
end

function LG.Library:CreateVehicle(x,y,z,h, model,networked)
    LG.Library:LoadModel(model)

    local vehicle = CreateVehicle(model, x, y, z, h, true, networked)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    return vehicle
end

function LG.Library:GetClosestPlayer()
    local ped = PlayerPedId()
    local players = GetActivePlayers()
    local closest, distance = nil, 99999999
    local myCoords = GetEntityCoords(ped)
    for k,v in pairs(players) do
        local player = GetPlayerPed(v)
        local dist = #(vector3(GetEntityCoords(player)) - myCoords)
        if #(vector3(GetEntityCoords(player)) - myCoords) < distance then
            if player ~= ped then
                distance = dist
                closest = player
            end
        end
    end
    return closest, distance
end

function LG.Library:LoadAnimDict(dict)
	RequestAnimDict(dict)

	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
	return true
end

function LG.Library:GetClosestVehicle()
	local vehicles = GetGamePool('CVehicle')
	local closest, dist = nil, 99999
	local myCoords = GetEntityCoords(PlayerPedId())
	for k,v in pairs(vehicles) do
		local _dist = #(GetEntityCoords(v) - myCoords)
		if _dist < dist then
			closest = v
			dist = _dist
		end
	end

	return closest, dist
end

function LG.Library:Draw2DText(text)
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(0.5,0.955)
end

function LG.Library:Round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

CreateThread(function()
    addComponent('Library', LG.Library)
end)

