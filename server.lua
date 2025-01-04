local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    if Config.LogPlayerJoinLeave then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("[%s] %s is joining the server.\n", timestamp, name)
        SaveLog(logMessage)
        SendToWebhook(logMessage)
    end
end)

AddEventHandler('playerDropped', function(reason)
    if Config.LogPlayerJoinLeave then
        local playerName = GetPlayerName(source)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("[%s] %s has left the server. Reason: %s\n", timestamp, playerName, reason)
        SaveLog(logMessage)
        SendToWebhook(logMessage)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if Config.LogResourceEvents then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("[%s] Resource '%s' started.\n", timestamp, resourceName)
        SaveLog(logMessage)
        SendToWebhook(logMessage)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if Config.LogResourceEvents then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("[%s] Resource '%s' stopped.\n", timestamp, resourceName)
        SaveLog(logMessage)
        SendToWebhook(logMessage)
    end
end)

AddEventHandler('txAdmin:BanPlayer', function(playerId, reason, source)
    if Config.LogTxAdminEvents then
        local playerName = GetPlayerName(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("[%s] Admin banned player %s. Reason: %s\n", timestamp, playerName, reason)
        SaveLog(logMessage)
        SendToWebhook(logMessage)
    end
end)

AddEventHandler('txAdmin:KickPlayer', function(playerId, reason)
    if Config.LogTxAdminEvents then
        local playerName = GetPlayerName(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("[%s] Admin kicked player %s. Reason: %s\n", timestamp, playerName, reason)
        SaveLog(logMessage)
        SendToWebhook(logMessage)
    end
end)

AddEventHandler('txAdmin:WarnPlayer', function(playerId, reason)
    if Config.LogTxAdminEvents then
        local playerName = GetPlayerName(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("[%s] Admin warned player %s. Reason: %s\n", timestamp, playerName, reason)
        SaveLog(logMessage)
        SendToWebhook(logMessage)
    end
end)

AddEventHandler('txAdmin:ShutdownServer', function()
    if Config.LogTxAdminEvents then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("[%s] Server shutdown initiated by admin.\n", timestamp)
        SaveLog(logMessage)
        SendToWebhook(logMessage)
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
        local logMessage = string.format("[%s] %s aimed at %s with weapon %s at distance %.2f meters.\n", timestamp, playerName, targetPed, weapon, distance)
        SaveLog(logMessage)
        SendToWebhook(logMessage)
    end
end)

AddEventHandler('explosionEvent', function(coords, creator)
    if Config.LogExplosions then
        local playerName = GetPlayerName(creator)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local logMessage = string.format("[%s] %s caused an explosion at coordinates (%.2f, %.2f, %.2f).\n", timestamp, playerName, coords.x, coords.y, coords.z)
        SaveLog(logMessage)
        SendToWebhook(logMessage)

        TriggerEvent('screenshot:take', coords, function(screenshotData)
            local screenshotPath = SaveScreenshot(screenshotData)
            logMessage = string.format("[%s] Explosion screenshot saved at: %s\n", timestamp, screenshotPath)
            SaveLog(logMessage)
            SendToWebhook(logMessage)
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

function SendToWebhook(message)
    local data = {
        content = message
    }

    PerformHttpRequest(Config.WebhookURL, function(response)
        if response ~= 204 then
            print('Failed to send log to webhook: ' .. response)
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end
