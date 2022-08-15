fx_version 'cerulean'

game 'gta5'

lua54 'yes'

files {
    'client/html/*'
}

ui_page 'client/html/index.html'


client_scripts {
    'client/*'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*'
}