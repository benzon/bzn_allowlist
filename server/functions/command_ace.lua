if Config.Ace and not Config.ESX then
    RegisterCommand('+allowlist', function(source, args, rawCommand)
        local source = source
        
        if source == 0 or IsPlayerAceAllowed(source, 'command') then
            AlterAllowlist(args, source, 'add')
        end
    end, true)

    RegisterCommand('-allowlist', function(source, args, rawCommand)
        local source = source
        
        if source == 0 or IsPlayerAceAllowed(source, 'command') then
            AlterAllowlist(args, source, 'remove')
        end
    end, true)

    RegisterCommand('reloadallowlist', function(source, args, rawCommand)
        local source = source
        
        table.wipe(Allowlist)
        
        LoadAllowlist()
        
        if source == 0 then
            RconPrint('[bzn_allowlist] Reloaded')
            return
        end
        
        TriggerClientEvent('chat:addMessage', source, {
			args = {"^1[bzn_allowlist]", "Reloaded"}
		})
    end, true)
end
