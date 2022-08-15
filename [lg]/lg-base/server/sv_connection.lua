LG.Connection = {}
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local steamIdentifier = LG.Connection:getIdentifier(src, 'steam:')
    deferrals.defer()
    if steamIdentifier == nil then return deferrals.done(LG.Locales[LG.Config.Language]['identifiermissing']) end
    deferrals.update(LG.Locales[LG.Config.Language]['welcome']:format(name))
    Wait(500)
    local firstTime = LG.Database:FirstConnection(steamIdentifier)
    if firstTime then
        local result = MySQL.query.await('INSERT INTO players (identifier, name, banned, whitelisted) VALUES (@identifier, @name, 0, 0)', {
            ['@identifier'] = steamIdentifier,
            ['@name'] = name
        })
        
        if LG.Config.Whitelist == true then
            deferrals.done(LG.Locales[LG.Config.Language]['not_whitelisted'])
        else
            deferrals.done()
        end

        return
    end
    
    local isBanned = LG.Database:IsPlayerBanned(steamIdentifier)

    if isBanned then
        deferrals.done(LG.Locales[LG.Config.Language]['banned'])
        return
    end

    deferrals.done()
end)

function LG.Connection:getIdentifier(source, _type)
    local identifiers = GetPlayerIdentifiers(source)
    if identifiers ~= nil then
        for k,v in pairs(identifiers) do
            if string.match(v, _type) then
                return v
            end
        end
    end
    return nil
end

CreateThread(function()
    addComponent('Connection', LG.Connection)
end)