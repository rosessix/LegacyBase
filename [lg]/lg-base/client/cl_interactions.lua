LG.Interactions = {
    Zones = {}
}

local inZone = false

function LG.Interactions:AddInteraction(name, x,y,z, distance, onEnter, onLeave, data)
    local interaction = {
        name = name,
        x = x,
        y = y,
        z = z,
        distance = distance,
        onEnter = onEnter,
        onLeave = onLeave,
        data = data
    }

    LG.Interactions.Zones[name] = interaction

    LG.Logs:Log('trace', 'Added interaction: ^1' .. name..'^7')
end

function LG.Interactions:RemoveInteraction(name)
    LG.Interactions.Zones[name] = nil

    LG.Logs:Log('trace', 'Removed interaction: ^1' .. name..'^7')
end


--[[
    This is an example of how to add an interaction.
]]

CreateThread(function()
    LG.Interactions:AddInteraction('beach', -1366.9,-1519.58,4.42, 1.5, onEnter, onLeave, nil)
    while true do
        local sleep = 1
        local myCoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(LG.Interactions.Zones) do
            local retval, screenX, screenY = GetScreenCoordFromWorldCoord(v.x, v.y, v.z)
            if #(vector3(v.x, v.y, v.z) - myCoords) < v.distance then
                DrawRect(screenX, screenY, 0.03, 0.03, 255, 255, 255, 150)
                if not inZone then
                    if v.onEnter then
                        v.onEnter()
                    end
                    inZone = true
                end
            else
                if inZone then
                    if v.onLeave then
                        v.onLeave()
                    end
                    inZone = false
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

CreateThread(function()
    addComponent('Interactions', LG.Interactions)
end)

function onEnter()
    print('Hi i entered the zone')
end

function onLeave()
    print('Hi i am no in zone no more')
end