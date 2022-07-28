if Config.FrameWork == 'QBCore' then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.FrameWork == 'ESX' then
    ESX = nil
    TriggerEvent(Config.TriggerFrameWork, function(obj) 
        ESX = obj 
    end)
elseif Config.FrameWork == 'custom' then
    CustomFramWork = nil
    TriggerEvent(Config.TriggerFrameWork, function(obj) 
        CustomFramWork = obj 
    end)
end

RegisterNetEvent('az_train:newTrain')
AddEventHandler('az_train:newTrain', function(trainmodelindex, stationachat, owneur, tablelong, station, modellabel, price)
    local canbuytrain = false
    if Config.FrameWork == 'QBCore' then
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        PlayerMoney = Player.PlayerData.money[Config.AccountForBuyTrain]
        if PlayerMoney >= price then
            Player.Functions.RemoveMoney(Config.AccountForBuyTrain, price)
            canbuytrain = true
        end
    elseif Config.FrameWork == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer ~= nil then
            local playerMoney = xPlayer.getAccount(Config.AccountForBuyTrain).money
            if playerMoney >= price then
                xPlayer.removeAccountMoney(Config.AccountForBuyTrain, price)
                canbuytrain = true
            end
        end
    elseif Config.FrameWork == 'custom' then
        canbuytrain = true
    end
    if canbuytrain then
        local path = GetResourcePath(GetCurrentResourceName())
        path = path:gsub('//', '/')..'/OwnedTrain/'..string.gsub('Train-'..owneur, ".lua", "")..'.lua'
        file = io.open(path, 'a+')
        label = '\n\ntable.insert(OwnedTrain, {'
        file:write(label)
        local str = "\n owneur = '" .. owneur .. "', \n uniqueID = '"..(tonumber(tablelong) + 1).."', \n modellabel = '"..modellabel.."', \n trainmodelindex = '" .. trainmodelindex .. "',\n achatdate = '" .. os.date("%d/%m/%Y") .. "',\n stationstock = '"..station.."',\n stationachat = '" .. stationachat .."'"
        file:write(str)
        file:write('\n})')
        file:close()
        TriggerClientEvent('az_train:updateNewTrain', -1, trainmodelindex, stationachat, owneur, os.date("%d/%m/%Y"), station, modellabel, (tonumber(tablelong) + 1))
    else
        SendServerNotification(Config.Lang["CantBuyTrain"])
    end
end)

RegisterNetEvent('az_train:posebombserver')
AddEventHandler('az_train:posebombserver', function(coords)
    TriggerClientEvent('az_train:posebombclient', -1, coords)
end)

RegisterNetEvent('az_train:openStashRobberyServer')
AddEventHandler('az_train:openStashRobberyServer', function(trainrob)
    TriggerClientEvent('az_train:openStashRobberyClient', -1, trainrob)
end)

RegisterNetEvent('az_train:closeStashRobberyServer')
AddEventHandler('az_train:closeStashRobberyServer', function(trainrob)
    TriggerClientEvent('az_train:closeStashRobberyClient', -1, trainrob)
end)

RegisterNetEvent('az_train:synchroCurrentTrainServer')
AddEventHandler('az_train:synchroCurrentTrainServer', function(temptrain, ingarage, uniqueID, trainindex, station)
    TriggerClientEvent('az_train:synchroCurrentTrainClient', -1, temptrain, ingarage, uniqueID, trainindex, station)
end)

RegisterNetEvent('az_train:removeBombServer')
AddEventHandler('az_train:removeBombServer', function(coordsbomb)
    TriggerClientEvent('az_train:removeBombClient', -1, coordsbomb)
end)
