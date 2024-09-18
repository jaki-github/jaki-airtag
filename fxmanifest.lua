fx_version 'cerulean'
games { 'gta5' }

author 'Made by Jaki'

client_scripts {
    'config.lua',
    'client/c_airtag.lua'
}

server_scripts {
    'server/s_airtag.lua'
}

shared_scripts {
    '@qb-core/shared/locale.lua'
}

dependencies {
    'qb-core'
}