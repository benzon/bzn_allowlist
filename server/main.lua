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
    
    deferrals.update('Tjekker allowliste og banliste')
    
    Wait(500)
    
    local Identifiers = PlayerIdentifiers(source)
    
    print(Identifiers[Config.Identifier])
    
    if Config.AutoAddFirstConnect and next(Allowlist) == nil then
        deferrals.update('Tilføjer dit id til allowlisten')
        
        SaveToMySQL(Identifiers[Config.Identifier])
        
        Wait(5000)
    end
    
    if not Allowlist[Identifiers[Config.Identifier]] then
        deferrals.done('Du er ikke allowlisted')
        CancelEvent()
        return
    end
    
    deferrals.done()
end)

AlterAllowlist = function(args, source, type)
    local type = type
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
                    identifierLength = '17 ved Steam64 og 15 ved Steam Hex'
                end
                
                SendMessage(source, 'Der er fejl i identifieren ' .. Config.Identifier .. 'ID skal have en længde på ' .. identifierLength .. ' uden ' .. Config.Identifier .. ': Indtastede længde var ' .. string.len(identifier), 'error')
                return
            end
            
            if not Allowlist[identifier] and type == 'add' then
                SaveToMySQL(identifier)
                
                SendMessage(source, 'Du har tilføjet ' .. identifier .. ' til allowlisten', 'success')
                return
            end

            if Allowlist[identifier] and type == 'remove' then
                DeleteFromMySQL(identifier)
                
                SendMessage(source, 'Du har fjernet ' .. identifier .. ' fra allowlisten', 'success')
                return
            end
            
            if type == 'add' then
                SendMessage(source, 'Du prøvede at tilføjet ' .. identifier .. ' til allowlisten, personen er allerede allowlisted', 'warning')
                return
            end
        
            if type == 'remove' then
                SendMessage(source, 'Du prøvede at fjerne ' .. identifier .. ' fra allowlisten, personen er ikke allowlisted', 'warning')
                return
            end
        end
        
        SendMessage(source, 'Der er fejl i identifieren der mangler steam: eller license:', 'error')
        return
    end
    
    SendMessage(source, 'Du mangler at angive en identifier', 'error')
    return
end

RemoveFromAllowlist = function()
    end

LoadAllowlist = function()
    MySQL.Async.fetchAll('SELECT * FROM bzn_allowlist', {}, function(result)
        for i = 1, #result, 1 do
            Allowlist[tostring(result[i].identifier):lower()] = tonumber(result[i].priority)
        end
        
        print('^2[bzn_allowlist] Loaded ' .. #result .. ' players^7')
        
        if Config.AutoAddFirstConnect and #result == 0 then
            print('^3[bzn_allowlist] Warning first person that connects will be auto allowlisted!^7')
        end
    end)
end

SaveToMySQL = function(identifier)
    Allowlist[identifier] = 0
    
    MySQL.Async.execute('INSERT INTO bzn_allowlist (identifier) VALUES (@identifier)', {
        ['@identifier'] = identifier
    })
end

DeleteFromMySQL = function(identifier)
    Allowlist[identifier] = nil
    
    MySQL.Async.execute('DELETE FROM bzn_allowlist WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
end

MySQL.ready(function()
    LoadAllowlist()
end)
