LG.User = {}

function LG.User:GetPlayer(source)
    return LG.User[source]
end

function LG.User:GetPlayers()
    local players = {}

    for k,v in pairs(LG.User) do
        if type(v) ~= "function" then
            players[#players+1] = {
                id = v.id,
                username = v.username,
                identifier = v.steamIdentifier,
                source = v.source
            }
        end
    end

    return players
end

function LG.User:CreatePlayer(source, id)
    self.source = source
    self.id = id
    self.username = GetPlayerName(source)
    self.steamIdentifier = LG.Connection:getIdentifier(source, 'steam:')

    self.cash = 250
    self.balance = 500
    self.groups = {}

    self.rank = 'user'
    self.job = 'unemployed'

    exports['oxmysql']:query('SELECT * FROM characters WHERE id = @id', {
        ['@id'] = self.id
    }, function(res)
        if res[1] ~= nil then
            local data = res[1]

            self.cash = data.cash
            self.balance = data.balance

            if json.decode(data.groups) ~= nil then
                self.groups = json.decode(data.groups)
                for k,v in pairs(LG.Groups) do
                    for z,x in pairs(self.groups) do
                        if v.admin == true then
                            if k == z then
                                self.rank = k
                            end
                        end

                        if v.job == true then
                            self.job = k
                        end
                    end
                end
            end
        end
    end)

    function self.addGroup(_group)
        if self.groups == nil then self.groups = {} end
        local group = LG.Groups[_group]

        if group == nil then
            return LG.Logs:Log('warn', 'Group ' .. _group .. ' does not exist.')
        end

        
        if group.admin ~= nil and group.admin == true then
            if group.permissionlevel > LG.Groups[self.rank].permissionlevel then
                return LG.Logs:Log('warn', 'Player: ^3' .. self.username .. '^7 tried to add group ^4' .. _group .. '^7 but does not have permission.')
            end
            self.groups[self.rank] = nil
            self.rank = _group
        end

        if group.job ~= nil and group.job == true then
            LG.Groups[self.job] = nil
            self.job = _group
        end

        self.groups[_group] = true

        LG.Database:UpdateGroups(self.steamIdentifier, self.groups)
    end

    function self.removeGroup(_group)
        if self.groups == nil then self.groups = {} end
        if LG.Groups[_group].admin == true then self.rank = 'user' end
        self.groups[_group] = nil

        LG.Database:UpdateGroups(self.steamIdentifier, self.groups)
    end

    function self.hasGroup(_group)
        if self.groups == nil then self.groups = {} end
        return self.groups[_group] ~= nil
    end

    function self.isAdmin()
        for k,v in pairs(LG.Groups) do
            if v.admin == true then
                if self.groups[k] ~= nil then
                    return true
                end
            end
        end
        return false
    end

    function self.getJob()
        return self.job
    end

    function self.addCash(amount)
        self.cash = self.cash + amount
        LG.Database:UpdateCashAndBalance(self.steamIdentifier, self)
        return true
    end

    function self.removeCash(amount)
        local res = self.cash - amount
        if res < 0 then
            return false
        end

        self.cash = res
        LG.Database:UpdateCashAndBalance(self.steamIdentifier, self)
        return true
    end

    function self.addBalance(amount)
        self.balance = self.balance + amount
        LG.Database:UpdateCashAndBalance(self.steamIdentifier, self)
        return true
    end

    function self.removeBalance(amount)
        local res = self.balance - amount
        if res < 0 then
            return false
        end

        self.balance = res
        LG.Database:UpdateCashAndBalance(self.steamIdentifier, self)
        return true
    end


    LG.Logs:Log('trace', 'Player ' .. self.username .. ' (' .. self.steamIdentifier .. ') is now playing as id: ' .. self.id)
    LG.User[source] = self 
    return LG.User[source]
end

AddEventHandler('playerDropped', function(source, reason)
    local user = LG.User:GetPlayer(source)
    if user ~= nil then
        LG.Logs:Log('trace', 'Player ' .. user.username .. ' (' .. user.steamIdentifier .. ') has left the server.')
        LG.User[source] = nil
    end
end)

RegisterNetEvent('lg-base:PlayerResurrect', function()
    local user = LG.User:GetPlayer(source)
    if user ~= nil then
        TriggerClientEvent('lg-base:RessurectPlayer', source)
    end
end)

CreateThread(function()
    addComponent('User', LG.User)
end)