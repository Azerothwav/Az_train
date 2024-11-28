Config = {}

Config.FrameWork = 'ESX' -- ESX / QBCore or Custom
Config.Inventory = 'ox' -- ch = Cheeza Inventory / qb = QBCore basic inventory / custom / qs = Quasar Inventory / ox = Ox_inventory
Config.DrawMakerStockage = true -- Choose to draw a marker at the location of each storage for trailers
Config.UseOxTarget = false

Config.MetroIndex = 25 -- Change this by 26 for game build 2802
Config.UseMetro = false
Config.useEventTrain = false

Config.OpenStash = function(uniqueID, storagekg, carriage)
    if Config.Inventory == 'ch' then
        TriggerEvent('inventory:openHouse', 'Train:' .. uniqueID .. '-carriage:' .. carriage,
                     'Train:' .. uniqueID .. '-carriage:' .. carriage, '', storagekg)
    elseif Config.Inventory == 'qb' then
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'Train:' .. uniqueID .. '-carriage:' .. carriage,
                           { maxweight = storagekg * 1000, slots = 50 })
        TriggerEvent('inventory:client:SetCurrentStash', 'Train:' .. uniqueID .. '-carriage:' .. carriage)
    elseif Config.Inventory == 'qs' then
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'Train:' .. uniqueID .. '-carriage:' .. carriage, {
            maxweight = storagekg * 1000, -- Max Weight In Grams
            slots = 100 -- Max Slots
        })
        TriggerEvent('inventory:client:SetCurrentStash', 'Train:' .. uniqueID .. '-carriage:' .. carriage)
    elseif Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('stash', {
            id = 'Train:' .. uniqueID .. '-carriage:' .. carriage,
            owner = 'Train:' .. uniqueID .. '-carriage:' .. carriage
        })
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
    },
    [3] = {
        trainindex = Config.MetroIndex,
        label = 'Metro Train',
        storage = 30000,
        price = 5000,
        maxSpeed = 27 -- * 3.70 for the real vitesse (27 * 3.70 = 100km/h)
    }
}

Config.Stations = {
    [1] = {
        label = 'Mexico',
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vector4(2632.45, 2935.39, 40.42, 57.0),
        coordsdeletetrain = vector3(2625.52, 2947.76, 40.67),
        path = { [1] = vector3(2615.83, 2945.46, 40.42), [2] = vector3(2619.87, 2939.94, 40.42) }
    },
    [2] = {
        label = 'Dallas',
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vector4(-139.59, 6148.56, 32.34, 180.0),
        coordsspawn = vector3(-140.46, 6141.85, 31.58),
        coordsdeletetrain = vector3(-142.70, 6144.80, 32.23),
        path = { [1] = vector3(-140.99, 6141.22, 31.58) }
    },
    [3] = {
        label = 'Los Angeles',
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vector4(193.23, -2503.9, 7.24, 180.0),
        coordsspawn = vector3(217.6, -2471.28, 6.49),
        coordsdeletetrain = vector3(219.2, -2512.77, 7.24),
        path = { [1] = vector3(217.48, -2511.31, 6.46) }
    },
    [4] = {
        label = 'Station 1',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(127.406151, -1735.803833, 30.110525, 231.166412),
        coordsspawn = vector3(113.54, -1724.27, 30.18),
        coordsdeletetrain = vector3(113.54, -1724.27, 30.18),
        path = {
            [1] = vec3(128.555405, -1731.424194, 29.128185),
            [2] = vec3(119.502754, -1734.335205, 29.057827)
        }
    },
    [5] = {
        label = 'Station 2',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(-219.096848, -1048.560303, 30.139881, 160.768539),
        coordsspawn = vector3(-214.73, -1036.71, 30.57),
        coordsdeletetrain = vec3(-216.161270, -1045.678223, 30.140137),
        path = {
            [1] = vec3(-222.156036, -1043.097534, 29.326977),
            [2] = vec3(-212.256210, -1043.522949, 29.322237)
        }
    },
    [6] = {
        label = 'Station 3',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(-497.037201, -673.120972, 11.809022, 90.577766),
        coordsspawn = vector3(-480.72, -673.14, 11.81),
        coordsdeletetrain = vec3(-491.651672, -671.590942, 11.809022),
        path = {
            [1] = vec3(-495.600494, -681.362854, 10.958567),
            [2] = vec3(-491.644562, -665.405701, 10.923857)
        }
    },
    [7] = {
        label = 'Station 4',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(-1334.990967, -493.343567, 15.045381, 208.635971),
        coordsspawn = vector3(-1338.1, -488.1, 15.05),
        coordsdeletetrain = vector3(219.2, -2512.77, 7.24),
        path = {
            [1] = vec3(-1330.326050, -486.467438, 14.152298),
            [2] = vec3(-1343.833984, -492.129547, 14.174643)
        }
    },
    [8] = {
        label = 'Station 5',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(-819.246887, -139.903748, 19.950359, 295.195526),
        coordsspawn = vector3(-819.33, -139.93, 19.95),
        coordsdeletetrain = vec3(-819.678406, -142.097916, 19.950359),
        path = {
            [1] = vec3(-824.344116, -134.082932, 19.064135),
            [2] = vec3(-817.233093, -147.501282, 19.062824)
        }
    },
    [9] = {
        label = 'Station 6',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(-294.489319, -297.358032, 10.063153, 6.829783),
        coordsspawn = vector3(-294.6, -302.72, 10.06),
        coordsdeletetrain = vec3(-292.373383, -302.513397, 10.063147),
        path = {
            [1] = vec3(-302.050446, -299.867126, 9.191111),
            [2] = vec3(-287.178711, -301.854218, 9.161113)
        }
    },
    [10] = {
        label = 'Station 7',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(276.150726, -1204.215210, 38.895565, 87.813736),
        coordsspawn = vector3(276.09, -1204.24, 38.9),
        coordsdeletetrain = vec3(275.995209, -1204.814331, 38.894875),
        path = {
            [1] = vec3(273.996857, -1198.879639, 38.072815),
            [2] = vec3(275.421722, -1209.664551, 38.075226)
        }
    },
    [11] = {
        label = 'Station 8',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(-546.983521, -1297.015869, 26.901604, 157.327805),
        coordsspawn = vector3(-539.37, -1280.13, 27.33),
        coordsdeletetrain = vec3(-546.983521, -1297.015869, 26.901604),
        path = {
            [1] = vec3(-541.266663, -1295.702148, 25.865602),
            [2] = vec3(-550.012268, -1292.643066, 25.909567)
        }
    },
    [12] = {
        label = 'Station 9',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(-893.982178, -2348.386963, -11.732736, 161.007782),
        coordsspawn = vec3(-893.983154, -2348.388916, -11.732736),
        coordsdeletetrain = vec3(-895.544617, -2344.406250, -11.732761),
        path = {
            [1] = vec3(-886.580872, -2349.007813, -12.620449),
            [2] = vec3(-899.282715, -2342.404053, -12.617288)
        }
    },
    [13] = {
        label = 'Station 10',
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vec4(-1082.194824, -2714.392578, -7.410075, 125.665718),
        coordsspawn = vector3(-1084.33, -2716.55, -7.41),
        coordsdeletetrain = vec3(-1082.218750, -2714.419678, -7.410075),
        path = {
            [1] = vec3(-1075.299438, -2717.762451, -8.319318),
            [2] = vec3(-1086.153076, -2707.420898, -8.253543)
        }
    }
}

Config.TrainShop = {
    ['Stock'] = {
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vector4(88.73, -2582.33, 6.0, 180.47),
        traintobuy = { 19, 20 },
        job = 'police' -- Remove this line if none
    },
    ['SubWayStock'] = {
        metrostation = true,
        pedmodel = 'g_m_m_armgoon_01',
        coordspnj = vector4(-1105.38, -2744.7, -7.41, 0.47),
        traintobuy = { Config.MetroIndex },
        job = 'police' -- Remove this line if none
    }
}

Config.Job = {
    ['job1'] = function()
        if Config.FrameWork == 'ESX' then
            return ESX.PlayerData.job.name
        elseif Config.FrameWork == 'QBCore' then
            return PlayerJob.name
        end
    end,
    ['job2'] = function()
        -- Comment this part if you don't have the job 2
        if Config.FrameWork == 'ESX' then
            return ESX.PlayerData.job2.name
        elseif Config.FrameWork == 'QBCore' then
            return PlayerJob.name
        end
    end
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
        TriggerClientEvent('QBCore:Notify', source, msg, 'success')
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

Config.ProgressBar = function(time, msg)
    if Config.FrameWork == 'ESX' then
        -- Add your own progress bar export here
    elseif Config.FrameWork == 'QBCore' then
        QBCore.Functions.Progressbar('', msg, time, false, true,
                                     {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true
        }, {}, {}, {}, function()
        end)
    end
end

Config.CallBack = function(name, cb, ...)
    if Config.FrameWork == 'ESX' then
        ESX.TriggerServerCallback(name, function(callback)
            cb(callback)
        end, ...)
    elseif Config.FrameWork == 'QBCore' then
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
    local tempPNJ = CreatePed(7, GetHashKey(ped), coords.x, coords.y, coords.z - 1, coords.w, 0, network, false)
    FreezeEntityPosition(tempPNJ, true)
    SetEntityAsMissionEntity(tempPNJ, true, false)
    ClearPedTasksImmediately(tempPNJ)
    SetEntityInvincible(tempPNJ, true)
    SetBlockingOfNonTemporaryEvents(tempPNJ, 1)
    return tempPNJ
end

Config.CreateBlip = function(coords, size, name, sprite, color)
    local tempBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(tempBlip, sprite)
    SetBlipDisplay(tempBlip, 4)
    SetBlipScale(tempBlip, size)
    SetBlipColour(tempBlip, color)
    SetBlipAsShortRange(tempBlip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name)
    EndTextCommandSetBlipName(tempBlip)
end

Config.Lang = {
    ['TrainShop'] = 'Train Shop : %s',
    ['TrainStation'] = 'Train Station : %s',
    ['Station'] = 'Stations : ',
    ['ChooseTrail'] = 'Choose a track for the train',
    ['Track'] = 'Track : ',
    ['Bought'] = 'You bought : ',
    ['TrainStockIn'] = 'Train stock in station : %s',
    ['GetOutTrain'] = 'Take out the train : %s',
    ['TrainInfos'] = 'Price : %s$, storage : %skg',
    ['ProblemChargeTrain'] = 'Loading problems with trains, you need a gamebuild higher than 2189',
    ['OpenStation'] = 'Press E to open the station',
    ['OpenTrainShop'] = 'Press E to open the train shop',
    ['OpenStationOxTarget'] = 'Open the train station',
    ['OpenShopOxTarget'] = 'Open the train shop',
    ['StowTrain'] = 'Press E to stow your train',
    ['TrainInfo'] = 'Press F pour get into the train\nPress H to open the train storage',
    ['BombDefuse'] = 'Press e to defuse the bomb',
    ['BombRemove'] = 'The bomb was removed',
    ['BombPose'] = 'The bomb was planted',
    ['RepairInProgress'] = 'Train reparation in progress',
    ['CantBuyTrain'] = 'You can\'t afford this train',
    ['AccessDenied'] = 'You don\'t have access to this shop',
    -- Metro Translation
    ['Subway'] = 'Subway',
    -- Event Train Translation
    ['TrainToRob'] = 'Train to rob',
    ['TakeCargaison'] = 'Press E to take the cargaison of the train',
    ['NotAllPNJDeath'] = 'Not all the PNJ is death',
    ['InTakeOff'] = 'Cargaison in recuperation',
    ['EventStart'] = 'A train with a big cargo had problems on a track, we put the point on your map if you want to look at it',
    ['EventStop'] = 'The train left, it seems that someone helped them'
}

Config.DrugTrain = {
    [1] = {
        delais = { hoursstart = 18, minstart = 55, hoursstop = 20, minstop = 00 },
        security = true,
        coordstrain = vector3(-520.39, 4461.92, 89.05),
        showblip = true,
        reward = { ['bread'] = 15, ['water'] = 15 },
        security = {
            [1] = {
                coordspnj = vector3(-522.46, 4456.5, 89.8),
                ped = 'a_f_m_bevhills_02',
                freeze = false,
                weapon = 'WEAPON_PISTOL',
                health = 100,
                scenario = '',
                armor = 25,
                accuracy = 20
            },
            [2] = {
                coordspnj = vector3(-517.88, 4463.93, 89.79),
                ped = 'a_f_m_bevhills_02',
                freeze = false,
                weapon = 'WEAPON_SMG',
                health = 100,
                scenario = '',
                armor = 25,
                accuracy = 20
            }
        }
    }
}

Config.DrugTrainCargaison = {
    [1] = vector3(-0.0730, -15.50, -0.2503),
    [2] = vector3(-0.1224, -18.41749, -0.2445),
    [3] = vector3(-0.080, -21.3815, -0.2385),
    [4] = vector3(0.0415, -32.55, -0.2591),
    [5] = vector3(0.0364, -35.48, -0.2599),
    [6] = vector3(0.03843, -39.276, -0.2606)
}
