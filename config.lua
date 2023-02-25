Config = {}

Config.FrameWork = 'QBCore' -- ESX / QBCore or Custom
Config.TriggerFrameWork = "exports['qb-core']:GetCoreObject()" -- esx:getSharedObject / QBCore : exports['qb-core']:GetCoreObject()
Config.Inventory = 'qb' -- ch = Cheeza Inventory / qb = QBCore basic inventory / custom / qs = Quasar Inventory / ox = Ox_inventory

Config.OpenStash = function(uniqueID, storagekg)
    if Config.Inventory == 'ch' then
        TriggerEvent('inventory:openHouse', "Train:"..uniqueID, "Train:"..uniqueID, "", storagekg)
    elseif Config.Inventory == 'qb' then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "Train:"..uniqueID, {
            maxweight = storagekg * 1000,
            slots = 50,
            })
        TriggerEvent("inventory:client:SetCurrentStash", "Train:"..uniqueID)
    elseif Config.Inventory == 'qs' then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "Train:"..uniqueID, {
            maxweight = storagekg * 1000, -- Max Weight In Grams
            slots = 100, -- Max Slots
        })
     elseif Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('stash', {id="Train:"..uniqueID, owner="Train:"..uniqueID})
    elseif Config.Inventory == 'custom' then

    end
end

Config.Trains = {
    [1] = {
        trainindex = 19,
        label = 'Oil Train',
        storage = 15000,
        price = 5000,
        maxSpeed = 27 -- * 3.70 for the real vitesse (27 * 3.70 = 100km/h)
    },
    [2] = {
        trainindex = 20,
        label = 'Cargo Train',
        storage = 30000,
        price = 5000,
        maxSpeed = 27 -- * 3.70 for the real vitesse (27 * 3.70 = 100km/h)
    }
}

Config.Stations = {
    [1] = {
        label = "Mexico",
        pedmodel = "g_m_m_armgoon_01",
        coordspnj = vector4(2632.45, 2935.39, 40.42, 57.0),
        coordsdeletetrain = vector3(2625.52, 2947.76, 40.67),
        path = {
            [1] = vector3(2615.83, 2945.46, 40.42),
            [2] = vector3(2619.87, 2939.94, 40.42),
        }
    },
    [2] = {
        label = "Dallas",
        pedmodel = "g_m_m_armgoon_01",
        coordspnj = vector4(-139.59, 6148.56, 32.34, 180.0),
        coordsspawn = vector3(-140.46, 6141.85, 31.58),
        coordsdeletetrain = vector3(-142.70, 6144.80, 32.23),
        path = {
            [1] = vector3(-140.99, 6141.22, 31.58),
        }
    },
    [3] = {
        label = "Los Angeles",
        pedmodel = "g_m_m_armgoon_01",
        coordspnj = vector4(193.23, -2503.9, 7.24, 180.0),
        coordsspawn = vector3(217.6, -2471.28, 6.49),
        coordsdeletetrain = vector3(219.2, -2512.77, 7.24),
        path = {
            [1] = vector3(217.48, -2511.31, 6.46),
        }
    }
}

Config.TrainShop = {
    ["Stock"] = {
        pedmodel = "g_m_m_armgoon_01",
        coordspnj = vector4(88.73, -2582.33, 6.0, 180.47),
        traintobuy = {19, 20},
        job = "police" -- Remove this line if none
    },
    
    --[[ Remove comment for use the Subway Shop
    ["SubWayStock"] = {
	pedmodel = "g_m_m_armgoon_01",
        coordspnj = vector4(-1105.38, -2744.7, -7.41, 0.47),
        traintobuy = {19, 20},
	job = "police" -- Remove this line if none
    }
    ]]
}

Config.Job = {
    ["job1"] = function()
        if Config.FrameWork == "ESX" then
            return ESX.PlayerData.job.name
        elseif Config.FrameWork == "QBCore" then
            return PlayerJob.name
        end
    end,
    ["job2"] = function() -- Comment this part if you don't have the job 2
        if Config.FrameWork == "ESX" then
            return ESX.PlayerData.job2.name
        elseif Config.FrameWork == "QBCore" then
            return PlayerJob.name
        end
    end,
    --[[["job3"] = function() -- Uncomment this part if you have a job 3
        if Config.FrameWork == "ESX" then
            return ESX.PlayerData.job3.name
        elseif Config.FrameWork == "QBCore" then
            return PlayerJob.name
        end
    end]]
}

Config.CanAccess = function(jobname)
    if jobname ~= nil then
        local canAccess = false
        for k, v in pairs(Config.Job) do
            if v() == jobname then
                canAccess = true
            end
        end
        return canAccess
    else
        return true
    end
end

Config.SendServerNotification = function(msg)
    if Config.FrameWork == 'ESX' then
        TriggerClientEvent('esx:showNotification', source, msg)
    elseif Config.FrameWork == 'QBCore' then
        TriggerClientEvent('QBCore:Notify', source, msg, "success")
    elseif Config.FrameWork == 'custom' then
        print(msg)
    end
end

Config.SendNotification = function(msg)
    if Config.FrameWork == 'ESX' then
        ESX.ShowNotification(msg)
    elseif Config.FrameWork == 'QBCore' then
        QBCore.Functions.Notify(msg, 'success')
    elseif Config.FrameWork == 'custom' then
        print(msg)
    end
end

Config.HelpNotification = function(msg)
    if Config.FrameWork == 'ESX' then
        ESX.ShowHelpNotification(msg)
    elseif Config.FrameWork == 'QBCore' then

    elseif Config.FrameWork == 'custom' then

    end
end

Config.CallBack = function(name, cb, ...)
	if Config.FrameWork == "ESX" then
		ESX.TriggerServerCallback(name, function(callback)
			cb(callback)
		end, ...)
	elseif Config.FrameWork == "QBCore" then
		QBCore.Functions.TriggerCallback(name, function(callback)
			cb(callback)
		end, ...)
	end
end

Config.CreatePNJ = function(coords, ped, network)
    RequestModel(GetHashKey(ped))
    while not HasModelLoaded(GetHashKey(ped)) do
        Citizen.Wait(0)
    end
    local tempPNJ = CreatePed(7,GetHashKey(ped), coords.x, coords.y, coords.z - 1, coords.w, 0, network, false) 
    FreezeEntityPosition(tempPNJ, true)
    SetEntityAsMissionEntity(tempPNJ,  true, false)
    ClearPedTasksImmediately(tempPNJ)
    SetEntityInvincible(tempPNJ, true)
    SetBlockingOfNonTemporaryEvents(tempPNJ, 1)
    return tempPNJ
end

Config.CreateBlip = function(coords, size, name, sprite, color)
    local tempBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite (tempBlip, sprite)
    SetBlipDisplay(tempBlip, 4)
    SetBlipScale(tempBlip, size)
    SetBlipColour (tempBlip, color)
    SetBlipAsShortRange(tempBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(tempBlip)
end

Config.Lang = {
    ["TrainShop"] = 'Train Shop',
    ["TrainStation"] = 'Train Station : %s',
    ["Station"] = 'Stations : ',
    ["ChooseTrail"] = 'Choose a track for the train',
    ["Track"] = 'Track : ',
    ["Bought"] = 'You bought : ',
    ["TrainStockIn"] = 'Train stock in station : %s',
    ["GetOutTrain"] = 'Take out the train : %s',
    ["TrainInfos"] = 'Price : %s$, storage : %skg',
    ["ProblemChargeTrain"] = 'Loading problems with trains, you need a gamebuild higher than 2189',
    ["OpenStation"] = 'Press E to open the station',
    ["OpenTrainShop"] = 'Press E to open the train shop',
    ["StowTrain"] = 'Press E to stow your train',
    ["TrainInfo"] = 'Press F pour get into the train\nPress H to open the train storage',
    ["BombDefuse"] = 'Press e to defuse the bomb',
    ["BombRemove"] = 'The bomb was removed',
    ["BombPose"] = 'The bomb was planted',
    ["CantBuyTrain"] = 'You can\'t afford this train',
    ["AccessDenied"] = 'You don\'t have access to this shop',
     
    -- Subway DLC Translation
    ["Subway"] = 'Subway'
}
