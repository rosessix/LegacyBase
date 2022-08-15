RegisterCommand('givegroup', function(source, args)
    local user = exports['lg-base']:getComponent('User'):GetPlayer(source)
    user.addGroup(args[1])
end)

RegisterCommand('removegroup', function(source, args)
    local user = exports['lg-base']:getComponent('User'):GetPlayer(source)
    user.removeGroup(args[1])
end)

RegisterCommand('cash', function(source, args)
    local user = exports['lg-base']:getComponent('User'):GetPlayer(source)
    local type = args[1]
    local amount = tonumber(args[2])
    if type == 'add' then
        if user.addCash(amount) then
            print('it did it')
        end
    else
        if user.removeCash(amount) then
            print('could remove')
        end
    end
end)

RegisterCommand('balance', function(source, args)
    local user = exports['lg-base']:getComponent('User'):GetPlayer(source)
    local type = args[1]
    local amount = tonumber(args[2])
    if type == 'add' then
        if user.addBalance(amount) then
            print('it did it')
        end
    else
        if user.removeBalance(amount) then
            print('removed : ' .. amount)
        end
    end
end)

