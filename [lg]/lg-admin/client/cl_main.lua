WarMenu.CreateMenu('admin', 'Admin')
WarMenu.CreateSubMenu('admin_menu', 'admin', 'Admin')
WarMenu.CreateSubMenu('online_menu', 'admin', 'Online Players')
WarMenu.CreateSubMenu('dev_menu', 'admin', 'Dev')

local selectedPlayer = 0
local currentPlayers = {}
local isSpectating = false
local lastCoords = nil
local devMode = false
local menuOpen = false

RegisterNetEvent('lg-admin:openMenu', function()
    makePretty('admin')
    makePretty('admin_menu')
    makePretty('online_menu')
    makePretty('dev_menu')
    
    if WarMenu.IsAnyMenuOpened() then
        return
    end
    
    TriggerServerEvent('lg-admin:RequestPlayers')

    WarMenu.OpenMenu('admin')

    while true do
        if WarMenu.IsMenuOpened('admin') then
            WarMenu.MenuButton('Admin', 'admin_menu')
            WarMenu.MenuButton('Online Players', 'online_menu')
            WarMenu.MenuButton('Dev', 'dev_menu')
            WarMenu.Display()

        elseif WarMenu.IsMenuOpened('admin_menu') then
            if WarMenu.Button('Revive', '') then
                TriggerEvent('lg-base:RessurectPlayer')
            end
            WarMenu.Display()

        elseif WarMenu.IsMenuOpened('dev_menu') then
            if WarMenu.Button('Toggle development mode: '..tostring(devMode), '') then
                devMode = not devMode
            end

            if devMode then
                if WarMenu.Button('Spawn Vehicle', '') then
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local lib = exports['lg-base']:getComponent('Library')
                        local result = GetOnscreenKeyboardResult()
                        local coords = GetEntityCoords(PlayerPedId())
                        -- print(result)
                        
                        local vehicle = lib:CreateVehicle(coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), result, true)
                        

                    end
                end
            end

            WarMenu.Display()
        
        elseif WarMenu.IsMenuOpened('online_menu') then
            for k,v in pairs(currentPlayers) do
                -- if v ~= PlayerId() then
                    WarMenu.CreateSubMenu(v.source, 'online_menu', v.id.." | "..v.username)
                    if WarMenu.MenuButton('['..v.id.. "] ".. v.username, v.source) then
                        selectedPlayer = v.source
                        if WarMenu.CreateSubMenu('player_options', v.source) then
                        elseif WarMenu.CreateSubMenu('teleport_options', v.source) then
                        end

                    end
                -- end
            end
            WarMenu.Display()
        
        elseif WarMenu.IsMenuOpened(selectedPlayer) then
            WarMenu.MenuButton('Player Options', 'player_options')
            WarMenu.MenuButton('Teleport Options', 'teleport_options')

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('player_options') then
            if WarMenu.MenuButton('Revive', selectedPlayer) then
                TriggerServerEvent('lg-admin:RevivePlayer', selectedPlayer)
            end

            if WarMenu.MenuButton('Spectate', selectedPlayer) then
                isSpectating = not isSpectating

                TriggerServerEvent('lg-admin:SpectatePlayer', selectedPlayer)
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('teleport_options') then
            if WarMenu.MenuButton('Teleport to player', selectedPlayer) then
                TriggerServerEvent('lg-admin:TeleportTo', selectedPlayer)
            end

            if WarMenu.MenuButton('Bring', selectedPlayer) then
                TriggerServerEvent('lg-admin:Bring', GetEntityCoords(PlayerPedId()), selectedPlayer)
            end

            WarMenu.Display()
        else
            return
        end        
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('lg-admin:SetPlayers', function(players)
    currentPlayers = players
end)

RegisterNetEvent('lg-admin:cSpectatePlayer', function(target, coords)
    local ped = PlayerPedId()
    
    if isSpectating then
        lastCoords = GetEntityCoords(PlayerPedId())
        SetEntityVisible(ped, false) -- Set invisible
        SetEntityCollision(ped, false, false) -- Set collision
        SetEntityInvincible(ped, true) -- Set invincible
        NetworkSetEntityInvisibleToNetwork(ped, true) -- Set invisibility
        SetEntityCoords(PlayerPedId(), coords)
        Wait(2000)
        
        local _target = GetPlayerFromServerId(target)
        local target = GetPlayerPed(_target)

        NetworkSetInSpectatorMode(true, target) -- Enter Spectate Mode
    else
        local _target = GetPlayerFromServerId(target)
        local target = GetPlayerPed(_target)
        NetworkSetInSpectatorMode(false, target) -- Enter Spectate Mode
        SetEntityVisible(ped, true) -- Set invisible
        SetEntityCollision(ped, true, true) -- Set collision
        SetEntityInvincible(ped, false) -- Set invincible
        NetworkSetEntityInvisibleToNetwork(ped, false) -- Set invisibility

        RequestCollisionAtCoord(lastCoords.x, lastCoords.y, lastCoords.z)

        while not HasCollisionLoadedAroundEntity(ped) do
            SetEntityCoords(ped, lastCoords.x, lastCoords.y, lastCoords.z)
            Citizen.Wait(1)
        end
        SetEntityCoords(PlayerPedId(), lastCoords)
    end
end)

RegisterNetEvent('lg-admin:cTeleportTo', function(coords)
    SetEntityCoords(PlayerPedId(), coords)
end)

function makePretty(menu)
    WarMenu.SetMenuX(menu, 0.71)
    WarMenu.SetMenuY(menu, 0.017)

    WarMenu.SetTitleColor(menu, 135, 206, 250, 255)
    WarMenu.SetTitleBackgroundColor(menu, 0 , 0, 0, 150)
    WarMenu.SetMenuBackgroundColor(menu, 0, 0, 0, 100)
    WarMenu.SetMenuSubTextColor(menu, 255, 255, 255, 255)
end