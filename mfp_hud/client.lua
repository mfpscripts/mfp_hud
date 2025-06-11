
ESX = exports["es_extended"]:getSharedObject()
-- local QBCore = exports['qb-core']:GetCoreObject()


local hud = true
local rangepercent = 0
local hunger = 0
local thirst = 0
local drunk = 0
local hungermassagesended = false
local thirstmassagesended = false

if Config.usecommand then 

	RegisterCommand("hud", function(source, args)

		if hud == true then 
            hud = false
            ESX.ShowNotification(Translation[Config.Locale]['Togglehudoff'])
            --QBCore.Functions.Notify(Translation[Config.Locale]['Togglehudoff'], 'primary')
        else
            hud = true
            ESX.ShowNotification(Translation[Config.Locale]['Togglehudon'])
            --QBCore.Functions.Notify(Translation[Config.Locale]['Togglehudoff'], 'primary')
        end

	end, args)

end

if (GetResourceState("saltychat") == "started") or Config.CustomVoicePlugin == 'SaltyChat' then
    Citizen.CreateThread(function ()
        while true do 
            range = exports.saltychat:GetVoiceRange(true)
            if range == Config.Saltyvoicerange1 then 
                rangepercent = 25
            elseif range == Config.Saltyvoicerange2 then 
                rangepercent = 50
            elseif range == Config.Saltyvoicerange3 then
                rangepercent = 75
            elseif range == Config.Saltyvoicerange4 then 
                rangepercent = 100
            end
            Citizen.Wait(250)
        end
    end)
elseif (GetResourceState("pma-voice") == "started") or Config.CustomVoicePlugin == 'PMA' then
    Citizen.CreateThread(function()
        while true do 
            local plyState = LocalPlayer.state
            local proximity = plyState.proximity
            range = proximity.distance
            
            if range == Config.PMAvoicerange1 then 
                rangepercent = 33
            elseif range == Config.PMAvoicerange2 then
                rangepercent = 66
            elseif range == Config.PMAvoicerange3 then
                rangepercent = 100
            end
            Citizen.Wait(250)
        end
    end)	
end


RegisterNetEvent('mfp_hud:updateStatus')
AddEventHandler('mfp_hud:updateStatus', function(status)
	for i=1, #status, 1 do
		if status[i].name == 'hunger' then 
			hunger = status[i].percent
		elseif status[i].name == 'thirst' then
			thirst = status[i].percent 
		elseif status[i].name == 'drunk' then
			drunk = status[i].percent 
		end
	end
end)

--[[
RegisterNetEvent('mfp_hud:updateStatus')
AddEventHandler('mfp_hud:updateStatus', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    
    hunger = PlayerData.metadata["hunger"]
    thirst = PlayerData.metadata["thirst"]
end)

AddEventHandler('qb-hud:client:SetPlayerStatus', function(status)
    TriggerEvent('mfp_hud:updateStatus')
end)
]]

RegisterNetEvent('hud:togglehud')
AddEventHandler('hud:togglehud', function()
	if hud == true then 
            hud = false
            ESX.ShowNotification(Translation[Config.Locale]['Togglehudoff'])
            --QBCore.Functions.Notify(Translation[Config.Locale]['Togglehudoff'], 'primary')

        else
            hud = true
            ESX.ShowNotification(Translation[Config.Locale]['Togglehudon'])
            --QBCore.Functions.Notify(Translation[Config.Locale]['Togglehudon'], 'primary')

        end
end)

if Config.enableProximityChangeNotification then
Citizen.CreateThread(function()
    while true do

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

       	if IsControlJustReleased(0, Config.changeProximityKey) then    
	    Citizen.Wait(10)
        if (GetResourceState("pma-voice") == "started") or Config.CustomVoicePlugin == 'PMA' then
	    print "--> Changed Proximity PMA. <--"
            local plyState = LocalPlayer.state
            local proximity = plyState.proximity
            local range = proximity.distance
	        if range == Config.PMAvoicerange1 then
                ESX.ShowNotification(Translation[Config.Locale]['fl'])
                --QBCore.Functions.Notify(Translation[Config.Locale]['fl'], 'primary')
            elseif range == Config.PMAvoicerange2 then
                ESX.ShowNotification(Translation[Config.Locale]['no'])
                -- QBCore.Functions.Notify(Translation[Config.Locale]['no'], 'primary')
            elseif range == Config.PMAvoicerange3 then
                ESX.ShowNotification(Translation[Config.Locale]['sc'])
                -- QBCore.Functions.Notify(Translation[Config.Locale]['sc'], 'primary')
            end
        elseif (GetResourceState("saltychat") == "started") or Config.CustomVoicePlugin == 'SaltyChat' then
            print "--> Changed Proximity Salty. <--"
            range = exports.saltychat:GetVoiceRange(true)
            if range == Config.Saltyvoicerange1 then 
                ESX.ShowNotification(Translation[Config.Locale]['fl'])
                --QBCore.Functions.Notify(Translation[Config.Locale]['fl'], 'primary')
            elseif range == Config.Saltyvoicerange2 then 
                ESX.ShowNotification(Translation[Config.Locale]['no'])
                --QBCore.Functions.Notify(Translation[Config.Locale]['no'], 'primary')
            elseif range == Config.Saltyvoicerange3 then
                ESX.ShowNotification(Translation[Config.Locale]['br'])
                --QBCore.Functions.Notify(Translation[Config.Locale]['br'], 'primary')
            elseif range == Config.Saltyvoicerange4 then 
                ESX.ShowNotification(Translation[Config.Locale]['sc'])
                --QBCore.Functions.Notify(Translation[Config.Locale]['sc'], 'primary')
            end
        end -- end of pma
	end
        Citizen.Wait(10)
    end
end)
end -- end of Config.enableProximityChangeNotification



Citizen.CreateThread(function()
    while true do
        if hud then 
            local map = IsPauseMenuActive()
            if map ~= 1 then
                --print("Debug: Before triggerServerCallback")
				ESX.TriggerServerCallback('mfp_hud:Getmoney', function(money)
                -- QBCore.Functions.TriggerCallback('mfp_hud:Getmoney', function(money)
                    local isMuted = false
                        --print("Debug: After 2te triggerServerCallback")
                        local heart = GetEntityHealth(GetPlayerPed(-1)) - 100
                        if heart == -100 then 
                            heart = 0
                        end
                        if Config.DisableRadarWalking then
                            DisplayRadar(false)
                        end
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            if Config.DisableRadarWalking then
                                if not Config.DisableRadarDriving then
                                DisplayRadar(true)
                                end
                            end
                            if Config.useMilage then
                                local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
                                local plate = GetVehicleNumberPlateText(veh)
                                --print("Debug: Before 3te triggerServerCallback")
                                ESX.TriggerServerCallback('helpscript:mfp_mileage:getcarmileage', function(milage)
                                --QBCore.Functions.TriggerCallback('helpscript:mfp_mileage:getcarmileage', function(milage)
                                    local maxtank = 100
                                    print("Milage: "..milage.. "Plate: "..plate)

                                    ------ fuel
                                    local fuel = GetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false))

                                    if Config.FuelScript == 'native' then
                                        fuel = GetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                    elseif Config.FuelScript == 'legacyfuel' then
                                        fuel = exports["LegacyFuel"]:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                    elseif Config.FuelScript == 'hyon_gas_station' then
                                        fuel = exports["hyon_gas_station"]:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                    elseif Config.FuelScript == 'frfuel' then
                                        fuel = exports.frfuel:getCurrentFuelLevel()
                                    elseif Config.FuelScript == 'myFuel' then
                                        fuel = exports['myFuel']:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                    else
                                        fuel = GetCustomFuel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                    end
                                    -------- fuel

                                    local fuelpercent = fuel * 100 / maxtank
                                    local speed = 0
                                    if not Config.useMph then
                                        speed = ESX.Math.Round((GetEntitySpeed(GetPlayerPed(-1)) * 3.6), 0)
                                        -- speed = math.round((GetEntitySpeed(GetPlayerPed(-1)) * 3.6), 0)
                                    else
                                        speed = ESX.Math.Round((GetEntitySpeed(GetPlayerPed(-1)) * 2.23694), 0)
                                        -- speed = math.round((GetEntitySpeed(GetPlayerPed(-1)) * 2.23694), 0)
                                    end
                                    
                                    SendNUIMessage({
                                        show = true,
                                        range = rangepercent,
                                        isMuted = isMuted,
                                        money = GroupDigits(money),
                                        hunger = hunger,
                                        thirst = thirst,
                                        drunk = drunk,
                                        useheartbar = Config.useheartbar,
                                        heart = heart,
                                        car = true,
                                        fuel = fuelpercent,
                                        speed = speed,
                                        usemilage = true,
                                        milage = ESX.Math.Round(milage, 2),
                                        -- milage = math.round(milage, 2),
                                    })
                                end, plate)
                            else
                                local maxtank = 100
                                
                                ------ fuel
                                local fuel = GetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false))

                                if Config.FuelScript == 'native' then
                                    fuel = GetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                elseif Config.FuelScript == 'legacyfuel' then
                                    fuel = exports["LegacyFuel"]:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                elseif Config.FuelScript == 'hyon_gas_station' then
                                    fuel = exports["hyon_gas_station"]:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                elseif Config.FuelScript == 'frfuel' then
                                    fuel = exports.frfuel:getCurrentFuelLevel()
                                elseif Config.FuelScript == 'myFuel' then
                                    fuel = exports['myFuel']:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                else
                                    fuel = GetCustomFuel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                end
                                -------- fuel

                                local fuelpercent = fuel * 100 / maxtank
                                
                                local speed = 0
                                if not Config.useMph then
                                    speed = ESX.Math.Round((GetEntitySpeed(GetPlayerPed(-1)) * 3.6), 0)
                                    -- speed = math.round((GetEntitySpeed(GetPlayerPed(-1)) * 3.6), 0)
                                else
                                    speed = ESX.Math.Round((GetEntitySpeed(GetPlayerPed(-1)) * 2.23694), 0)
                                    -- speed = math.round((GetEntitySpeed(GetPlayerPed(-1)) * 2.23694), 0)
                                end
                                
                                SendNUIMessage({
                                    show = true,
                                    range = rangepercent,
                                    isMuted = isMuted,
                                    money = GroupDigits(money),
                                    hunger = hunger,
                                    thirst = thirst,
                                    drunk = drunk,
                                    useheartbar = Config.useheartbar,
                                    heart = heart,
                                    car = true,
                                    fuel = fuelpercent,
                                    speed = speed,
                                    usemileage = false,
                                })
                            end
                        else
                            SendNUIMessage({
                                show = true,
                                range = rangepercent,
                                isMuted = isMuted,
                                money = GroupDigits(money),
                                hunger = hunger,
                                thirst = thirst,
                                drunk = drunk,
                                useheartbar = Config.useheartbar,
                                heart = heart,
                                car = false,
                            })
                        end
                    end, args)
               -- end, args)
            else
                SendNUIMessage({
                    show = false
                })
            end
        else
            SendNUIMessage({
                show = false
            })
        end
    
    Citizen.Wait(1000)
    end
end)

function GroupDigits(number)
    local formatted = tostring(number)
    local k
    while true do
        k, formatted = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end


Citizen.CreateThread(function()
	while true do 
		if hungermassagesended == false then 
			if hunger <= 20 then 
				hungermassagesended = true
				ESX.ShowNotification((Translation[Config.Locale]['LowHunger']))
                -- QBCore.Functions.Notify(Translation[Config.Locale]['LowHunger'], 'error')
			end
		end
		
		if thirstmassagesended == false then
			if thirst <= 20 then
				thirstmassagesended = true
				ESX.ShowNotification((Translation[Config.Locale]['LowThirst']))
                -- QBCore.Functions.Notify(Translation[Config.Locale]['LowThirst'], 'error')
			end
		end

		if hunger >= 20 then 
			hungermassagesended = false
		end

		if thirst >= 20 then
			thirstmassagesended = false
		end

		Citizen.Wait(500)
	end
end)




--- blinker
if Config.useIndicators then
    local indicator = "Off"

    RegisterNetEvent('mfp_hud:syncIndicator')
    AddEventHandler('mfp_hud:syncIndicator', function (playerId, IStatus)
        if GetPlayerFromServerId(playerId) ~= PlayerId() then
            local ped = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
            if IStatus == "Off" then
                SetVehicleIndicatorLights(ped, 0, false)
                SetVehicleIndicatorLights(ped, 1, false)
            elseif IStatus == "Left" then
                SetVehicleIndicatorLights(ped, 0, false)
                SetVehicleIndicatorLights(ped, 1, true)
            elseif IStatus == "Right" then
                SetVehicleIndicatorLights(ped, 0, true)
                SetVehicleIndicatorLights(ped, 1, false)
            elseif IStatus == "Both" then
                SetVehicleIndicatorLights(ped, 0, true)
                SetVehicleIndicatorLights(ped, 1, true)
            end
        end
    end)

    AddEventHandler('mfp_hud:setIndicator', function (IStatus)
        local ped = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        local HasTrailer, vehTrailer = GetVehicleTrailerVehicle(ped, vehTrailer)
        if IStatus == "Off" then
            SetVehicleIndicatorLights(ped, 0, false)
            SetVehicleIndicatorLights(ped, 1, false)
            if HasTrailer then
                SetVehicleIndicatorLights(vehTrailer, 0, false)
                SetVehicleIndicatorLights(vehTrailer, 1, false)
            end
            elseif IStatus == "Left" then
                SetVehicleIndicatorLights(ped, 0, false)
                SetVehicleIndicatorLights(ped, 1, true)
                if HasTrailer then
                    SetVehicleIndicatorLights(vehTrailer, 0, false)
                    SetVehicleIndicatorLights(vehTrailer, 1, true)
                end
            elseif IStatus == "Right" then
                SetVehicleIndicatorLights(ped, 0, true)
                SetVehicleIndicatorLights(ped, 1, false)
                if HasTrailer then
                    SetVehicleIndicatorLights(vehTrailer, 0, true)
                    SetVehicleIndicatorLights(vehTrailer, 1, false)
                end
            elseif IStatus == "Both" then
                SetVehicleIndicatorLights(ped, 0, true)
                SetVehicleIndicatorLights(ped, 1, true)
            if HasTrailer then
                SetVehicleIndicatorLights(vehTrailer, 0, true)
                SetVehicleIndicatorLights(vehTrailer, 1, true)
            end
        end
    end)

    RegisterNetEvent('mfp_hud:setHazards')
    AddEventHandler('mfp_hud:setHazards', function(hazardsDeactivate)
        local ped = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        if ped ~= nil then
            local setHazards = true
            if hazardsDeactivate == "false" or hazardsDeactivate == "0" or hazardsDeactivate == "off" then
                setHazards = false
            end
            if setHazards then
                indicator = "Both"
            else
                indicator = "Off"
            end
            TriggerServerEvent("mfp_hud:syncIndicator", indicator)
            TriggerEvent("mfp_hud:setIndicator", indicator)
        end
    end)

    local pedHeading = 0.0
    local indicatorTime = 0

    Citizen.CreateThread(function()
        while true do
            local ped = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            if ped ~= nil and GetPedInVehicleSeat(ped, -1) == GetPlayerPed(-1) then
                if IsControlJustPressed(1, 174) then
                    indicatorTime = 0
                    if indicator == "Left" then
                        indicator = "Off"
                    else
                        indicator = "Left"
                        pedHeading = GetEntityHeading(ped)
                    end
                    TriggerServerEvent("mfp_hud:syncIndicator", indicator)
                    TriggerEvent("mfp_hud:setIndicator", indicator)
                elseif IsControlJustPressed(1, 175) then
                    indicatorTime = 0
                    if indicator == "Right" then
                        indicator = "Off"
                    else
                        indicator = "Right"
                        pedHeading = GetEntityHeading(ped)
                    end
                    TriggerServerEvent("mfp_hud:syncIndicator", indicator)
                    TriggerEvent("mfp_hud:setIndicator", indicator)
                elseif IsControlJustPressed(1, 173) then
                    indicatorTime = 0
                    if indicator == "Both" then
                        indicator = "Off"
                    else
                        indicator = "Both"
                        pedHeading = GetEntityHeading(ped)
                    end
                    TriggerServerEvent("mfp_hud:syncIndicator", indicator)
                    TriggerEvent("mfp_hud:setIndicator", indicator)
                end
                if indicatorTime == 0 then
                    if indicator ~= "Off" then
                        local pedNewHeading = GetEntityHeading(ped)
                        if math.abs(pedNewHeading - pedHeading) > 60.0 then
                            indicatorTime = GetGameTimer() + 1500
                        end
                    end
                else
                    if GetGameTimer() >= indicatorTime and indicator ~= "Both" and (indicator == "Left" or indicator == "Right") then
                        indicator = "Off"
                        TriggerServerEvent("mfp_hud:syncIndicator", indicator)
                        TriggerEvent("mfp_hud:setIndicator", indicator)
                    end
                end
            end
            if ped ~= nil and ped ~= false and GetPedInVehicleSeat(ped, -1) == GetPlayerPed(-1) and IsVehicleEngineOn(ped) then
                if GetEntitySpeed(ped) < 4 and not IsControlPressed(1, 32) then
                    SetVehicleBrakeLights(ped, true)
                end
            end
            for playerIds = 0,31 do
                if NetworkIsPlayerActive(playerIds) then
                    local networkPed = GetPlayerPed(GetPlayerFromServerId(playerIds))
                    local networkPedVeh = GetVehiclePedIsIn(networkPed, false)
                    if networkPedVeh ~= nil and networkPedVeh ~= false and GetPlayerFromServerId(playerIds) ~= PlayerId() and GetPedInVehicleSeat(networkPedVeh, -1) == networkPed and IsVehicleEngineOn(networkPedVeh) then
                        if GetEntitySpeed(networkPedVeh) < 2 then
                            SetVehicleBrakeLights(networkPedVeh, true)
                        end
                    end
                end
            end
            Citizen.Wait(1)
        end
    end)
end -- end of Config.useIndicators


-- speed limiter - b to set

if Config.useSpeedLimiter then
    local issetmfp = false

    Citizen.CreateThread(function()
        local resetSpeedOnEnter = true
        while true do
            Citizen.Wait(0)
            local playerPed = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsIn(playerPed,false)
            if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then
                if resetSpeedOnEnter then
                    maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                    SetEntityMaxSpeed(vehicle, maxSpeed)
                    resetSpeedOnEnter = false
                end
                if IsControlJustReleased(0, Config.SpeedLimiterKey) and issetmfp then -- b
                    maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                    SetEntityMaxSpeed(vehicle, maxSpeed)
                    ESX.ShowNotification(Translation[Config.Locale]['SpeedDeactivated'])
                    --QBCore.Functions.Notify(Translation[Config.Locale]['SpeedDeactivated'], 'inform')

                    issetmfp = false   
                elseif IsControlJustReleased(0, Config.SpeedLimiterKey) and not issetmfp then -- b
                    cruise = GetEntitySpeed(vehicle)
                    issetmfp = true 
                    SetEntityMaxSpeed(vehicle, cruise)
                    if Config.useMph then
                    cruise = math.floor(cruise * 2.23694 + 0.5)
                    ESX.ShowNotification((Translation[Config.Locale]['SpeedSet2']):format(cruise))
                    --QBCore.Functions.Notify((Translation[Config.Locale]['SpeedSet2']):format(cruise), 'inform')
                    else
                    cruise = math.floor(cruise * 3.6 + 0.5)
                    ESX.ShowNotification((Translation[Config.Locale]['SpeedSet1']):format(cruise))
                    --QBCore.Functions.Notify((Translation[Config.Locale]['SpeedSet1']):format(cruise), 'inform')
                    end
                end
            else
                resetSpeedOnEnter = true
            end
        end
    end)
end -- end of Config.useSpeedLimiter


if Config.LeaveEngineOn then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsIn(ped, false)

            if RestrictEmer then
                if GetVehicleClass(veh) == 18 then
                    if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                        Citizen.Wait(150)
                        if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                            SetVehicleEngineOn(veh, true, true, false)
                            if keepDoorOpen then
                                TaskLeaveVehicle(ped, veh, 256)
                            else
                                TaskLeaveVehicle(ped, veh, 0)
                            end
                        end
                    end
                end
            else
                if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                    Citizen.Wait(150)
                    if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
                        SetVehicleEngineOn(veh, true, true, false)
                        if keepDoorOpen then
                            TaskLeaveVehicle(ped, veh, 256)
                        else
                            TaskLeaveVehicle(ped, veh, 0)
                        end
                    end
                end
            end
        end
    end)
end