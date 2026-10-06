# mack-xplevels-v3 — Exports & Usage Guide

## SQL Tables Required
```sql
-- Auto-created on resource start, no manual setup needed
player_levels          (player_id, xp_level)
player_rewards_history (player_id, level_rewarded)
```

---

## Server-Side Exports

### AddPlayerXP
Adds XP to a player. Fires the XP earned notification and checks all milestone rewards.
```lua
exports['mack-xplevels-v3']:AddPlayerXP(citizenid, amount)
```
| Param | Type | Description |
|-------|------|-------------|
| citizenid | string | Player's citizenid |
| amount | number | XP to add (minimum 1) |

**Example — in any server.lua after a kill/action:**
```lua
local Player = RSGCore.Functions.GetPlayer(src)
if Player then
    exports['mack-xplevels-v3']:AddPlayerXP(Player.PlayerData.citizenid, 2)
end
```

---

### RemovePlayerXP
Removes XP from a player. Will not go below 0.
```lua
exports['mack-xplevels-v3']:RemovePlayerXP(citizenid, amount)
```
**Example:**
```lua
exports['mack-xplevels-v3']:RemovePlayerXP(Player.PlayerData.citizenid, 5)
```

---

### GetPlayerXP
Retrieves a player's current XP total. Uses a callback because it queries the database.
```lua
exports['mack-xplevels-v3']:GetPlayerXP(citizenid, function(xp)
    -- xp is a number (0 if player has no record)
end)
```
**Example — check XP before allowing an action:**
```lua
exports['mack-xplevels-v3']:GetPlayerXP(Player.PlayerData.citizenid, function(xp)
    if xp >= 500 then
        -- allow the action
    else
        -- deny and notify player
    end
end)
```

---

## Player Commands
| Command | Access | Description |
|---------|--------|-------------|
| `/xp` | All players | Opens the XP Leaderboard clipboard UI |
| `/myxp` | All players | Shows your current XP total via bln_notify |

## Admin Commands (ACE restricted)
| Command | Usage | Description |
|---------|-------|-------------|
| `/addxp` | `/addxp <citizenid> <amount>` | Add XP to any player |
| `/removexp` | `/removexp <citizenid> <amount>` | Remove XP from any player |

---

## Client-Side Events

### Receiving XP value (client)
If you need the player's XP on the client side, trigger the server event and listen for the response:
```lua
-- Request XP
TriggerServerEvent('mack-xplevels:getPlayerXP', citizenid)

-- Listen for response
RegisterNetEvent('mack-xplevels:receivePlayerXP')
AddEventHandler('mack-xplevels:receivePlayerXP', function(xp)
    -- xp is the player's current total
end)
```

---

## Adding Milestone Rewards (config.lua)
Rewards are defined in `config.lua` under `Config.LevelRewards`.
Each key is the XP total that triggers the reward.
Multiple items can be given at once.
```lua
[500] = {
    items = {
        { name = "goldbar", amount = 5 }
    },
    notification = "XP 500 Reached - Reward = Gold Bars"
},
```
> **Note:** Rewards are checked across the full range of XP gained in one call,
> so no milestone is skipped if a player earns multiple XP at once.
> Rewards are only given once per player per milestone (tracked in the DB).
