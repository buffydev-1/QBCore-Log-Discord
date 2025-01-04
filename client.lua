local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlPressed(0, 24) then
            local playerPed = PlayerPedId()
            local targetPed, targetDistance = GetClosestPlayerPed(playerPed)
            if targetPed then
                local playerCoords = GetEntityCoords(playerPed)
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(playerCoords - targetCoords)

                if distance <= 10.0 then
                    TriggerServerEvent('logPlayerAim', targetPed)
                end
            end
        end
    end
end)

function GetClosestPlayerPed(playerPed)
    local closestPlayerPed = nil
    local closestDistance = 100.0
    local players = GetActivePlayers()

    for i = 1, #players do
        local targetPed = GetPlayerPed(players[i])
        local targetCoords = GetEntityCoords(targetPed)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - targetCoords)

        if distance < closestDistance then
            closestPlayerPed = targetPed
            closestDistance = distance
        end
    end

    return closestPlayerPed, closestDistance
end
