LG.Logs = LG.Logs or {}
function LG.Logs:Log(_type, msg)
    local method = string.lower(_type)

    if method == 'warn' then
        doLog(3, _type, msg)
    end

    if method == 'trace' then
        doLog(5, _type, msg)
    end

    if method == 'error' then
        doLog(1, _type, msg)
    end

    if method == 'critical' then
        doLog(9, _type, msg)
    end
end

function doLog(color, _type, msg)
    local currDate = nil
    local timestamp = nil
    if IsDuplicityVersion() then
        currDate = os.date('%Y-%m-%d')
        timestamp = os.date('%I:%M:%S %p')
    end
    if GetInvokingResource() ~= nil then
        if timestamp ~= nil and currDate ~= nil then
            print('[^'..tonumber(color).. '' ..string.upper(_type).. '^7] [^2'.. GetInvokingResource().. '^7] [^5'.. timestamp ..'^7] '..msg.. '^7')
        else
            print('[^'..tonumber(color).. '' ..string.upper(_type).. '^7] [^2'.. GetInvokingResource().. '^7] '..msg.. '^7')

        end
    else
        if timestamp ~= nil and currDate ~= nil then
            print('[^'..tonumber(color).. '' ..string.upper(_type).. '^7] [^5'.. timestamp ..'^7] '..msg.. '^7')
        else
            print('[^'..tonumber(color).. '' ..string.upper(_type).. '^7] '..msg.. '^7')
        end
    end
end

CreateThread(function()
    addComponent('Log', LG.Logs)
end)
