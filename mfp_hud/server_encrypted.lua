---------------------------------
--		    FRAMEWORK		   --
---------------------------------

if Config.Framework == 'ESX' then
  ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'QBCORE' then
  QBCore = exports['qb-core']:GetCoreObject()
end

---------------------------------
--			  Script		           --
---------------------------------

if Config.Framework == 'ESX' then
  ESX.RegisterServerCallback('mfp_hud:Getmoney', function(source, cb)
      local xPlayer = ESX.GetPlayerFromId(source)
      if xPlayer then
          cb(xPlayer.getMoney())
      else
          cb(0)
      end
  end)
elseif Config.Framework == 'QBCORE' then
  QBCore.Functions.CreateCallback('mfp_hud:Getmoney', function(source, cb)
      local Player = QBCore.Functions.GetPlayer(source)
      if Player then
          cb(Player.PlayerData.money["cash"] or 0)
      else
          cb(0)
      end
  end)
end


function sendLogs (message,webhook)
  if message == nil or message == '' then return FALSE end
  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ content = message }), { ['Content-Type'] = 'application/json' })
end

if Config.useIndicators then
  RegisterServerEvent('mfp_hud:syncIndicator')
  AddEventHandler('mfp_hud:syncIndicator', function(blinker)

    local _source = source
    TriggerClientEvent('mfp_hud:syncIndicator', -1, _source, blinker)
    
  end)
end -- end of Config.useIndicators


AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print(" _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ ")
    print("|     |   __|  _  |   __|     | __  |     |  _  |_   _|   __|")
    print("| | | |   __|   __|__   |   --|    -|-   -|   __| | | |__   |")
    print("|_|_|_|__|  |__|  |_____|_____|__|__|_____|__|    |_| |_____|")
    print("The resource " .. resourceName .. " has been started")
    if Dicordlogging then
          TriggerEvent('mfp_hud:discordlog', "**MFP_HUD** has been started succesfully!", DiscordWebhook['webhook'])
          end
  end)
  
  AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' was stopped. Created by MFPSCRIPTS x LuxCoding!')
  end)