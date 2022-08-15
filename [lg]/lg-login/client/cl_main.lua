CreateThread(function()
    while true do
        Citizen.Wait(1)
        if NetworkIsSessionStarted() then
            TriggerServerEvent('lg-login:FetchCharacters')
            Wait(1000)
            openUi()

            break
        end
    end
end)

RegisterNetEvent('lg-login:SetCharacters', function(chars)
    setCharacters(chars)
end)

RegisterNUICallback('createCharacter', function(data)
    for k,v in pairs(data) do
        if v == '' then
            return errorUi('Du skal udfylde alle felter.')
        end
    end

    TriggerServerEvent('lg-login:createCharacter', data)
end)

RegisterNUICallback('deleteCharacter', function(data)
    TriggerServerEvent('lg-login:deleteCharacter', data.id)
end)

RegisterNUICallback('selectChar', function(data)
    TriggerServerEvent('lg-login:selectChar', data.id)
end)

RegisterNetEvent('lg-login:SelectedCharacter', function()
    closeUi()
    DoScreenFadeOut(1)

    SpawnPlayer()
end)