-- config.lua
Config = {}
Config.MenuTitle   = 'XP Leaderboard'
Config.CommandName = 'xp'

-- Double XP Weekends
-- Set DoubleXPWeekend = true to auto-double XP on Saturday & Sunday.
-- Set DoubleXPWeekend = false to disable entirely.
-- XPMultiplier controls the amount (2 = double, 3 = triple, etc.)
Config.DoubleXPWeekend = true
Config.XPMultiplier    = 2

-- Define rewards for specific XP levels
Config.LevelRewards = {
    -- Levels 20 to 50: 10 x smallnugget
    [20] = {
        items = {
            { name = "smallnugget", amount = 10 }
        },
        notification = "XP 20 Reached - Reward = Small Gold Nuggets"
    },
    [30] = {
        items = {
            { name = "smallnugget", amount = 10 }
        },
        notification = "XP 30 Reached - Reward = Small Gold Nuggets"
    },
    [40] = {
        items = {
            { name = "smallnugget", amount = 10 }
        },
        notification = "XP 40 Reached - Reward = Small Gold Nuggets"
    },
    [50] = {
        items = {
            { name = "smallnugget", amount = 10 }
        },
        notification = "XP 50 Reached - Reward = Small Gold Nuggets"
    },
    
    -- Levels 100 to 200: 10 x mediumnugget
    [100] = {
        items = {
            { name = "mediumnugget", amount = 10 }
        },
        notification = "XP 100 Reached - Reward = Medium Gold Nuggets"
    },
    [125] = {
        items = {
            { name = "mediumnugget", amount = 10 }
        },
        notification = "XP 125 Reached - Reward = Medium Gold Nuggets"
    },
    [150] = {
        items = {
            { name = "mediumnugget", amount = 10 }
        },
        notification = "XP 150 Reached - Reward = Medium Gold Nuggets"
    },
    [175] = {
        items = {
            { name = "mediumnugget", amount = 10 }
        },
        notification = "XP 175 Reached - Reward = Medium Gold Nuggets"
    },
    [200] = {
        items = {
            { name = "mediumnugget", amount = 10 }
        },
        notification = "XP 200 Reached - Reward = Medium Gold Nuggets"
    },
    
    -- Levels 300 to 600: 10 x largenugget
    [300] = {
        items = {
            { name = "largenugget", amount = 10 }
        },
        notification = "XP 300 Reached - Reward = Large Gold Nuggets"
    },
    [350] = {
        items = {
            { name = "largenugget", amount = 10 }
        },
        notification = "XP 350 Reached - Reward = Large Gold Nuggets"
    },
    [400] = {
        items = {
            { name = "largenugget", amount = 10 }
        },
        notification = "XP 400 Reached - Reward = Large Gold Nuggets"
    },
    [450] = {
        items = {
            { name = "largenugget", amount = 10 }
        },
        notification = "XP 450 Reached - Reward = Large Gold Nuggets"
    },
    [500] = {
        items = {
            { name = "largenugget", amount = 10 }
        },
        notification = "XP 500 Reached - Reward = Large Gold Nuggets"
    },
    [550] = {
        items = {
            { name = "largenugget", amount = 10 }
        },
        notification = "XP 550 Reached - Reward = Large Gold Nuggets"
    },
    [600] = {
        items = {
            { name = "largenugget", amount = 10 }
        },
        notification = "XP 600 Reached - Reward = Large Gold Nuggets"
    },
    
    -- Levels 700 to 1000: 5 x goldbar
    [700] = {
        items = {
            { name = "goldbar", amount = 5 }
        },
        notification = "XP 700 Reached - Reward = Gold Bars"
    },
    [750] = {
        items = {
            { name = "goldbar", amount = 5 }
        },
        notification = "XP 750 Reached - Reward = Gold Bars"
    },
    [800] = {
        items = {
            { name = "goldbar", amount = 5 }
        },
        notification = "XP 800 Reached - Reward = Gold Bars"
    },
    [850] = {
        items = {
            { name = "goldbar", amount = 5 }
        },
        notification = "XP 850 Reached - Reward = Gold Bars"
    },
    [900] = {
        items = {
            { name = "goldbar", amount = 5 }
        },
        notification = "XP 900 Reached - Reward = Gold Bars"
    },
    [950] = {
        items = {
            { name = "goldbar", amount = 5 }
        },
        notification = "XP 950 Reached - Reward = Gold Bars"
    },
    [1000] = {
        items = {
            { name = "goldbar", amount = 5 }
        },
        notification = "XP 1000 Reached - Reward = Gold Bars"
    },
    
    -- Levels 1000 to 2000: 10 x goldbar
    [1200] = {
        items = {
            { name = "goldbar", amount = 10 }
        },
        notification = "XP 1200 Reached - Reward = Gold Bars"
    },
    [1400] = {
        items = {
            { name = "goldbar", amount = 10 }
        },
        notification = "XP 1400 Reached - Reward = Gold Bars"
    },
    [1600] = {
        items = {
            { name = "goldbar", amount = 10 }
        },
        notification = "XP 1600 Reached - Reward = Gold Bars"
    },
    [1800] = {
        items = {
            { name = "goldbar", amount = 10 }
        },
        notification = "XP 1800 Reached - Reward = Gold Bars"
    },
    [2000] = {
        items = {
            { name = "goldbar", amount = 10 }
        },
        notification = "XP 2000 Reached - Reward = Gold Bars"
    },
    
    -- Levels 2000 to 5000: 15 x goldbar
    [2500] = {
        items = {
            { name = "goldbar", amount = 15 }
        },
        notification = "XP 2500 Reached - Reward = Gold Bars"
    },
    [3000] = {
        items = {
            { name = "goldbar", amount = 15 }
        },
        notification = "XP 3000 Reached - Reward = Gold Bars"
    },
    [3500] = {
        items = {
            { name = "goldbar", amount = 15 }
        },
        notification = "XP 3500 Reached - Reward = Gold Bars"
    },
    [4000] = {
        items = {
            { name = "goldbar", amount = 15 }
        },
        notification = "XP 4000 Reached - Reward = Gold Bars"
    },
    [4500] = {
        items = {
            { name = "goldbar", amount = 15 }
        },
        notification = "XP 4500 Reached - Reward = Gold Bars"
    },
    [5000] = {
        items = {
            { name = "goldbar", amount = 15 }
        },
        notification = "XP 5000 Reached - Reward = Gold Bars"
    },
    
    -- Levels 5000 to 10000: 20 x goldbar
    [6000] = {
        items = {
            { name = "goldbar", amount = 20 }
        },
        notification = "XP 6000 Reached - Reward = Gold Bars"
    },
    [7000] = {
        items = {
            { name = "goldbar", amount = 20 }
        },
        notification = "XP 7000 Reached - Reward = Gold Bars"
    },
    [8000] = {
        items = {
            { name = "goldbar", amount = 20 }
        },
        notification = "XP 8000 Reached - Reward = Gold Bars"
    },
    [9000] = {
        items = {
            { name = "goldbar", amount = 20 }
        },
        notification = "XP 9000 Reached - Reward = Gold Bars"
    },
    [10000] = {
        items = {
            { name = "goldbar", amount = 20 }
        },
        notification = "XP 10000 Reached - Reward = Gold Bars"
    },
    
    -- Levels 10000 to 20000: 25 x goldbar
    [12000] = {
        items = {
            { name = "goldbar", amount = 25 }
        },
        notification = "XP 12000 Reached - Reward = Gold Bars"
    },
    [14000] = {
        items = {
            { name = "goldbar", amount = 25 }
        },
        notification = "XP 14000 Reached - Reward = Gold Bars"
    },
    [16000] = {
        items = {
            { name = "goldbar", amount = 25 }
        },
        notification = "XP 16000 Reached - Reward = Gold Bars"
    },
    [18000] = {
        items = {
            { name = "goldbar", amount = 25 }
        },
        notification = "XP 18000 Reached - Reward = Gold Bars"
    },
    [20000] = {
        items = {
            { name = "goldbar", amount = 25 }
        },
        notification = "XP 20000 Reached - Reward = Gold Bars"
    },
    
    -- Levels 20000 to 50000: 30 x goldbar
    [25000] = {
        items = {
            { name = "goldbar", amount = 30 }
        },
        notification = "XP 25000 Reached - Reward = Gold Bars"
    },
    [30000] = {
        items = {
            { name = "goldbar", amount = 30 }
        },
        notification = "XP 30000 Reached - Reward = Gold Bars"
    },
    [35000] = {
        items = {
            { name = "goldbar", amount = 30 }
        },
        notification = "XP 35000 Reached - Reward = Gold Bars"
    },
    [40000] = {
        items = {
            { name = "goldbar", amount = 30 }
        },
        notification = "XP 40000 Reached - Reward = Gold Bars"
    },
    [45000] = {
        items = {
            { name = "goldbar", amount = 30 }
        },
        notification = "XP 45000 Reached - Reward = Gold Bars"
    },
    [50000] = {
        items = {
            { name = "goldbar", amount = 30 }
        },
        notification = "XP 50000 Reached - Reward = Gold Bars"
    },
    
    -- Levels 50000 to 100000: 50 x goldbar
    [60000] = {
        items = {
            { name = "goldbar", amount = 50 }
        },
        notification = "XP 60000 Reached - Reward = Gold Bars"
    },
    [70000] = {
        items = {
            { name = "goldbar", amount = 50 }
        },
        notification = "XP 70000 Reached - Reward = Gold Bars"
    },
    [80000] = {
        items = {
            { name = "goldbar", amount = 50 }
        },
        notification = "XP 80000 Reached - Reward = Gold Bars"
    },
    [90000] = {
        items = {
            { name = "goldbar", amount = 50 }
        },
        notification = "XP 90000 Reached - Reward = Gold Bars"
    },
    [100000] = {
        items = {
            { name = "goldbar", amount = 50 },
            { name = "largenugget", amount = 100 },
            { name = "present", amount = 10 }
        },
        notification = "XP 100000 Reached - ULTIMATE REWARD - Gold Bars, Large Nuggets and Presents!"
    }
}