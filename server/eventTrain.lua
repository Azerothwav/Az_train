if Config.useEventTrain and (Config.FrameWork == "ESX" or Config.FrameWork == "QBCore") then
    local lastdrugtrain = nil
    local trainalreadyspawn = false
    local pnjalreadyspawn = false
    AddEventHandler("onResourceStart", function(resourceName)
        if resourceName == GetCurrentResourceName() then
            Wait(1000)
            CreateThread(function()
                while true do
                    t = os.date("*t")
                    for k, v in pairs(Config.DrugTrain) do
                        if lastdrugtrain and tonumber(t.hour) == tonumber(v.delais.hoursstop) and tonumber(t.min) == tonumber(v.delais.minstop) then
                            lastdrugtrain = nil
                            TriggerClientEvent('az_train:removeDrugsTrainClient', -1, k)
                        end
                        if lastdrugtrain == nil then
                            if tonumber(v.delais.hoursstart) == tonumber(t.hour) and tonumber(t.min) == tonumber(v.delais.minstart) then
                                lastdrugtrain = v.delais.hoursstart
                                TriggerClientEvent('az_train:createDrugsTrainClient', -1, k)
                            end
                        end
                    end
                    Citizen.Wait(10000)
                end
            end)
        end
    end)

    RegisterNetEvent('az_train:removeTrainDrugsServer', function(index)
        TriggerClientEvent('az_train:removeDrugsTrainClient', -1, index)
        trainalreadyspawn = false
        pnjalreadyspawn = false
    end)

    if Config.FrameWork == 'ESX' then
        ESX.RegisterServerCallback('az_train:havespawnpnj', function(source, cb)
            if not pnjalreadyspawn then
                pnjalreadyspawn = true
                cb(true)
            else
                cb(false)
            end
        end)

        ESX.RegisterServerCallback('az_train:havespawntrain', function(source, cb)
            if not trainalreadyspawn then
                trainalreadyspawn = true
                cb(true)
            else
                cb(false)
            end
        end)
    elseif Config.FrameWork == 'QBCore' then 
        QBCore.Functions.CreateCallback('az_train:havespawnpnj', function(source, cb)
            if not pnjalreadyspawn then
                pnjalreadyspawn = true
                cb(true)
            else
                cb(false)
            end
        end)

        QBCore.Functions.CreateCallback('az_train:havespawntrain', function(source, cb)
            if not trainalreadyspawn then
                trainalreadyspawn = true
                cb(true)
            else
                cb(false)
            end
        end)
    end

    RegisterNetEvent('az_train:giverewardtraindrug', function(index)
        if Config.FrameWork == 'ESX' then
            local xPlayer = ESX.GetPlayerFromId(source)
            for k, v in pairs(Config.DrugTrain[index].reward) do
                xPlayer.addInventoryItem(k, v)
            end
        elseif Config.FrameWork == 'QBCore' then
            local Player = QBCore.Functions.GetPlayer(source)
            for k, v in pairs(Config.DrugTrain[index].reward) do
                Player.Functions.AddItem(k, v)
            end
        end
    end)

    RegisterNetEvent("az_train:syncTrainEventModel", function(idnet)
        TriggerClientEvent("az_train:syncTrainEventModel", -1, idnet)
    end)

    RegisterNetEvent("az_train:syncPNJTrainEvent", function(tablePNJ)
        TriggerClientEvent("az_train:syncPNJTrainEvent", -1, tablePNJ)
    end)
end