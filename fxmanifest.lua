-- fxmanifest.lua

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- Autor a popis
author 'Jakubcze'
description 'McDonald\'s Drive-Thru Script with Configuration and Localization'
version '1.0.1'

-- Sdílené soubory
shared_scripts {
    'shared/config.lua',
    '@ox_lib/init.lua',
    'locales/locales.lua'
}

-- Klientské skripty
client_scripts {
    'client/client.lua'
}

-- Serverové skripty
server_scripts {
    'server/server.lua'
}
