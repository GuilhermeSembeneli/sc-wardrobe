fx_version 'cerulean'
game  'gta5' 

author 'Sembenevi#1018/Combat#0264'
description 'Script de guarda roupa para oficias'
version '1.0.0'

ui_page 'client/html/sc.html'


client_scripts {
    "@vrp/lib/utils.lua",
    'client/*',
}

server_scripts{
    "@vrp/lib/utils.lua",
    'server/scserver.lua',
    'server/configs.lua'
} 


files {
    'client/html/*',
    'client/html/img/mulher/*.png',
    'client/html/img/homem/*.png',
    'client/html/carousel/*.css',
    'client/html/carousel/*.js',
    'client/html/*.js',
}