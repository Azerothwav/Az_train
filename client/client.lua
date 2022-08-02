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

if Config.Inventory == 'ox' then
    local ox_inventory = exports.ox_inventory
end

local speed = 0
local ModelsLoaded = false
local intrain = false
local trainfreezequaie = false
local lastcoordstrail = nil
local incooldownspawntrain = false
local spawnbomb = false
local BombTrain = {}
CurrentTrain = {}
OwnedTrain = {}

TRAIN = {}
TRAIN.Menu = {}
TRAIN.Menu.IsOpen = false
TRAIN.Menu.Main = RageUI.CreateMenu("", "Shop", nil, nil, "root_cause", "shopui_title_elitastravel")
TRAIN.Menu.GarageTrain = RageUI.CreateMenu("", "Garage Train", nil, nil, "root_cause", "shopui_title_elitastravel")
TRAIN.Menu.SendTrainToGarage = RageUI.CreateMenu("", "Delivery", nil, nil, "root_cause", "shopui_title_elitastravel")
TRAIN.Menu.ChooseTrailTrain = RageUI.CreateMenu("", "Track", nil, nil, "root_cause", "shopui_title_elitastravel")

TRAIN.Menu.Main.Closed = function()
    TRAIN.Menu.Close()
end

function TRAIN.Menu.Close()
    TRAIN.Menu.IsOpen = false
    RageUI.CloseAll()
    RageUI.Visible(TRAIN.Menu.Main, false)
end

Citizen.CreateThread(function()
	for k, v in pairs (Config.TrainShop) do
		
		local blip = AddBlipForCoord(v.coordspnj.x, v.coordspnj.y, v.coordspnj.z)
		SetBlipSprite (blip, 474)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.75)
		SetBlipColour (blip, 45)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Lang["TrainShop"])
		EndTextCommandSetBlipName(blip)
	end

    for k, v in pairs (Config.Stations) do
		local blip = AddBlipForCoord(v.garagecoords.x, v.garagecoords.y, v.garagecoords.z)
		SetBlipSprite (blip, 176)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.75)
		SetBlipColour (blip, 45)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Lang["TrainStation"])
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
    function LoadTrainModels()
        DeleteAllTrains()
        ModelsLoaded = false
        RequestModelSync("freight")
        RequestModelSync("freightcar")
        RequestModelSync("freightcar2")
        RequestModelSync("freightgrain")
        RequestModelSync("freightcont1")
        RequestModelSync("freightcont2")
        RequestModelSync("freighttrailer")
        RequestModelSync("tankercar")
        RequestModelSync("metrotrain")
        RequestModelSync("s_m_m_lsmetro_01")
        ModelsLoaded = true
    end

    function RequestModelSync(mod)
        tempmodel = GetHashKey(mod)
        RequestModel(tempmodel)
        while not HasModelLoaded(tempmodel) do
            RequestModel(tempmodel)
            Citizen.Wait(0)
        end
    end

    LoadTrainModels()
end)

local lasttrainshop = {}
local cooldownachat = false
function TRAIN.Menu.Open(index, price, label, indextrain, idTrain)
    Citizen.CreateThread(function()
        while TRAIN.Menu.IsOpen do
            RageUI.IsVisible(TRAIN.Menu.Main, function()
                for k, v in pairs(Config.TrainShop[index].traintobuy) do
                    RageUI.Button(Config.Lang["BuyFor"] .. v.price.. ' $ '.. v.label, nil, {}, true, {
                        onSelected = function()
                            lasttrainshop = {
                                price = v.price,
                                label = v.label,
                                indextrain = v.indextrain
                            }
                            OpenMenuChooseGarageTrain(index)
                        end,
                    })
                end
            end)
            RageUI.IsVisible(TRAIN.Menu.SendTrainToGarage, function()
                RageUI.Button(Config.Lang["ChooseDeliveryLocation"], nil, {}, true, {
                    onSelected = function()
                    end,
                })
                for k, v in pairs(Config.Stations) do
                    RageUI.Button(Config.Lang["Station"]..k, nil, {}, true, {
                        onSelected = function()
                            if not cooldownachat then
                                cooldownachat = true
                                Citizen.SetTimeout(5000, function()
                                    cooldownachat = false
                                end)
                                TriggerServerEvent('az_train:newTrain', lasttrainshop.indextrain, index, GetPlayerName(PlayerId()), #OwnedTrain, k, lasttrainshop.label, lasttrainshop.price)
                            end
                            RageUI.CloseAll()
                        end,
                    })
                end
            end)
            RageUI.IsVisible(TRAIN.Menu.ChooseTrailTrain, function()
                RageUI.Button(Config.Lang["ChooseTrail"], nil, {}, true, {
                    onSelected = function()
                    end,
                })
                for k, v in pairs(Config.Stations[index].path) do
                    RageUI.Button(Config.Lang["Track"]..k, nil, {}, true, {
                        onSelected = function()
                            for k, v in pairs(OwnedTrain) do
                                if tonumber(index) == tonumber(v.stationstock) and tonumber(idTrain) == tonumber(v.uniqueID) then
                                    if not incooldownspawntrain then
                                        RageUI.CloseAll()
                                        incooldownspawntrain = true
                                        Citizen.SetTimeout(5000, function()
                                            incooldownspawntrain = false
                                        end)
                                        SpawnTrainInTrail(v.stationstock, tonumber(v.trainmodelindex), tonumber(v.uniqueID), lastcoordstrail)
                                    end
                                end
                            end
                        end,
                        onActive = function()
                            lastcoordstrail = v
                            DrawMarker(20, v.x, v.y, v.z + 1.1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0., 0.3, 255, 255, 255, 200, 1, true, 2, 0, nil, nil, 0)
                        end
                    })
                end
            end)
            RageUI.IsVisible(TRAIN.Menu.GarageTrain, function()
                local notraininstation = true
                for k, v in pairs(OwnedTrain) do 
                    if GetPlayerName(PlayerId()) == v.owneur then
                        if tonumber(index) == tonumber(v.stationstock) then
                            notraininstation = false
                            if #CurrentTrain > 0 then
                                local notgetout = true
                                for l, m in pairs(CurrentTrain) do
                                    if tonumber(v.uniqueID) == tonumber(m.uniqueID) then
                                        notgetout = false
                                        RageUI.Button('ID :'.. v.uniqueID.. ', ' ..Config.Lang["Modele"] .. v.modellabel.. Config.Lang["TrainOut"], Config.Lang["BoughtThe"]..v.achatdate.. Config.Lang["at"]..v.stationachat, {}, true, {
                                            onSelected = function()
                                                SendNotification(Config.Lang["AlreadyOut"])
                                            end,
                                        })
                                    end
                                end
                                if notgetout then
                                    RageUI.Button('ID :'.. v.uniqueID.. ', ' ..Config.Lang["Modele"] .. v.modellabel, Config.Lang["Station"].. v.stationstock .. '\n'..Config.Lang["BoughtThe"]..v.achatdate.. Config.Lang["at"]..v.stationachat, {}, true, {
                                        onSelected = function()
                                            OpenMenuChooseTrailTrain(index, v.uniqueID)
                                        end,
                                    })
                                end
                            else
                                RageUI.Button('ID :'.. v.uniqueID.. ', ' ..Config.Lang["Modele"] .. v.modellabel, Config.Lang["Station"].. v.stationstock ..'\n'..Config.Lang["BoughtThe"]..v.achatdate.. Config.Lang["at"]..v.stationachat, {}, true, {
                                    onSelected = function()
                                        OpenMenuChooseTrailTrain(index, v.uniqueID)
                                    end,
                                })
                            end
                        end
                    end
                end
                if notraininstation then
                    RageUI.Button(Config.Lang["NoTrainAtThisStation"], nil, {}, true, {
                        onSelected = function()
                        end,
                    })
                end
            end)
            Citizen.Wait(1)
        end
    end)
end

function SpawnTrainInTrail(station, trainindex, uniqueID, trailcoords)
    if ModelsLoaded then
        temptrain = CreateMissionTrain(trainindex, trailcoords.x, trailcoords.y, trailcoords.z, math.random(0,100))
        TriggerServerEvent('az_train:synchroCurrentTrainServer', VehToNet(temptrain), false, uniqueID, trainindex, station)
        SetTrainSpeed(temptrain, 0)
        SetTrainCruiseSpeed(temptrain,0)
        Citizen.Wait(2000)
        trainfreezequaie = true
        TriggerServerEvent('az_train:openStashRobberyServer', VehToNet(temptrain))
    else
        SendNotification(Config.Lang["ProblemChargeTrain"])
    end
end

RegisterNetEvent('az_train:synchroCurrentTrainClient')
AddEventHandler('az_train:synchroCurrentTrainClient', function(temptrain, ingarage, uniqueID, trainindex, station)
    if temptrain ~= 0 and temptrain ~= nil then
        table.insert(CurrentTrain, {entity = NetToVeh(temptrain), ingarage = ingarage, uniqueID = uniqueID, indextrain = trainindex, station = station})
    end
end)

function OpenMenuTrain(index)
    RageUI.CloseAll()
    RageUI.Visible(TRAIN.Menu.Main, not RageUI.Visible(TRAIN.Menu.Main))
    TRAIN.Menu.IsOpen = not TRAIN.Menu.IsOpen
    TRAIN.Menu.Open(index)
end

function OpenMenuChooseTrailTrain(index, uniqueID)
    RageUI.CloseAll()
    RageUI.Visible(TRAIN.Menu.ChooseTrailTrain, true)
    TRAIN.Menu.IsOpen = true
    TRAIN.Menu.Open(index, nil, nil, nil, uniqueID)
end

function OpenMenuChooseGarageTrain(index)
    RageUI.CloseAll()
    RageUI.Visible(TRAIN.Menu.SendTrainToGarage, true)
    TRAIN.Menu.IsOpen = true
    TRAIN.Menu.Open(index)
end

function OpenGarageMenuTrain(index)
    RageUI.CloseAll()
    RageUI.Visible(TRAIN.Menu.GarageTrain, not RageUI.Visible(TRAIN.Menu.GarageTrain))
    TRAIN.Menu.IsOpen = not TRAIN.Menu.IsOpen
    TRAIN.Menu.Open(index)
end

function GetVehicleInDirection(cFrom, cTo)
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, 23) and not cooldownthreaduptrain then
            cooldownthreaduptrain = true
            Citizen.SetTimeout(5000, function()
                cooldownthreaduptrain = false
            end)
            local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
            local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
            local traintoenter = GetVehicleInDirection(coordA, coordB)
            if traintoenter ~= 0 and traintoenter ~= nil and GetVehicleClass(traintoenter) == 21 then
                SetPedIntoVehicle(GetPlayerPed(-1),traintoenter,-1)
                intrain = true
                StartControl(traintoenter)
                trainfreezequaie = false
            end
        end
        Citizen.Wait(0)
    end
end)

function StartControl(traintarget)
    cooldownsendserver = false
    Citizen.CreateThread(function()
        while intrain do
            local wait = 1000
            if GetVehiclePedIsIn(GetPlayerPed(-1), false) ~= 0 and GetVehiclePedIsIn(GetPlayerPed(-1), false) == traintarget then
                wait = 0
                if IsControlJustReleased(0, 23) and not cooldownthreaduptrain then
                    if not cooldownsendserver then
                        speed = 0
                        TaskLeaveVehicle(GetPlayerPed(-1), traintarget, 0)
                        intrain = false
                        if not rampeposeopenstash then
                            cooldownsendserver = true
                            TriggerServerEvent('az_train:openStashRobberyServer', VehToNet(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
                        end
                    else
                        SendNotification(Config.Lang["TooFastToLeaveTrain"])
                    end
                end
                if IsControlPressed(0,71) and speed < Config.MaxVitesseTrain then
                    speed = speed + 0.02
                elseif IsControlPressed(0,72) and speed > -1 then
                    speed = speed - 0.05
                elseif IsControlPressed(0,76) and speed < 2 and speed > - 2  and not trainfreezequaie and not rampeposeopenstash then
                    speed = 0
                    trainfreezequaie = true
                    TriggerServerEvent('az_train:openStashRobberyServer', VehToNet(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
                    cooldownsendserver = false
                end
                if speed > 0 and not cooldownsendserver then
                    cooldownsendserver = true
                    TriggerServerEvent('az_train:closeStashRobberyServer', VehToNet(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
                    trainfreezequaie = false
                end
                if speed < 0 and not cooldownsendserver then
                    cooldownsendserver = true
                    TriggerServerEvent('az_train:closeStashRobberyServer', VehToNet(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
                    trainfreezequaie = false
                end
                SetTrainCruiseSpeed(traintarget,speed)
            end
            Citizen.Wait(wait)
        end
    end)
end

RegisterNetEvent('az_train:updateNewTrain')
AddEventHandler('az_train:updateNewTrain', function(trainmodelindex, stationachat, owneur, achatdate, station, modellabel, uniqueID)
    if owneur == GetPlayerName(PlayerId()) then
        table.insert(OwnedTrain, {trainmodelindex = tonumber(trainmodelindex), stationachat = stationachat, owneur = owneur, achatdate = achatdate, stationstock = station, modellabel = modellabel, uniqueID = tonumber(uniqueID)})
    end
end)

Citizen.CreateThread(function()
    while true do 
        local wait = 1000
        local playercoords = GetEntityCoords(GetPlayerPed(-1))
        for k, v in pairs(Config.TrainShop) do
            if GetDistanceBetweenCoords(playercoords, v.coordspnj, true) < 10 then
                wait = 0
                DrawMarker(20, v.coordspnj.x, v.coordspnj.y, v.coordspnj.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0., 0.3, 255, 255, 255, 200, 1, true, 2, 0, nil, nil, 0)
                if GetDistanceBetweenCoords(playercoords, v.coordspnj, true) < 2 then
                    HelpNotification(Config.Lang["OpenTrainShop"])
                    if IsControlJustReleased(0, 38) then
                        OpenMenuTrain(k)
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local wait = 1000
        local playercoords = GetEntityCoords(GetPlayerPed(-1))
        for k, v in pairs(Config.Stations) do
            if GetDistanceBetweenCoords(playercoords, v.garagecoords, true) < 10 then
                wait = 0
                DrawMarker(20, v.garagecoords.x, v.garagecoords.y, v.garagecoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0., 0.3, 255, 255, 255, 200, 1, true, 2, 0, nil, nil, 0)
                if GetDistanceBetweenCoords(playercoords, v.garagecoords, true) < 2 then
                    HelpNotification(Config.Lang["OpenStation"])
                    if IsControlJustReleased(0, 38) then
                        OpenGarageMenuTrain(k)
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local wait = 1000
        local playercoords = GetEntityCoords(GetPlayerPed(-1))
        for k, v in pairs(Config.Stations) do
            local traintodelete = GetVehiclePedIsIn(PlayerPedId(), false)
            if traintodelete ~= 0 and traintodelete ~= nil then
                if GetDistanceBetweenCoords(playercoords, v.coordsdeletetrain, true) < 30 and traintodelete ~= nil and GetVehicleClass(traintodelete) == 21 then
                    wait = 0
                    HelpNotification(Config.Lang["StowTrain"])
                    if IsControlJustReleased(0, 38) then
                        for x, w in pairs(CurrentTrain) do
                            if w.entity == traintodelete then
                                if k == tonumber(w.station) then
                                    DeleteMissionTrain(traintodelete)
                                    CurrentTrain[x] = nil
                                else
                                    SendNotification(Config.Lang["NotGoodStation"])
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

--[[RegisterCommand('testoffset', function()
    local ped = GetPlayerPed(-1)
    local traintodelete = GetVehiclePedIsIn(PlayerPedId(), false)
    local coords = GetOffsetFromEntityInWorldCoords(traintodelete, 0.0, -42.0, 0.0)
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
end, false)]]

RegisterCommand('rerail', function()
    local ped = GetPlayerPed(-1)
    local traintodelete = GetVehiclePedIsIn(PlayerPedId(), false)
    havetoderailtrain = false
    SetRenderTrainAsDerailed(traintodelete, false)
end, false)

RegisterCommand('posebombtrain', function()
    local ped = GetPlayerPed(-1)
    local playercoords = GetEntityCoords(ped)
    if not spawnbomb then
        SendNotification(Config.Lang["BombPose"])
        TriggerServerEvent('az_train:posebombserver', playercoords)
    else
        SendNotification(Config.Lang["AlreadyBomb"])
    end
end, false)

RegisterCommand('removebomb', function()
    local ped = GetPlayerPed(-1)
    local playercoords = GetEntityCoords(ped)
    for k, v in pairs(BombTrain) do 
        if GetDistanceBetweenCoords(playercoords, v.coordsbomb, true) < 2 then
            if GetVehiclePedIsIn(GetPlayerPed(-1), false) == 0 then
                TriggerServerEvent('az_train:removeBombServer', v.coordsbomb)
                SendNotification(Config.Lang["BombRemove"])
            end
        end
    end
end, false)

RegisterNetEvent('az_train:posebombclient')
AddEventHandler('az_train:posebombclient', function(coordsbomb)
    table.insert(BombTrain, {coordsbomb = coordsbomb})
    haveabomb = true
    ThreadBomb()
end)

local trainderailed = false
function ThreadBomb()
    Citizen.CreateThread(function()
        while haveabomb do
            local wait = 1000
            for k, v in pairs(BombTrain) do 
                if GetVehiclePedIsIn(GetPlayerPed(-1), false) ~= 0 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 21 then
                    local traincoords = GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                    if GetDistanceBetweenCoords(traincoords, v.coordsbomb, true) < 100 then
                        wait = 0
                        if not spawnbomb then
                            spawnbomb = true
                            if not HasModelLoaded('prop_ld_bomb') then
                                RequestModel('prop_ld_bomb')
                        
                                while not HasModelLoaded('prop_ld_bomb') do
                                    Citizen.Wait(1)
                                end
                            end
                            bomb = CreateObject(GetHashKey('prop_ld_bomb'), v.coordsbomb, false, false, true)
                            FreezeEntityPosition(bomb, true)
                            SetEntityRotation(bomb, -100.0, 0.0, 0.0, 0.0, false)
                        end
                        if GetDistanceBetweenCoords(traincoords, v.coordsbomb, true) < 15 and not trainderailed then
                            trainderailed = true
                            havetoderailtrain = true
                            speed = 0
                            TriggerServerEvent('az_train:openStashRobberyServer', VehToNet(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
                            Citizen.Wait(500)
                            AddExplosion(v.coordsbomb, 81, 50, true, false, true, true)
                            TrainDerailed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                            DeleteEntity(bomb)
                            TriggerServerEvent('az_train:removeBombServer', v.coordsbomb)
                            Citizen.Wait(1000)
                            Citizen.SetTimeout(10000, function()
                                trainderailed = false
                                spawnbomb = false
                            end)
                            haveabomb = false
                        end
                    end
                else
                    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.coordsbomb, true) < 100 and not spawnbomb then
                        spawnbomb = true
                        if not HasModelLoaded('prop_ld_bomb') then
                            RequestModel('prop_ld_bomb')
                    
                            while not HasModelLoaded('prop_ld_bomb') do
                                Citizen.Wait(1)
                            end
                        end
                        bomb = CreateObject(GetHashKey('prop_ld_bomb'), v.coordsbomb.x, v.coordsbomb.y, v.coordsbomb.z - 1.2, false, false, true)
                        FreezeEntityPosition(bomb, true)
                        SetEntityRotation(bomb, -100.0, 0.0, 0.0, 0.0, false)
                    end
                end
                Citizen.Wait(wait)
            end
        end
    end)
end

RegisterNetEvent('az_train:removeBombClient')
AddEventHandler('az_train:removeBombClient', function(coordsbomb)
    for q, w in pairs(BombTrain) do
        if coordsbomb == w.coordsbomb then
            BombTrain[q] = nil
            spawnbomb = false
            haveabomb = false
            if DoesEntityExist(bomb) then
                DeleteEntity(bomb)
            end
        end
    end
end)

RegisterNetEvent('az_train:openStashRobberyClient')
AddEventHandler('az_train:openStashRobberyClient', function(trainrob)
    if trainrob ~= 0 and trainrob ~= nil then
        for k, v in pairs(CurrentTrain) do
            if v.entity == NetToVeh(trainrob) then
                for x, w in pairs(Config.Stations[1].chargetrain) do
                    if x == v.indextrain then
                        for j, l in pairs(w.containeroffset) do
                            local coordsrampe = GetOffsetFromEntityInWorldCoords(NetToVeh(trainrob), l.x, l.y, l.z)
                            rampeposeopenstash = true
                            OpenStashTrain(v.uniqueID, w.storagekg, coordsrampe, j)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('az_train:closeStashRobberyClient')
AddEventHandler('az_train:closeStashRobberyClient', function(trainrob)
    if trainrob ~= 0 and trainrob ~= nil then
        for k, v in pairs(CurrentTrain) do
            if v.entity == NetToVeh(trainrob) then
                local traincoords = GetEntityCoords(v.entity)
                local playercoords = GetEntityCoords(GetPlayerPed(-1))
                if GetDistanceBetweenCoords(traincoords, playercoords, true) < 100 then
                    rampeposeopenstash = false
                    trainfreezequaie = false
                end
            end
        end
    end
end)

function TrainDerailed(trainderail)
    Citizen.CreateThread(function()
        while havetoderailtrain do
            SetRenderTrainAsDerailed(trainderail, true)
            FreezeEntityPosition(trainderail, true)
            SetTrainCruiseSpeed(trainderail,0)
            intrain = false
            Citizen.Wait(0)
        end
    end)
end

function OpenStashTrain(idtrain, storagekg, stockageposition, indexcontainer)
    Citizen.CreateThread(function()
        while rampeposeopenstash do
            local wait = 1000
            local playercoords = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(playercoords, stockageposition.x, stockageposition.y, stockageposition.z + 1.0, true) < 3 then
                wait = 0
                HelpNotification(Config.Lang["OpenStorage"])
                if IsControlJustReleased(0, 38) then
                    OpenStashTrainConfig(idtrain, storagekg, indexcontainer)
                end
            end
            Citizen.Wait(wait)
        end
    end)
end
