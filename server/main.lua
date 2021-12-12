Allowlist = {}

if not Config.ESX and not Config.Ace then
    print('^1[bzn_allowlist] Error you need to set either Config.ESX og Config.Ace to true else you wont be able to use commands - script not loaded^7')
    return
end

if Config.Identifier ~= 'steam' and Config.Identifier ~= 'license' then
    print('^1[bzn_allowlist] Error you can only use steam or license as identifier - script not loaded^7')
    return
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    local source = source
    
    deferrals.defer()
    
    deferrals.update(_U('allowlist_check'))
    
    Wait(500)
    
    local Identifiers = PlayerIdentifiers(source)
    
    if Config.AutoAddFirstConnect and next(Allowlist) == nil then
        deferrals.update(_U('auto_allowlist'))
        
        SaveToMySQL(Identifiers[Config.Identifier])
        
        Wait(5000)
    end
    
    if not Allowlist[Identifiers[Config.Identifier]] then
        deferrals.done(_U('not_allowlisted'))
        CancelEvent()
        return
    end
    
    deferrals.done()
end)

AlterAllowlist = function(args, source, callType)
    local callType = callType
    local identifier = tostring(args[1]):lower()
    
    if args[1] then
        if string.find(identifier, Config.Identifier .. ':') then
            identifier = string.gsub(identifier, Config.Identifier .. ':', '')
            
            local identifierLength = 0
            
            if Config.Identifier == 'steam' and string.len(identifier) == 17 then
                identifier = "steam:" .. string.format('%x', identifier)
            elseif Config.Identifier == 'steam' and string.len(identifier) == 15 then
                identifier = "steam:" .. identifier
            elseif Config.Identifier == 'license' and string.len(identifier) == 40 then
                identifier = "license:" .. identifier
                
                identifierLength = 40
            else
                if Config.Identifier == 'steam' then
                    identifierLength = _U('identifier_steam')
                end
                
                SendMessage(source, _U('identifier_length_error', Config.Identifier, identifierLength, Config.Identifier, string.len(identifier)), 'error')
                return
            end

            if Config.EnableConnectQueue and Config.Identifier == 'steam' and callType == 'add' or callType == 'update' then
                priority = 0

                if args[2] ~= nil then
                    local prio = tonumber(args[2])

                    if type(prio) == 'number' then
                        priority = args[2]
                    else
                        SendMessage(source, _U('priority_numeric'), 'error')
                        return
                    end
                end
            end
            
            if not Allowlist[identifier] and callType == 'add' then
                SaveToMySQL(identifier, priority)
                
                if priority ~= 0 then
                    SendMessage(source, _U('allowlist_added_with_priority', identifier, priority), 'success')
                    return
                end

                SendMessage(source, _U('allowlist_added', identifier), 'success')
                return
            end

            if Allowlist[identifier] and callType == 'remove' then
                DeleteFromMySQL(identifier)
                
                SendMessage(source, _U('allowlist_removed', identifier), 'success')
                return
            end

            if Allowlist[identifier] and callType == 'update' then
                UpdateMySQL(identifier, priority)
                
                SendMessage(source, _U('priority_updated', identifier, priority), 'success')
                return
            end
            
            if callType == 'add' then
                SendMessage(source, _U('allowlist_found', identifier), 'warning')
                return
            end
        
            if callType == 'remove' then
                SendMessage(source, _U('allowlist_not_found', identifier), 'warning')
                return
            end

            if callType == 'update' then
                SendMessage(source, _U('allowlist_not_found_priority', identifier), 'warning')
                return
            end
        end
        
        SendMessage(source, _U('identifier_error', Config.Identifier), 'error')
        return
    end
    
    SendMessage(source, _U('identifier_missing', Config.Identifier), 'error')
    return
end

LoadAllowlist = function()
    local TempPriorityList = {}
    local TempPriorityCount = 0

    MySQL.Async.fetchAll('SELECT * FROM bzn_allowlist', {}, function(result)
        for i = 1, #result, 1 do
            Allowlist[tostring(result[i].identifier):lower()] = tonumber(result[i].priority)

            if Config.EnableConnectQueue and Config.Identifier == 'steam' and result[i].priority > 0 then
                TempPriorityList[tostring(result[i].identifier):lower()] = result[i].priority
                
                TempPriorityCount = TempPriorityCount + 1
            end
        end
        
        if Config.EnableConnectQueue and Config.Identifier == 'steam' and TempPriorityCount ~= 0 then
            Queue.AddPriority(TempPriorityList)

            table.wipe(TempPriorityList)

            print('^2[bzn_allowlist] ' .. _U('allowlist_loaded_with_priority', #result, TempPriorityCount) .. '^7')
        else
            print('^2[bzn_allowlist] ' .. _U('allowlist_loaded', #result) .. '^7')
        end
        
        if Config.AutoAddFirstConnect and #result == 0 then
            print('^3[bzn_allowlist] ' ..  _U('auto_allowlist_warning') .. '^7')
        end
    end)
end

SaveToMySQL = function(identifier, priority)
    Allowlist[identifier] = 0

    if priority == nil then
        priority = 0
    elseif priority ~= 0 and Config.EnableConnectQueue and Config.Identifier == 'steam' then
        Queue.Exports:AddPriority(identifier, priority)
    end
    
    MySQL.Async.execute('INSERT INTO bzn_allowlist (identifier, priority) VALUES (@identifier, @priority)', {
        ['@identifier'] = identifier,
        ['@priority'] = priority
    })
end

DeleteFromMySQL = function(identifier)
    Allowlist[identifier] = nil
    
    MySQL.Async.execute('DELETE FROM bzn_allowlist WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
end

UpdateMySQL = function(identifier)
    Allowlist[identifier] = priority

    MySQL.Async.execute('UPDATE bzn_allowlist SET priority = @priority WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@priority'] = priority
    })

    Queue.Exports:AddPriority(identifier, priority)
end

MySQL.ready(function()
    LoadAllowlist()
end)
