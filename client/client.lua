-- ============================================================
--  mack-xplevels-v3  |  client.lua
-- ============================================================
local isUIOpen = false

-- ============================================================
--  bln_notify  (called from server)
-- ============================================================
RegisterNetEvent('mack-xplevels:client:notify')
AddEventHandler('mack-xplevels:client:notify', function(title, description, duration)
    TriggerEvent('bln_notify:send', {
        title       = title,
        description = description,
        icon        = 'leaderboard_xp',
        duration    = duration or 5000,
        placement   = 'bottom-right',
    })
end)

-- ============================================================
--  LEADERBOARD
-- ============================================================
RegisterNetEvent('mack-xplevels:openLeaderboard')
AddEventHandler('mack-xplevels:openLeaderboard', function()
    TriggerServerEvent('mack-xplevels:getLeaderboardData')
end)

RegisterNetEvent('mack-xplevels:displayLeaderboard')
AddEventHandler('mack-xplevels:displayLeaderboard', function(leaderboardData, currentCitizenId)
    if isUIOpen then return end
    isUIOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action           = 'openLeaderboardUI',
        leaderboardData  = leaderboardData,
        currentCitizenId = currentCitizenId,
    })
end)

-- ============================================================
--  RECEIVE XP  (other client scripts can listen for this)
-- ============================================================
RegisterNetEvent('mack-xplevels:receivePlayerXP')
AddEventHandler('mack-xplevels:receivePlayerXP', function(xp)
    -- Available for other client-side scripts to consume
end)

-- ============================================================
--  NUI CALLBACKS
-- ============================================================
RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    isUIOpen = false
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and isUIOpen then
        SetNuiFocus(false, false)
        isUIOpen = false
    end
end)
