PlayerIdentifiers = function(playerId)
    local Identifiers = {}

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, "steam:") then
            Identifiers['steam'] = v
        elseif string.match(v, "license:") then
            Identifiers['license'] = v
        elseif string.match(v, "xbl:") then
            Identifiers['xbl'] = v
        elseif string.match(v, "ip:") then
            Identifiers['ip'] = v
        elseif string.match(v, "discord:") then
            Identifiers['discord'] = v
        elseif string.match(v, "live:") then
            Identifiers['live'] = v
        end
    end

    return Identifiers
end

SendMessage = function(source, message, type)
    local MsgColor

    if type == 'success' then
        MsgColor = '^2'
    elseif type == 'warning'then
        MsgColor = '^3'
    elseif type == 'error' then
        MsgColor = '^1'
    end

    if source == nil or source == 0 or not source then
        RconPrint(MsgColor .. '[bzn_allowlist] ' .. message .. '^7')
        return
    end

    TriggerClientEvent('chat:addMessage', source, {
        args = {MsgColor .. '[bzn_allowlist]' .. '^7', message}
    })
end
