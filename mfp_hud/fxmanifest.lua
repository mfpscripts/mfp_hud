fx_version 'cerulean'
games { 'gta5' }

description 'MFP_HUD'
author 'MFPSCRIPTS'
version '1.5 IN ARBEIT'
lua54 'yes'

escrow_ignore {
  'config.lua',
  'client.lua', 
  'server.lua',
  'translations.lua'
}

ui_page 'html/index.html'

client_scripts {
	'config.lua',
	'client.lua',
  'translations.lua'
}

server_scripts {
	'config.lua',
	'server.lua',
  'server_encrypted.lua',
	'@mysql-async/lib/MySQL.lua',
  'translations.lua'
}

dependency {
  'mfp_mileage'
}

files {
    'html/index.html',
    'html/webfonts/*',
    'html/js/*',
    'html/img/*',
    'html/css/*'
}
