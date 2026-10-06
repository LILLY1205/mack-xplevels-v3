-- ============================================================
--  mack-xplevels-v3  |  server.lua
-- ============================================================
local RSGCore = exports['rsg-core']:GetCoreObject()

-- ============================================================
--  DATABASE SETUP
-- ============================================================
MySQL.Async.execute([[
    CREATE TABLE IF NOT EXISTS player_levels (
        player_id   VARCHAR(50) NOT NULL,
        xp_level    INT         NOT NULL DEFAULT 1,
        PRIMARY KEY (player_id)
    )
]])

MySQL.Async.execute([[
    CREATE TABLE IF NOT EXISTS player_rewards_history (
        player_id      VARCHAR(50) NOT NULL,
        level_rewarded INT         NOT NULL,
        PRIMARY KEY (player_id, level_rewarded)
    )
]])

-- ============================================================
--  NOTIFICATION HELPER  (bln_notify via client event)
-- ============================================================
local function Notify(src, title, description, duration)
    TriggerClientEvent('mack-xplevels:client:notify', src, title, description, duration)
end

-- ============================================================
--  DOUBLE XP WEEKENDS
--  os.date wday: 1 = Sunday, 7 = Saturday
-- ============================================================
local function GetXPMultiplier()
    if not Config.DoubleXPWeekend then return 1 end
    local wday = os.date('*t').wday
    if wday == 1 or wday == 7 then
        return Config.XPMultiplier or 2
    end
    return 1
end

-- ============================================================
--  MILESTONE REWARDS
--  Checks every threshold crossed between oldXP and newXP so
--  no milestone is skipped when multiple XP is added at once.
-- ============================================================
local function CheckAndGiveRewards(src, citizenid, oldXP, newXP)
    for level, reward in pairs(Config.LevelRewards) do
        if level > oldXP and level <= newXP then
            MySQL.Async.fetchAll(
                'SELECT 1 FROM player_rewards_history WHERE player_id = @cid AND level_rewarded = @level',
                { ['@cid'] = citizenid, ['@level'] = level },
                function(result)
                    if result and #result > 0 then return end

                    local Player = RSGCore.Functions.GetPlayer(src)
                    if not Player then return end

                    local allGiven = true
                    for _, item in ipairs(reward.items) do
                        if RSGCore.Shared.Items[item.name] then
                            local ok = Player.Functions.AddItem(item.name, item.amount)
                            if ok then
                                TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item.name], 'add')
                            else
                                allGiven = false
                            end
                        else
                            allGiven = false
                        end
                    end

                    if allGiven then
                        Notify(src, 'Milestone Reward!', reward.notification, 8000)
                        MySQL.Async.execute(
                            'INSERT IGNORE INTO player_rewards_history (player_id, level_rewarded) VALUES (@cid, @level)',
                            { ['@cid'] = citizenid, ['@level'] = level }
                        )
                    end
                end
            )
        end
    end
end

-- ============================================================
--  COMMANDS
-- ============================================================

-- /xp  – open the XP leaderboard
RegisterCommand(Config.CommandName, function(source)
    TriggerClientEvent('mack-xplevels:openLeaderboard', source)
end, false)

-- /myxp  – player checks their own current XP
RegisterCommand('myxp', function(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    MySQL.Async.fetchAll(
        'SELECT xp_level FROM player_levels WHERE player_id = @cid',
        { ['@cid'] = Player.PlayerData.citizenid },
        function(result)
            local xp = (result and result[1]) and result[1].xp_level or 0
            Notify(source, 'Your XP', 'You currently have ' .. xp .. ' XP', 5000)
        end
    )
end, false)

-- Resolve citizenid from either a source ID (number) or citizenid (string)
local function ResolveCitizenId(input)
    local asNum = tonumber(input)
    if asNum then
        -- Treat as server source ID
        local Player = RSGCore.Functions.GetPlayer(asNum)
        return Player and Player.PlayerData.citizenid or nil
    end
    return input  -- already a citizenid string
end

-- /addxp <source_id or citizenid> <amount>  – admin (exact amount, no weekend multiplier)
RegisterCommand('addxp', function(source, args)
    if not args[1] or not args[2] then
        if source == 0 then print('[mack-xplevels] Usage: addxp <source_id or citizenid> <amount>') end
        return
    end
    local cid    = ResolveCitizenId(args[1])
    local amount = math.max(1, math.floor(tonumber(args[2]) or 1))
    if not cid then
        if source == 0 then print('[mack-xplevels] Player not found: ' .. args[1]) end
        if source ~= 0 then Notify(source, 'Admin XP', 'Player not found: ' .. args[1], 4000) end
        return
    end
    print('[mack-xplevels] /addxp called cid=' .. cid .. ' amount=' .. amount)

    MySQL.Async.fetchAll('SELECT * FROM player_levels WHERE player_id = @player_id', {
        ['@player_id'] = cid
    }, function(result)
        if result[1] then
            local oldXP = result[1].xp_level
            local newXP = oldXP + amount
            MySQL.Async.execute('UPDATE player_levels SET xp_level = @newLevel WHERE player_id = @player_id', {
                ['@newLevel']  = newXP,
                ['@player_id'] = cid
            }, function(success)
                print('[mack-xplevels] /addxp UPDATE result=' .. tostring(success) .. ' newXP=' .. newXP)
                if success then
                    if source == 0 then
                        print('[mack-xplevels] Added ' .. amount .. ' XP to ' .. cid .. ' (Total: ' .. newXP .. ')')
                    else
                        Notify(source, 'Admin XP', 'Added ' .. amount .. ' XP to ' .. cid .. ' (Total: ' .. newXP .. ')', 4000)
                    end
                    local Player = RSGCore.Functions.GetPlayerByCitizenId(cid)
                    if Player then
                        Notify(Player.PlayerData.source, 'XP Added', '+' .. amount .. ' XP  |  Total: ' .. newXP .. ' XP', 4000)
                        CheckAndGiveRewards(Player.PlayerData.source, cid, oldXP, newXP)
                    end
                end
            end)
        else
            MySQL.Async.execute('INSERT INTO player_levels (player_id, xp_level) VALUES (@player_id, @xp_level)', {
                ['@player_id'] = cid,
                ['@xp_level']  = amount
            }, function(success)
                print('[mack-xplevels] /addxp INSERT result=' .. tostring(success))
                if success then
                    if source == 0 then
                        print('[mack-xplevels] Added ' .. amount .. ' XP to ' .. cid .. ' (new record)')
                    else
                        Notify(source, 'Admin XP', 'Added ' .. amount .. ' XP to ' .. cid .. ' (Total: ' .. amount .. ')', 4000)
                    end
                    local Player = RSGCore.Functions.GetPlayerByCitizenId(cid)
                    if Player then
                        Notify(Player.PlayerData.source, 'XP Added', '+' .. amount .. ' XP  |  Total: ' .. amount .. ' XP', 4000)
                        CheckAndGiveRewards(Player.PlayerData.source, cid, 0, amount)
                    end
                end
            end)
        end
    end)
end, true)

-- /removexp <source_id or citizenid> <amount>  – admin
RegisterCommand('removexp', function(source, args)
    if not args[1] or not args[2] then
        if source == 0 then print('[mack-xplevels] Usage: removexp <source_id or citizenid> <amount>') end
        return
    end
    local cid    = ResolveCitizenId(args[1])
    local amount = math.max(1, math.floor(tonumber(args[2]) or 1))
    if not cid then
        if source == 0 then print('[mack-xplevels] Player not found: ' .. args[1]) end
        if source ~= 0 then Notify(source, 'Admin XP', 'Player not found: ' .. args[1], 4000) end
        return
    end
    print('[mack-xplevels] /removexp called cid=' .. cid .. ' amount=' .. amount)

    MySQL.Async.fetchAll('SELECT * FROM player_levels WHERE player_id = @player_id', {
        ['@player_id'] = cid
    }, function(result)
        if not result or #result == 0 then
            if source == 0 then
                print('[mack-xplevels] No XP record found for ' .. cid)
            else
                Notify(source, 'Admin XP', 'No record found for ' .. cid, 4000)
            end
            return
        end
        local newXP = math.max(0, result[1].xp_level - amount)
        MySQL.Async.execute('UPDATE player_levels SET xp_level = @newLevel WHERE player_id = @player_id', {
            ['@newLevel']  = newXP,
            ['@player_id'] = cid
        }, function(success)
            print('[mack-xplevels] /removexp UPDATE result=' .. tostring(success) .. ' newXP=' .. newXP)
            if success then
                if source == 0 then
                    print('[mack-xplevels] Removed ' .. amount .. ' XP from ' .. cid .. ' (Total: ' .. newXP .. ')')
                else
                    Notify(source, 'Admin XP', 'Removed ' .. amount .. ' XP from ' .. cid .. ' (Total: ' .. newXP .. ')', 4000)
                end
                local Player = RSGCore.Functions.GetPlayerByCitizenId(cid)
                if Player then
                    Notify(Player.PlayerData.source, 'XP Removed', '-' .. amount .. ' XP  |  Total: ' .. newXP .. ' XP', 4000)
                end
            end
        end)
    end)
end, true)

-- ============================================================
--  LEADERBOARD DATA
-- ============================================================
RegisterNetEvent('mack-xplevels:getLeaderboardData')
AddEventHandler('mack-xplevels:getLeaderboardData', function()
    local src    = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local currentCitizenId = Player.PlayerData.citizenid

    MySQL.Async.fetchAll([[
        SELECT pl.player_id, pl.xp_level, p.charinfo
        FROM player_levels pl
        INNER JOIN players p ON pl.player_id = p.citizenid
        WHERE pl.xp_level >= 1
        ORDER BY pl.xp_level DESC
    ]], {}, function(results)
        local leaderboardData = {}
        for i, data in ipairs(results) do
            local charinfo = json.decode(data.charinfo)
            table.insert(leaderboardData, {
                rank      = i,
                citizenid = data.player_id,
                name      = charinfo.firstname .. ' ' .. charinfo.lastname,
                xp        = data.xp_level,
            })
        end
        TriggerClientEvent('mack-xplevels:displayLeaderboard', src, leaderboardData, currentCitizenId)
    end)
end)

-- ============================================================
--  ADD XP  (pattern matches original working script exactly)
-- ============================================================
RegisterNetEvent('mack-xplevels:addXP')
AddEventHandler('mack-xplevels:addXP', function(citizenid, amount)
    amount = amount or 1

    local multiplier  = GetXPMultiplier()
    local finalAmount = math.floor(amount * multiplier)
    local bonusNote   = multiplier > 1 and ' [2x XP WEEKEND]' or ''

    print('[mack-xplevels] addXP called cid=' .. tostring(citizenid) .. ' amount=' .. tostring(finalAmount))

    MySQL.Async.fetchAll('SELECT * FROM player_levels WHERE player_id = @player_id', {
        ['@player_id'] = citizenid
    }, function(result)
        if result[1] then
            local oldXP = result[1].xp_level
            local newXP = oldXP + finalAmount
            MySQL.Async.execute('UPDATE player_levels SET xp_level = @newLevel WHERE player_id = @player_id', {
                ['@newLevel']  = newXP,
                ['@player_id'] = citizenid
            }, function(success)
                print('[mack-xplevels] UPDATE result=' .. tostring(success) .. ' cid=' .. tostring(citizenid) .. ' newXP=' .. tostring(newXP))
                if success then
                    local Player = RSGCore.Functions.GetPlayerByCitizenId(citizenid)
                    if Player then
                        local src = Player.PlayerData.source
                        Notify(src, 'XP Earned', '+' .. finalAmount .. ' XP  |  Total: ' .. newXP .. ' XP' .. bonusNote, 3500)
                        CheckAndGiveRewards(src, citizenid, oldXP, newXP)
                    end
                end
            end)
        else
            MySQL.Async.execute('INSERT INTO player_levels (player_id, xp_level) VALUES (@player_id, @xp_level)', {
                ['@player_id'] = citizenid,
                ['@xp_level']  = finalAmount
            }, function(success)
                print('[mack-xplevels] INSERT result=' .. tostring(success) .. ' cid=' .. tostring(citizenid) .. ' xp=' .. tostring(finalAmount))
                if success then
                    local Player = RSGCore.Functions.GetPlayerByCitizenId(citizenid)
                    if Player then
                        local src = Player.PlayerData.source
                        Notify(src, 'XP Earned', '+' .. finalAmount .. ' XP  |  Total: ' .. finalAmount .. ' XP' .. bonusNote, 3500)
                        CheckAndGiveRewards(src, citizenid, 0, finalAmount)
                    end
                end
            end)
        end
    end)
end)

-- ============================================================
--  REMOVE XP  (pattern matches original working script exactly)
-- ============================================================
RegisterNetEvent('mack-xplevels:removeXP')
AddEventHandler('mack-xplevels:removeXP', function(citizenid, amount)
    amount = amount or 1

    MySQL.Async.fetchAll('SELECT * FROM player_levels WHERE player_id = @player_id', {
        ['@player_id'] = citizenid
    }, function(result)
        if not result or #result == 0 then return end
        local newXP = math.max(0, result[1].xp_level - amount)
        MySQL.Async.execute('UPDATE player_levels SET xp_level = @newLevel WHERE player_id = @player_id', {
            ['@newLevel']  = newXP,
            ['@player_id'] = citizenid
        })
    end)
end)

-- ============================================================
--  GET PLAYER XP  (fires mack-xplevels:receivePlayerXP to client)
-- ============================================================
RegisterNetEvent('mack-xplevels:getPlayerXP')
AddEventHandler('mack-xplevels:getPlayerXP', function(citizenid)
    local src = source
    MySQL.Async.fetchAll(
        'SELECT xp_level FROM player_levels WHERE player_id = @cid',
        { ['@cid'] = citizenid },
        function(result)
            local xp = (result and result[1]) and result[1].xp_level or 0
            TriggerClientEvent('mack-xplevels:receivePlayerXP', src, xp)
        end
    )
end)

-- ============================================================
--  EXPORTS  (use from other server-side scripts)
-- ============================================================

exports('AddPlayerXP', function(citizenid, amount)
    TriggerEvent('mack-xplevels:addXP', citizenid, amount)
end)

exports('RemovePlayerXP', function(citizenid, amount)
    TriggerEvent('mack-xplevels:removeXP', citizenid, amount)
end)

exports('GetPlayerXP', function(citizenid, cb)
    MySQL.Async.fetchAll(
        'SELECT xp_level FROM player_levels WHERE player_id = @cid',
        { ['@cid'] = citizenid },
        function(result)
            cb((result and result[1]) and result[1].xp_level or 0)
        end
    )
end)
