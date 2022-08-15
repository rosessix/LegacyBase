LG.Components = LG.Components or {}
exportsReady = false

function addComponent(name, component)
    if name == nil then
        return LG.Logs:Log('error', 'addComponent: name is nil')
    end
    if component == nil then
        return LG.Logs:Log('error', 'addComponent: component is nil')
    end

    if LG.Components[name] ~= nil then
        LG.Logs:Log('warn', 'Overriding Existing Component: ^2' .. tostring(name)..'^7')
        LG.Components[name] = component
        return
    end

    LG.Components[name] = component
    LG.Logs:Log('trace', 'Added Component: ^4' .. tostring(name).. '^7')
end

function getComponent(name)
    if name == nil then
        return LG.Logs:Log('error', 'getComponent: name is nil')
    end

    if LG.Components[name] == nil then
        LG.Logs:Log('error', 'getComponent: Component ^1' .. tostring(name).. '^7 does not exist')
        return
    end

    return LG.Components[name]
end

CreateThread(function()
    while true do
        Citizen.Wait(1)

        if exports and exports['lg-base'] and not exportsReady then
            exportsReady = true
            TriggerEvent('lg-base:Ready')
            break
        end
    end
end)

