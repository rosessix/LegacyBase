local anim_dict = 'dead'
local anim_anim = 'dead_a'
local isDead = false
local animating = false
local deathTimer = 5
local holdTimer = 5

RegisterCommand('die', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        
        if IsEntityDead(ped) then -- Check if we are dead
            -- if we are dead confirm it, and locally ressurect and perform anim
            SetEntityInvincible(ped, true)
            SetEntityHealth(ped, GetEntityMaxHealth(ped))

            isDead = true
            
            doDeathAnimation()
        end

        if isDead then
            doDeathAnimation()
            Wait(500)
        end
        Citizen.Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if isDead then
            sleep = 1
            if deathTimer > 0 then
                LG.Library:Draw2DText('Respawn in ~r~'..deathTimer..'~w~ seconds')
            else
                LG.Library:Draw2DText(string.format('Hold ~r~SHIFT~w~ + ~r~E~w~ to respawn ~r~(%s)~w~', LG.Library:Round(holdTimer, 1)))
                if IsControlPressed(0, 21) and IsControlPressed(0, 38) then
                    holdTimer = holdTimer - 0.01
                    if holdTimer <= 0 then
                        TriggerServerEvent('lg-base:PlayerResurrect')
                        holdTimer = 5
                    end
                else
                    holdTimer = 5
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if isDead then
            if deathTimer > 0 then
                deathTimer = deathTimer - 1
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('lg-base:RessurectPlayer', function()
    local ped = PlayerPedId()
    SetEntityInvincible(ped, false)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedTasks(ped)

    isDead = false
    deathTimer = 5

    DoScreenFadeOut(500)
    Citizen.Wait(500)

    SetEntityCoords(ped, GetEntityCoords(ped))
    DoScreenFadeIn(1500)
end)

function doDeathAnimation()
    if not animating then
        animating = true
        LG.Library:LoadAnimDict(anim_dict)
    
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
    
        if not IsEntityPlayingAnim(ped, anim_dict, anim_anim, 3) then
            SetEntityCoords(PlayerPedId(),GetEntityCoords(PlayerPedId()))
            ClearPedTasksImmediately(PlayerPedId())
            TaskPlayAnim(PlayerPedId(), anim_dict, anim_anim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        end
        animating = false
    end
end