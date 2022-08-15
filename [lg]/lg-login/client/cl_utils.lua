StartingPoint = {x = 268.2, y = -641.2, z = 42.0, h = 69.8}
function openUi()
    SetNuiFocus(true, true)
    SendNUIMessage({
        display = true,
    })
end

function closeUi()
    SetNuiFocus(false, false)
    SendNUIMessage({
        display = false,
    })
end

function setCharacters(chars)
    Wait(1000)
    SendNUIMessage({
        characters = chars,
    })
end

function errorUi(msg)
    SendNUIMessage({
        error = msg,
    })
end

function SpawnPlayer()
    local ped = PlayerPedId()
    
    RequestCollisionAtCoord(StartingPoint.x, StartingPoint.y, StartingPoint.z)
    SetEntityCoords(ped, StartingPoint.x, StartingPoint.y, StartingPoint.z)
    while not HasCollisionLoadedAroundEntity(ped) do
        print('loading collision: '..StartingPoint.x, StartingPoint.y, StartingPoint.z)
        Citizen.Wait(1)
        RequestCollisionAtCoord(StartingPoint.x, StartingPoint.y, StartingPoint.z)
        SetEntityCoords(ped, StartingPoint.x, StartingPoint.y, StartingPoint.z)
    end

    SetEntityCoords(ped, StartingPoint.x, StartingPoint.y, StartingPoint.z)
    SetEntityHeading(ped, StartingPoint.h)
    Wait(1000)
    
    DoScreenFadeIn(3500)
end