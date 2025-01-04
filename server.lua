local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    if Config.LogPlayerJoinLeave then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("Player %s is joining the server.", name)
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Player Join', timestamp)
    end
end)

AddEventHandler('playerDropped', function(reason)
    if Config.LogPlayerJoinLeave then
        local playerName = GetPlayerName(source)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("%s has left the server. Reason: %s", playerName, reason)
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Player Leave', timestamp)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if Config.LogResourceEvents then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("Resource '%s' started.", resourceName)
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Resource Start', timestamp)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if Config.LogResourceEvents then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("Resource '%s' stopped.", resourceName)
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Resource Stop', timestamp)
    end
end)

AddEventHandler('txAdmin:BanPlayer', function(playerId, reason, source)
    if Config.LogTxAdminEvents then
        local playerName = GetPlayerName(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("Admin banned player %s. Reason: %s", playerName, reason)
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Player Banned', timestamp)
    end
end)

AddEventHandler('txAdmin:KickPlayer', function(playerId, reason)
    if Config.LogTxAdminEvents then
        local playerName = GetPlayerName(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("Admin kicked player %s. Reason: %s", playerName, reason)
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Player Kicked', timestamp)
    end
end)

AddEventHandler('txAdmin:WarnPlayer', function(playerId, reason)
    if Config.LogTxAdminEvents then
        local playerName = GetPlayerName(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("Admin warned player %s. Reason: %s", playerName, reason)
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Player Warned', timestamp)
    end
end)

AddEventHandler('txAdmin:ShutdownServer', function()
    if Config.LogTxAdminEvents then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("Server shutdown initiated by admin.")
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Server Shutdown', timestamp)
    end
end)

RegisterCommand('logPlayerAim', function(source, args)
    if Config.LogPlayerAim then
        local player = QBCore.Functions.GetPlayer(source)
        local playerName = GetPlayerName(source)
        local weapon = GetSelectedPedWeapon(GetPlayerPed(source))
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local targetPed = args[1]
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)
        
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("%s aimed at %s with weapon %s at distance %.2f meters.", playerName, targetPed, weapon, distance)
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Player Aim', timestamp)
    end
end)

AddEventHandler('explosionEvent', function(coords, creator)
    if Config.LogExplosions then
        local playerName = GetPlayerName(creator)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("%s caused an explosion at coordinates (%.2f, %.2f, %.2f).", playerName, coords.x, coords.y, coords.z)
        SaveLog(logMessage)
        SendToWebhook(logMessage, 'Explosion', timestamp)

        TriggerEvent('screenshot:take', coords, function(screenshotData)
            local screenshotPath = SaveScreenshot(screenshotData)
            logMessage = string.format("Explosion screenshot saved at: %s", screenshotPath)
            SaveLog(logMessage)
            SendToWebhook(logMessage, 'Explosion Screenshot', timestamp)
        end)
    end
end)

function SaveLog(message)
    if Config.EnableLogging then
        local file = io.open(Config.LogFilePath, 'a')
        if file then
            file:write(message)
            file:close()
        end
    end
end

function SaveScreenshot(screenshotData)
    local screenshotPath = 'screenshots/explosion_' .. os.date("%Y-%m-%d_%H-%M-%S") .. '.png'
    return screenshotPath
end

function SendToWebhook(message, eventType, timestamp)
    local data = {
        embeds = {{
            title = eventType,
            description = message,
            color = 15258703,
            fields = {
                { name = 'Timestamp', value = timestamp, inline = true },
            },
            footer = {
                text = 'FiveM Server Logs'
            }
        }}
    }

    PerformHttpRequest(Config.WebhookURL, function(response)
        if response ~= 204 then
            print('Failed to send log to webhook: ' .. response)
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end
