fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_script 'config.lua'

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/font/crock.ttf',
    'html/img/clipboard.png',
    'html/xp1000.png',
    'html/xp2000.png',
    'html/xp3000.png',
    'html/xp4000.png',
    'html/xp5000.png',
    'html/xp6000.png',
    'html/xp7000.png',
    'html/xp8000.png',
    'html/xp9000.png',
    'html/xp10000.png',
    'html/fallback.png'
}

lua54 'yes'
