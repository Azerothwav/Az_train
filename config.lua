Config = {}

Config.FrameWork = 'ESX' -- ESX / QBCore or Custom
Config.TriggerFrameWork = "esx:getSharedObject" -- esx:getSharedObject / QBCore : exports['qb-core']:GetCoreObject()
Config.Inventory = 'ch' -- ch = Cheeza Inventory / qb = QBCore basic inventory / custom / qs = Quasar Inventory / ox = Ox_inventory

function OpenStashTrainConfig(idtrain, storagekg, indexcontainer)
    if Config.Inventory == 'ch' then
        if indexcontainer ~= nil then
            TriggerEvent('inventory:openHouse', "Train:"..idtrain.."Container:"..indexcontainer, "", "Conteneur : "..indexcontainer, storagekg)
        else
            TriggerEvent('inventory:openHouse', "Train:"..idtrain, "Train:"..idtrain, "", storagekg)
        end
    elseif Config.Inventory == 'qb' then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "Train:"..idtrain.."Container:"..indexcontainer, {
            maxweight = storagekg * 1000,
            slots = 50,
            })
        TriggerEvent("inventory:client:SetCurrentStash", "Train:"..idtrain.."Container:"..indexcontainer)
    elseif Config.Inventory == 'custom' then

    elseif Config.Inventory == 'qs' then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "Train:"..idtrain.."Container:"..indexcontainer, {
            maxweight = storagekg * 1000, -- Max Weight In Grams
            slots = 100, -- Max Slots
        })
     elseif Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('stash', {id="Train:"..idtrain.."Container:"..indexcontainer, owner="Train:"..idtrain})
    end
end

Config.MaxVitesseTrain = 27 -- * 3.70 for the real vitesse (27 * 3.70 = 100km/h)
Config.AccountForBuyTrain = 'bank'

Config.Stations = {
    [1] = {
        garagecoords = vector3(2632.45, 2935.39, 40.42),
        coordsdeletetrain = vector3(2625.52, 2947.76, 40.67),
        path = {
            [1] = vector3(2615.83, 2945.46, 40.42),
            [2] = vector3(2619.87, 2939.94, 40.42),
        },
        chargetrain = {
            [19] = {
                containeroffset = {
                    [1] = vector3(0.0, -26.0, 0.0),
                    [2] = vector3(0.0, -42.0, 0.0),
                },
                storagekg = 15000
            },
            [20] = {
                needstair = false,
                offsetstair = nil,
                containeroffset = {
                    [1] = vector3(0.0, -23.0, 0.0),
                    [2] = vector3(0.0, -38.0, 0.0),
                    [3] = vector3(0.0, -53.0, 0.0),
                },
                storagekg = 30000
            }
        }
    },
    [2] = {
        garagecoords = vector3(-139.59, 6148.56, 32.34),
        coordsspawn = vector3(-140.46, 6141.85, 31.58),
        coordsdeletetrain = vector3(-142.70, 6144.80, 32.23),
        path = {
            [1] = vector3(-140.99, 6141.22, 31.58),
        },
        chargetrain = {
            [19] = {
                containeroffset = {
                    [1] = vector3(0.0, -26.0, 0.0),
                    [2] = vector3(0.0, -42.0, 0.0),
                },
                storagekg = 15000
            },
            [20] = {
                containeroffset = {
                    [1] = vector3(0.0, -23.0, 0.0),
                    [2] = vector3(0.0, -38.0, 0.0),
                    [3] = vector3(0.0, -53.0, 0.0),
                },
                storagekg = 30000
            }
        }
    },
    [3] = {
        garagecoords = vector3(193.23, -2503.9, 7.24),
        coordsspawn = vector3(217.6, -2471.28, 6.49),
        coordsdeletetrain = vector3(219.2, -2512.77, 7.24),
        path = {
            [1] = vector3(217.48, -2511.31, 6.46),
        },
        chargetrain = {
            [19] = {
                containeroffset = {
                    [1] = vector3(0.0, -26.0, 0.0),
                    [2] = vector3(0.0, -42.0, 0.0),
                },
                storagekg = 15000
            },
            [20] = {
                containeroffset = {
                    [1] = vector3(0.0, -23.0, 0.0),
                    [2] = vector3(0.0, -38.0, 0.0),
                    [3] = vector3(0.0, -53.0, 0.0),
                },
                storagekg = 30000
            }
        }
    }
}

Config.TrainShop = {
    ["Stock"] = {
        coordspnj = vector4(88.73, -2582.33, 6.0, 0.47),
        traintobuy = {
            {label = 'Oil Train', indextrain = 19, price = 5000},
            {label = 'Cargo Train', indextrain = 20, price = 5000}
        }
    }
}

function SendServerNotification(msg)
    if Config.FrameWork == 'ESX' then
        TriggerClientEvent('esx:showNotification', source, msg)
    elseif Config.FrameWork == 'QBCore' then
        TriggerClientEvent('QBCore:Notify', source, msg, "success")
    elseif Config.FrameWork == 'custom' then
        print(msg)
    end
end

function SendNotification(msg)
    if Config.FrameWork == 'ESX' then
        ESX.ShowNotification(msg)
    elseif Config.FrameWork == 'QBCore' then
        QBCore.Functions.Notify(msg, 'success')
    elseif Config.FrameWork == 'custom' then
        print(msg)
    end
end

function HelpNotification(msg)
    if Config.FrameWork == 'ESX' then
        ESX.ShowHelpNotification(msg)
    elseif Config.FrameWork == 'QBCore' then

    elseif Config.FrameWork == 'custom' then

    end
end

Config.Lang = {
    ["TrainShop"] = 'Train Shop',
    ["TrainStation"] = 'Train Station',
    ["BuyFor"] = 'Bought for : ',
    ["ChooseDeliveryLocation"] = 'Choose a delivery location for the train',
    ["Station"] = 'Stations : ',
    ["ChooseTrail"] = 'Choose a track for the train',
    ["Track"] = 'Track : ',
    ["BoughtThe"] = 'Bought on : ',
    ["TrainOut"] = ', Train out',
    ["TrainNotAtThisStation"] = 'This train is not at this station',
    ["at"] = ' at : ',
    ["ProblemChargeTrain"] = 'Loading problems with trains',
    ["BayTrain"] = 'The train is attached to the bay',
    ["OpenStation"] = 'Press E to open the station',
    ["OpenTrainShop"] = 'Press E to open the train shop',
    ["StowTrain"] = 'Press E to stow your train',
    ["NotInBaye"] = 'Your train is not attached to the quaie',
    ["OpenStorage"] = 'Press E to open the train storage',
    ["Modele"] = 'Modele : ',
    ["NoTrainAtThisStation"] = 'No trains found at this station',
    ["NotGoodStation"] = 'This is not the original station of this train',
    ["BombRemove"] = 'The bomb was removed',
    ["BombPose"] = 'The bomb was planted',
    ["AlreadyBomb"] = 'A bomb is already planted',
    ["TooFastToLeaveTrain"] = 'You are going too fast to get off the train',
    ["CantBuyTrain"] = 'You can\'t afford this train',
    ["AlreadyOut"] = 'Train already out'
}
