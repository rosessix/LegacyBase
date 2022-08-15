RegisterCommand('menu', function(source, args)
    local user = exports['lg-base']:getComponent('User'):GetPlayer(source)
    if user ~= nil then
        local groups = exports['lg-base']:getComponent('Groups')
        if user.isAdmin() then
            TriggerClientEvent('lg-admin:openMenu', source)
        end
    end
end)

RegisterNetEvent('lg-admin:RequestPlayers', function()
    local players = exports['lg-base']:getComponent('User'):GetPlayers()
    local _players = {}
    for k, v in pairs(players) do
        table.insert(_players, {
            id = v.id,
            username = v.username,
            source = v.source
        })
    end

    TriggerClientEvent('lg-admin:SetPlayers', source, _players)
end)

RegisterNetEvent('lg-admin:SpectatePlayer', function(target)
    local user = exports['lg-base']:getComponent('User'):GetPlayer(source)

    if user ~= nil then
        if user.isAdmin() then
            TriggerClientEvent('lg-admin:cSpectatePlayer', source, target, GetEntityCoords(GetPlayerPed(target)))
        end
    end
end)

RegisterNetEvent('lg-admin:TeleportTo', function(target)
    local user = exports['lg-base']:getComponent('User'):GetPlayer(source)

    if user.isAdmin() then
        TriggerClientEvent('lg-admin:cTeleportTo', source, GetEntityCoords(GetPlayerPed(target)))
    end
end)

RegisterNetEvent('lg-admin:Bring', function(coords, target)
    local user = exports['lg-base']:getComponent('User'):GetPlayer(source)

    if user.isAdmin() then
        TriggerClientEvent('lg-admin:cTeleportTo', target, coords)
    end
end)

RegisterNetEvent('lg-admin:RevivePlayer', function(target)
    local user = exports['lg-base']:getComponent('User'):GetPlayer(source)

    if user.isAdmin() then
        TriggerClientEvent('lg-base:RessurectPlayer', target)
    end
end)