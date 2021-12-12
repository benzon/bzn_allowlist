if Config.Ace and not Config.ESX then
    RegisterCommand('+allowlist', function(source, args, rawCommand)
        local source = source
        
        if source == 0 or IsPlayerAceAllowed(source, 'command.allowlist') then
            AlterAllowlist(args, source, 'add')

            return
        end
        
        SendMessage(source, _U('permissions'), 'error')
        return
    end)
    
    RegisterCommand('-allowlist', function(source, args, rawCommand)
        local source = source
        
        if source == 0 or IsPlayerAceAllowed(source, 'command.allowlist') then
            AlterAllowlist(args, source, 'remove')

            return
        end
        
        SendMessage(source, _U('permissions'), 'error')
        return
    end)
    
    if Config.EnableConnectQueue and Config.Identifier == 'steam' then
        RegisterCommand('priority', function(source, args, rawCommand)
            local source = source
            
            if source == 0 or IsPlayerAceAllowed(source, 'command.allowlist') then
                AlterAllowlist(args, source, 'update')

                return
            end
            
            SendMessage(source, _U('permissions'), 'error')
            return
        end)
    end
    
    RegisterCommand('reloadallowlist', function(source, args, rawCommand)
        local source = source
        
        if source == 0 or IsPlayerAceAllowed(source, 'command.allowlist') then
            table.wipe(Allowlist)
            
            LoadAllowlist()
            
            SendMessage(source, _U('reloaded'), 'success')
            return
        end
        
        SendMessage(source, _U('permissions'), 'error')
        return
    end)
end
