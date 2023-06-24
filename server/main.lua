local trainTable = {}

local sizeTableToSave = 0
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
                    for i = 0, 100 do
                        exports.ox_inventory:RegisterStash("Train:"..v.uniqueID.."-carriage:"..i, "Stockage train n°: "..v.uniqueID..", trailer n°: "..i, 50, v.storage * 1000, "Train:"..v.uniqueID.."-carriage:"..i)
                    end
                end
            end
            sizeTableToSave = #trainTable
        end
    end
end)

CreateThread(function()
    while true do
        Wait(3600000)
        if sizeTableToSave ~= #trainTable then
            sizeTableToSave = #trainTable
            print("Save Train Table JSON")
            SaveResourceFile(GetCurrentResourceName(), "./trains.json", json.encode(trainTable), -1)
        end
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
    
    QBCore.Functions.CreateUseableItem('train_bomb', function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player.Functions.GetItemByName(item.name) then return end
        TriggerClientEvent("az_train:poseBomb", source)
        TriggerClientEvent("az_train:poseBombAll", -1, GetEntityCoords(GetPlayerPed(source)))
    end)

    QBCore.Functions.CreateUseableItem('train_repairkit', function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player.Functions.GetItemByName(item.name) then return end
        TriggerClientEvent("az_train:repairTrain", source)
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

    ESX.RegisterUsableItem('train_bomb', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('train_bomb', 1)
        TriggerClientEvent("az_train:poseBomb", source)
        TriggerClientEvent("az_train:poseBombAll", -1, GetEntityCoords(GetPlayerPed(source)))
    end)

    ESX.RegisterUsableItem('train_repairkit', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('train_repairkit', 1)
        TriggerClientEvent("az_train:repairTrain", source)
    end)
elseif Config.FrameWork == 'custom' then
    
end

function getAStation(metro)
    local index = 1
    for k, v in pairs(Config.Stations) do
        if not metro then
            if v.metrostation == nil or not v.metrostation then
                index = k
                break
            end
        else
            if v.metrostation ~= nil and v.metrostation then
                index = k
                break
            end
        end
    end
    return index
end

RegisterNetEvent("az_train:buyTrain", function(data)
    data["uniqueID"] = #trainTable + 1
    data["station"] = getAStation(data.trainindex == 25)
    data["state"] = "in"
    if Config.FrameWork == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        data["owner"] = xPlayer.identifier
        if xPlayer.getAccount("bank").money >= data.price then
            xPlayer.removeAccountMoney("bank", data.price)
            table.insert(trainTable, data)
        else
            xPlayer.showNotification(Config.Lang["CantBuyTrain"])
        end
    elseif Config.FrameWork == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        data["owner"] = Player.PlayerData.citizenid
        PlayerMoney = Player.PlayerData.money["bank"]
        if PlayerMoney >= data.price then
            Player.Functions.RemoveMoney("bank", data.price)
            table.insert(trainTable, data)
        else
            TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Config.Lang["CantBuyTrain"], 'error')
        end
    elseif Config.FrameWork == "custom" then
        local identifier = GetPlayerIdentifiers(source)
        local license = nil
        for k, v in pairs(identifier) do if string.find(v, "license:") then license = string.gsub(v, "license:", "") end end
        data["owner"] = license
        table.insert(trainTable, data)
    end
    TriggerClientEvent("az_train:newTrain", source, data)
end)

RegisterNetEvent("az_train:getTrains", function()
    local trainOwned = {}
    local identifier = GetPlayerIdentifiers(source)
    local license = nil
    for k, v in pairs(identifier) do if string.find(v, "license:") then license = string.gsub(v, "license:", "") end end
    for k, v in pairs(trainTable) do
        if v.owner == license then
            table.insert(trainOwned, v)
        end
    end
    TriggerClientEvent("az_train:getTrains", source, trainOwned)
end)

RegisterNetEvent("az_train:changeState", function(uniqueID, state, lastStation)
    for k, v in pairs(trainTable) do
        if v.uniqueID == uniqueID then
            v.state = state
            if lastStation ~= nil then
                v.station = lastStation
            end
            break
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