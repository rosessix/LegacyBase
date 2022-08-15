CreateThread(function()
    exports['oxmysql']:query([[
        CREATE TABLE IF NOT EXISTS `characters` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` text DEFAULT NULL,
            `firstname` varchar(50) DEFAULT NULL,
            `lastname` varchar(50) DEFAULT NULL,
            `groups` text DEFAULT NULL,
            `cash` int(11) DEFAULT NULL,
            `balance` int(11) DEFAULT NULL
        ) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
    ]])
end)

RegisterNetEvent('lg-login:FetchCharacters', function(src)
    local source = source
    if src ~= nil then
        source = src
    end

    local steam = exports['lg-base']:getComponent('Connection'):getIdentifier(source, 'steam:')
    local chars = exports['oxmysql']:fetchSync('SELECT * FROM characters WHERE identifier = @identifier', {
        ['@identifier'] = steam
    })

    if chars == nil then chars = {} end

    TriggerClientEvent('lg-login:SetCharacters', source, chars)
end)

RegisterNetEvent('lg-login:createCharacter', function(data)
    local source = source
    local steam = exports['lg-base']:getComponent('Connection'):getIdentifier(source, 'steam:')
    local chars = exports['oxmysql']:fetchSync('SELECT * FROM characters WHERE identifier = @identifier', {
        ['@identifier'] = steam
    })

    if #chars < 3 then
        exports['oxmysql']:query('INSERT INTO characters (identifier, firstname, lastname, cash, balance) VALUES (@identifier, @firstname, @lastname, @cash, @balance)', {
            ['@identifier'] = steam,
            ['@firstname'] = data.firstname,
            ['@lastname'] = data.lastname,
            ['@cash'] = Config.StartingCash,
            ['@balance'] = Config.StartingBalance
        }, function(res)
            if res.affectedRows == 1 then
                TriggerEvent('lg-login:FetchCharacters', source)
            end
        end)
    end
end)

RegisterNetEvent('lg-login:deleteCharacter', function(id)
    local source = source
    local steam = exports['lg-base']:getComponent('Connection'):getIdentifier(source, 'steam:')
    exports['oxmysql']:fetch('SELECT * FROM characters WHERE id = @id AND identifier = @identifier', {
        ['@id'] = id,
        ['@identifier'] = steam
    }, function(res)
        if res[1] ~= nil and res[1].identifier == steam then
            exports['oxmysql']:query('DELETE FROM characters WHERE id = @id', {
                ['@id'] = id
            }, function(res)
                if res.affectedRows == 1 then
                    TriggerEvent('lg-login:FetchCharacters', source)
                end
            end)
        end
    end)
end)

RegisterNetEvent('lg-login:selectChar', function(id)
    local source = source
    local steam = exports['lg-base']:getComponent('Connection'):getIdentifier(source, 'steam:')
    exports['oxmysql']:fetch('SELECT * FROM characters WHERE id = @id AND identifier = @identifier', {
        ['@id'] = id,
        ['@identifier'] = steam
    }, function(res)
        if res[1] ~= nil and res[1].identifier == steam then
            local char = exports['lg-base']:getComponent('User'):CreatePlayer(source, id)
            if char then
                TriggerClientEvent('lg-login:SelectedCharacter', source)
            end
        end
    end)
end)