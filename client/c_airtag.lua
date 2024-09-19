QBCore = exports['qb-core']:GetCoreObject()
local trackedVehicles = {}
local Config = Config or {}

function GetClosestVehicle(coords)
    local vehicles = GetGamePool('CVehicle') 
    local closestDistance = -1
    local closestVehicle = nil

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(coords - vehicleCoords) 

        if closestDistance == -1 or distance < closestDistance then
            closestVehicle = vehicle
            closestDistance = distance
        end
    end

    return closestVehicle
end

RegisterNetEvent('jaki-airtag:client:useAirtag', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(playerCoords)
    local airtagTime = Config.AirtagTime * 60 * 1000

    if DoesEntityExist(vehicle) then
        local vehicleCoords = GetEntityCoords(vehicle)

        QBCore.Functions.Progressbar("attach_airtag", "Du har fäst en AirTag...", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "mini@repair",
            anim = "fixing_a_player",
            flags = 16, 
        }, {}, {}, function() 
            local blip = AddBlipForEntity(vehicle)
            SetBlipSprite(blip, 57)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 3)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Airtag")  --- SWE: Namnet på Airtagen, ENG: Name of the Airtag
            EndTextCommandSetBlipName(blip)

            table.insert(trackedVehicles, {
                vehicle = vehicle,
                blip = blip
            })

            QBCore.Functions.Notify("Du har fäst en AirTag på fordonet! Spårningen kommer att pågå i " .. Config.AirtagTime .. " minuter.", "success")

            Citizen.CreateThread(function()
                Citizen.Wait(airtagTime)

                RemoveBlip(blip)

                QBCore.Functions.Notify("AirTag har slutat fungera och blippen har tagits bort från kartan.", "error")
            end)
        end, function() 
            QBCore.Functions.Notify("Du avbröt processen!", "error")
        end)

        Wait(5000)
        ClearPedTasks(playerPed)
    else
        QBCore.Functions.Notify("Inget fordon nära!", "error")
    end
end)
