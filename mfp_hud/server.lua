------------ DISCORD LOGGING --------------
RegisterServerEvent('mfp_hud:discordlog')
AddEventHandler('mfp_hud:discordlog', function(message, webhook)
sendLogs(message , webhook)
end)
---------------------------------------------

--- you can change to your own db place for your script if you want --
-- we only encrypted little parts that are not needed to change, just against leaking. --
-- HAVE FUN WITH THIS HUD! MFPSCRIPTS.com and luxcoding.de for more!