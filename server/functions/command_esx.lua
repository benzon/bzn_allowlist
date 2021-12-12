if Config.ESX and not Config.Ace then
    ESX.RegisterCommand('+allowlist', 'admin', function(xPlayer, args, showError)
        local source = false

        if xPlayer then
            source = xPlayer.source
        end
        
        AlterAllowlist(args, source, 'add')
    end, true)
    
    ESX.RegisterCommand('-allowlist', 'admin', function(xPlayer, args, showError)
        local source = false

        if xPlayer then
            source = xPlayer.source
        end
        
        AlterAllowlist(args, source, 'remove')
    end, true)

    if Config.EnableConnectQueue and Config.Identifier == 'steam' then
        ESX.RegisterCommand('priority', 'admin', function(xPlayer, args, showError)
            local source = false

            if xPlayer then
                source = xPlayer.source
            end
            
            AlterAllowlist(args, source, 'update')
        end, true)
    end
    
    ESX.RegisterCommand('reloadallowlist', 'admin', function(xPlayer, args, showError)
        local source = false

        if xPlayer then
            source = xPlayer.source
        end
        
        table.wipe(Allowlist)
        
        LoadAllowlist()
        
        SendMessage(source, _U('reloaded'), 'success')
    end, true)
end
