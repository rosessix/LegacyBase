fx_version 'cerulean'

game 'gta5'

author 'legacy#0415'

description [[
    LegacyBase is a framework for creating GTA V addons (FiveM).
    It is a guideline/help to those, who want to create something "custom", without having to make everything from scratch.
]]

shared_scripts {
    'shared/*'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*'
}

client_scripts {
    'client/*'
}

export 'addComponent'
export 'getComponent'
server_export 'addComponent'
server_export 'getComponent'
