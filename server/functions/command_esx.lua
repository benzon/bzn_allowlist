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
        
        if source == nil then
            RconPrint('[bzn_allowlist] Reloaded')
            return
        end
        
        TriggerClientEvent('chat:addMessage', source, {
			args = {"^1[bzn_allowlist]", "Reloaded"}
		})
    end, true)
end
