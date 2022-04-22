fx_version "adamant"

game "gta5"

client_script "client.lua"

server_script "server.lua"

shared_script "shared.lua"

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/css/*.css',
    'ui/js/*.js',
}

lua54 'yes'