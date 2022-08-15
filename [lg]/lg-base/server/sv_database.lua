LG.Database = LG.Database or {}

CreateThread(function()
    MySQL.query([[
    CREATE TABLE IF NOT EXISTS `players` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `name` text DEFAULT NULL,
        `identifier` text DEFAULT NULL,
        `banned` int(11) DEFAULT NULL,
        `whitelisted` int(11) DEFAULT NULL,
        PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function()
    end)
end)

function LG.Database:FirstConnection(identifier)
    local result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })

    if result[1] == nil then return true end
end

function LG.Database:IsPlayerBanned(identifier)
    local result = MySQL.Sync.fetchSingle('SELECT banned FROM players WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
    
    return result == true or false
end

function LG.Database:IsPlayerWhitelisted(identifier)
    local result = MySQL.Sync.query('SELECT whitelisted FROM players WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
    
    return result == true or false
end

function LG.Database:UpdateGroups(identifier, groups)
    exports['oxmysql']:query('UPDATE characters SET groups = @groups WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@groups'] = json.encode(groups)
    })
end

function LG.Database:UpdateCashAndBalance(identifier, user)
    exports['oxmysql']:query('UPDATE characters SET cash = @cash, balance = @balance WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@cash'] = user.cash,
        ['@balance'] = user.balance
    })
end