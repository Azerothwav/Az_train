local trainTable = {}

if Config.FrameWork == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateCallback("az_train:getMyTrain", function(source, cb, data)
        local Player = QBCore.Functions.GetPlayer(source)
        local trainOwned = {}
        for k, v in pairs(trainTable) do
            if v.job == nil then
                if v.owner == Player.PlayerData.citizenid then
                    table.insert(trainOwned, v)
                end
            else
                if Player.PlayerData.job.name == v.job then
                    table.insert(trainOwned, v)
                end
            end
        end
        cb(trainOwned)
    end)

    QBCore.Functions.CreateCallback("az_train:buyTrain", function(source, cb, data)
        local Player = QBCore.Functions.GetPlayer(source)
        data["owner"] = Player.PlayerData.citizenid
        data["uniqueID"] = #trainTable + 1
        data["station"] = 1
        data["state"] = "in"
        PlayerMoney = Player.PlayerData.money["bank"]
        if PlayerMoney >= data.price then
            Player.Functions.RemoveMoney("bank", data.price)
            table.insert(trainTable, data)
            cb(true)
        else
            cb(false)
        end
    end)

    QBCore.Functions.CreateUseableItem('train_bomb', function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player.Functions.GetItemByName(item.name) then return end
        TriggerClientEvent("az_train:poseBomb", source)
        TriggerClientEvent("az_train:poseBombAll", -1, GetEntityCoords(GetPlayerPed(source)))
    end)
elseif Config.FrameWork == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()

    ESX.RegisterServerCallback("az_train:getMyTrain", function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local trainOwned = {}
        for k, v in pairs(trainTable) do
            if v.job == nil then
                if v.owner == xPlayer.identifier then
                    table.insert(trainOwned, v)
                end
            else
                if xPlayer.getJob().name == v.job or xPlayer.getJob2().name == v.job then
                    table.insert(trainOwned, v)
                end
            end
        end
        cb(trainOwned)
    end)

    ESX.RegisterServerCallback("az_train:buyTrain", function(source, cb, data)
        local xPlayer = ESX.GetPlayerFromId(source)
        data["owner"] = xPlayer.identifier
        data["uniqueID"] = #trainTable + 1
        data["station"] = 1
        data["state"] = "in"
        if xPlayer.getAccount("bank").money >= data.price then
            xPlayer.removeAccountMoney("bank", data.price)
            table.insert(trainTable, data)
            cb(true, data)
        else
            cb(false)
        end
    end)

    ESX.RegisterUsableItem('train_bomb', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('train_bomb', 1)
        TriggerClientEvent("az_train:poseBomb", source)
        TriggerClientEvent("az_train:poseBombAll", -1, GetEntityCoords(GetPlayerPed(source)))
    end)
elseif Config.FrameWork == 'custom' then
    CustomFramWork = nil
    TriggerEvent(Config.TriggerFrameWork, function(obj) 
        CustomFramWork = obj 
    end)
end

RegisterNetEvent("az_train:changeState", function(uniqueID, state, lastStation)
    for k, v in pairs(trainTable) do
        if v.uniqueID == uniqueID then
            v.state = state
            if lastStation ~= nil then
                v.station = lastStation
            end
        end
    end
    TriggerClientEvent("az_train:changeState", -1, uniqueID, state, lastStation)
end)

RegisterNetEvent("az_train:syncAction", function(uniqueID, storage, vehNet)
    TriggerClientEvent("az_train:syncAction", -1, uniqueID, storage, vehNet)
end)

RegisterNetEvent("az_train:removeBomb", function(position)
    TriggerClientEvent("az_train:removeBomb", -1, position)
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "trains.json"))
        if result ~= nil then
            for k, v in pairs(result) do
                trainTable[k] = {}
                if v.state == "out" then v.state = "in" end
                for x, w in pairs(v) do
                    trainTable[k][x] = w
                end
                if Config.Inventory == "ox" then
                    exports.ox_inventory:RegisterStash("Train:"..v.uniqueID, 'Stockage train n°: '..v.uniqueID, 50, v.storage * 1000, "Train:"..v.uniqueID)
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(3600000)
        print("Sauvegarde de la table Train en JSON")
        SaveResourceFile(GetCurrentResourceName(), "./trains.json", json.encode(trainTable), -1)
    end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function(eventData)
    SaveResourceFile(GetCurrentResourceName(), "./trains.json", json.encode(trainTable), -1)
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        SaveResourceFile(GetCurrentResourceName(), "./trains.json", json.encode(trainTable), -1)
    end
end)