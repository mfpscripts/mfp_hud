Config = {}

----------- SETTINGS ------------
Config.Framework = "ESX" -- ESX or QBCORE
Config.Locale = 'en' -- en, de, es, fr, nl, ch, pl, ru, tr

-------- COMMAND ---------
Config.usecommand = false -- /hud command to open/close hud
--------------------------

------- HEARTBAR --------
Config.useheartbar = true -- use the helth bar from our hud
-------------------------

----- MINIMAP -------
-- disable all if nothing should change ---
Config.DisableRadarWalking = true -- disable minimap while walking around (more realistic)
Config.DisableRadarDriving = false -- disable minimap while driving
--------------------------------

----- VEHICLE SETTINGS ----
Config.useMph = false -- enable if you want to use mph and not kph
Config.useIndicators = true -- if you want to use indicators whith arrow keys, automaticly turn blinking stop
Config.LeaveEngineOn = true -- if press F a long time, you leave vehicle and engine is still on
Config.useSpeedLimiter = true -- if you want to use Speed Limiter when pressing B to max speed
Config.SpeedLimiterKey = 29 -- B by default for limiting and releasing speed limiter


------- MILEAGE -------
Config.useMilage = true -- if you use mfp_mileage or myMileage
-- MFP_Mileage for free: https://store.mfpscripts.com/package/6136980

------- FUELSYSTEM --------
Config.FuelScript = 'native'
-- 'native' for default natives
-- 'legacyfuel' for LegacyFuel (https://github.com/InZidiuZ/LegacyFuel)
-- 'myFuel' for myFuel (https://shop.myscripts.eu/package/5502279)
-- 'hyon_gas_station' for HyonGasStation (https://github.com/HyonScript/hyon_gas_station/tree/main)
-- 'frfuel' for FRFuel (https://github.com/thers/FRFuel)
-- 'custom' for custom script

function GetCustomFuel(vehicle)
    -- add custom fuel script here if Config.FuelScript = 'custom'

    local fuel = GetVehicleFuelLevel(vehicle)

    return fuel
end
-----------------------

------ VOICEPLUGIN ------
Config.enableProximityChangeNotification = true -- shows a message when changing range
Config.changeProximityKey = 20 -- Y (ger) / Z (eng) by default to change proximity range

-- Your Plugin will be detected automatic --
Config.CustomVoicePlugin = '' -- only set if not detected automaticly
-- 'PMA' for pma-voice
-- 'SaltyChat' for saltychat
-- more are currently not supported!

------ SALTYCHAT -------
-- Change VoicePlugin --
Config.Saltyvoicerange1 = 2
Config.Saltyvoicerange2 = 8
Config.Saltyvoicerange3 = 15
Config.Saltyvoicerange4 = 32

------- PMA VOICE ------
-- Change VoicePlugin --
Config.PMAvoicerange1 = 1.5 -- default pma settings, I use 3.5
Config.PMAvoicerange2 = 3.0 -- default pma settings, I use 7
Config.PMAvoicerange3 = 6.0 -- default pma settings, I use 15
-- find out what are urs at pma-voice/shared.lua line 47
-------------------------

------- DISCORD --------
Dicordlogging = false -- type true to enable it!
DiscordWebhook = {
        ['webhook'] = '', -- your webhooklink here
}
------------------------

-------------------------------------
-- CREDITS: LuxCoding & MFPSCRIPTS --
-------------------------------------