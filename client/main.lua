local ownedTrain, bombTable, ModelsLoaded = {}, {}, false

RageMenuTrain = {}
RageMenuTrain.Menu = {}
RageMenuTrain.Menu.IsOpen = false
RageMenuTrain.Menu.Shop = RageUI.CreateMenu("", Config.Lang["TrainShop"], nil, nil, "root_cause", "shopui_title_elitastravel")
RageMenuTrain.Menu.Garage = RageUI.CreateMenu("", Config.Lang["TrainStation"], nil, nil, "root_cause", "shopui_title_elitastravel")
RageMenuTrain.Menu.Path = RageUI.CreateSubMenu(RageMenuTrain.Menu.Garage, "", Config.Lang["ChooseTrail"], nil, nil, "root_cause", "shopui_title_elitastravel")

RageMenuTrain.Menu.Shop.Closed = function()
    RageUI.CloseAll()
    RageMenuTrain.Menu.IsOpen = false
end

RageMenuTrain.Menu.Garage.Closed = function()
    RageUI.CloseAll()
    RageMenuTrain.Menu.IsOpen = false
end

function loadData()
    if Config.FrameWork == "custom" then
        TriggerServerEvent("az_train:getTrains")
    else
        Config.CallBack("az_train:getMyTrain", function(result)
            for k, v in pairs(result) do
                ownedTrain[k] = {}
                for x, w in pairs(v) do
                    ownedTrain[k][x] = w
                end
            end
        end)
    end
end

RegisterNetEvent("az_train:getTrains", function(result)
    for k, v in pairs(result) do
        ownedTrain[k] = {}
        for x, w in pairs(v) do
            ownedTrain[k][x] = w
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k, v in pairs(Config.Stations) do
            DeleteEntity(v.pnj)
            RemoveBlip(v.blip)
        end
        for k, v in pairs(Config.TrainShop) do
            DeleteEntity(v.pnj)
            RemoveBlip(v.blip)
        end
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        loadData()
    end
end)

RegisterNetEvent("az_train:newTrain", function(data)
    table.insert(ownedTrain, data)
    Config.SendNotification(Config.Lang["Bought"]..data.label)
    Config.SendNotification(string.format(Config.Lang["TrainStockIn"], Config.Stations[1].label))
end)

function openMenu(index)
    RageMenuTrain.Menu.IsOpen = true
    local lastTrainIndex = nil
    while RageMenuTrain.Menu.IsOpen do
        RageUI.IsVisible(RageMenuTrain.Menu.Shop, function()
            for k, v in pairs(Config.TrainShop[index].traintobuy) do
                for x, w in pairs(Config.Trains) do
                    if w.trainindex == v then
                        RageUI.Button(w.label, Config.CanAccess(Config.TrainShop[index].job) and string.format(Config.Lang["TrainInfos"], w.price, w.storage) or Config.Lang["AccessDenied"], {}, Config.CanAccess(Config.TrainShop[index].job), {
                            onSelected = function()
                                TriggerServerEvent("az_train:buyTrain", w)
                                RageMenuTrain.Menu.Shop.Closed()
                            end
                        })
                    end
                end
            end 
        end)
        RageUI.IsVisible(RageMenuTrain.Menu.Garage, function()
            for k, v in pairs(ownedTrain) do
                if v.station == index then
                    RageUI.Button(string.format(Config.Lang["GetOutTrain"], v.label), string.format(Config.Lang["TrainInfos"], v.price, v.storage), {}, v.state == "in", {
                        onSelected = function()
                            lastTrainIndex = v.uniqueID
                            RageUI.Visible(RageMenuTrain.Menu.Garage, false)
                            RageUI.Visible(RageMenuTrain.Menu.Path, true)
                        end
                    })
                end
            end 
        end)
        RageUI.IsVisible(RageMenuTrain.Menu.Path, function()
            for k, v in pairs(Config.Stations[index].path) do
                RageUI.Button(Config.Lang["Track"]..k, nil, {}, true, {
                    onSelected = function()
                        RageMenuTrain.Menu.Shop.Closed()
                        getOutTrain(lastTrainIndex, v)
                    end,
                    onActive = function()
                        DrawMarker(20, v.x, v.y, v.z + 1.1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0., 0.3, 255, 255, 255, 200, 1, true, 2, 0, nil, nil, 0)
                    end
                })
            end 
        end)
        Citizen.Wait(0)
    end
end

function getOutTrain(uniqueID, coords)
    if ModelsLoaded then
        for k, v in pairs(ownedTrain) do
            if v.uniqueID == uniqueID and coords ~= nil and v.trainindex ~= nil then
                local tempTrain = CreateMissionTrain(v.trainindex, coords.x, coords.y, coords.z, false)
                while not DoesEntityExist(tempTrain) do
                    Citizen.Wait(500)
                end
                SetTrainSpeed(tempTrain, 0)
                SetTrainCruiseSpeed(tempTrain, 0)
                TriggerServerEvent("az_train:syncAction", v.uniqueID, v.storage, VehToNet(tempTrain))
                TriggerServerEvent("az_train:changeState", v.uniqueID, "out")
            end
        end
    else
        Config.SendNotification(Config.Lang["ProblemChargeTrain"])
    end
end

RegisterNetEvent("az_train:syncAction", function(uniqueID, storage, vehNet)
    Citizen.CreateThread(function()
        local tempTrain = NetToVeh(vehNet)
        while tempTrain == 0 do
            tempTrain = NetToVeh(vehNet)
            Citizen.Wait(1000)
        end
        local maxSpeed = 27
        for k, v in pairs(ownedTrain) do
            if v.uniqueID == uniqueID then
                maxSpeed = v.maxSpeed
            end
        end
        Citizen.CreateThread(function()
            while DoesEntityExist(tempTrain) do
                local wait = 1000
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(tempTrain), true) < 7 and not IsPedInAnyVehicle(PlayerPedId(), true) then
                    wait = 0
                    Config.HelpNotification(Config.Lang["TrainInfo"])
                    if IsControlJustReleased(0, 23) then
                        SetPedIntoVehicle(PlayerPedId(), tempTrain, -1)
                        Citizen.Wait(1000)
                        local speed = 0
                        Citizen.CreateThread(function()
                            while GetPedInVehicleSeat(tempTrain, -1) == PlayerPedId() do
                                local wait2 = 1000
                                for x, w in pairs(Config.Stations) do
                                    if GetDistanceBetweenCoords(GetEntityCoords(tempTrain), w.coordsdeletetrain, true) < 20 then
                                        wait2 = 0
                                        Config.HelpNotification(Config.Lang["StowTrain"])
                                        if IsControlJustReleased(0, 38) then
                                            DeleteMissionTrain(tempTrain)
                                            TriggerServerEvent("az_train:changeState", uniqueID, "in", x)
                                        end
                                    end
                                end
                                Citizen.Wait(wait2)
                            end
                        end)
                        Citizen.CreateThread(function()
                            while GetPedInVehicleSeat(tempTrain, -1) == PlayerPedId() do
                                if IsControlJustReleased(0, 23) then
                                    speed = 0
                                    SetTrainCruiseSpeed(tempTrain, speed)
                                    TaskLeaveVehicle(PlayerPedId(), tempTrain, 0)
                                end
                                if IsControlPressed(0,71) and speed < maxSpeed then
                                    speed = speed + 0.02
                                elseif IsControlPressed(0,72) and speed > -1 then
                                    speed = speed - 0.05
                                end
                                SetTrainCruiseSpeed(tempTrain, speed)
                                Citizen.Wait(0)
                            end
                        end)
                    end
                    if IsControlJustReleased(0, 74) then
                        Config.OpenStash(uniqueID, storage)
                    end
                end
                Citizen.Wait(wait)
            end
        end)
    end)
end)

Citizen.CreateThread(function()
    DeleteAllTrains()
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
	for k, v in pairs (Config.TrainShop) do
		v.blip = Config.CreateBlip(v.coordspnj.xyz, 0.5, Config.Lang["TrainShop"], 569, 0)
        v.pnj = Config.CreatePNJ(v.coordspnj, v.pedmodel, false)
        Citizen.CreateThread(function()
            while true do
                local wait = 1000
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coordspnj.xyz, true) < 2 then
                    wait = 0
                    Config.HelpNotification(Config.Lang["OpenTrainShop"])
                    if IsControlJustReleased(0, 38) then
                        RageUI.Visible(RageMenuTrain.Menu.Shop, not RageUI.Visible(RageMenuTrain.Menu.Shop))
                        openMenu(k)
                    end
                end
                Citizen.Wait(wait)
            end
        end)
	end
    for k, v in pairs (Config.Stations) do
		v.blip = Config.CreateBlip(v.coordspnj.xyz, 0.5, string.format(Config.Lang["TrainStation"], v.label), 309, 0)
        v.pnj = Config.CreatePNJ(v.coordspnj, v.pedmodel, false)
        Citizen.CreateThread(function()
            while true do
                local wait = 1000
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coordspnj.xyz, true) < 2 then
                    wait = 0
                    Config.HelpNotification(Config.Lang["OpenStation"])
                    if IsControlJustReleased(0, 38) then
                        RageUI.Visible(RageMenuTrain.Menu.Garage, not RageUI.Visible(RageMenuTrain.Menu.Garage))
                        openMenu(k)
                    end
                end
                Citizen.Wait(wait)
            end
        end)
	end
end)

RegisterNetEvent("az_train:changeState", function(uniqueID, state, lastStation)
    for k, v in pairs(ownedTrain) do
        if v.uniqueID == uniqueID then
            v.state = state
            if lastStation ~= nil then
                v.station = lastStation
            end
        end
    end
end)

RegisterNetEvent("az_train:poseBomb", function()
    Config.SendNotification(Config.Lang["BombPose"])
    -- Do some animation here
end)

RegisterNetEvent("az_train:removeBomb", function(position)
    for k, v in pairs(bombTable) do
        if v.position == position then
            DeleteEntity(v.object)
        end
    end
end)

RegisterNetEvent("az_train:poseBombAll", function(position)
    if not HasModelLoaded('prop_ld_bomb') then RequestModel('prop_ld_bomb') while not HasModelLoaded('prop_ld_bomb') do Citizen.Wait(500) end end
    local bombObject = CreateObject(GetHashKey("prop_ld_bomb"), position.xyz, false, false, false)
    PlaceObjectOnGroundProperly(bombObject)
    SetEntityRotation(bombObject, -100.0, 0.0, 0.0, 0.0, false)
    FreezeEntityPosition(bombObject, true)
    table.insert(bombTable, {position = position, object = bombObject})
    Citizen.CreateThread(function()
        while DoesEntityExist(bombObject) do
            local wait = 1000
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), position, true) < 30 then
                wait = 500
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), position, true) < 15 and GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 and GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) == 21 then
                    wait = 0
                    AddExplosion(position, 81, 50, true, false, true, true)
                    SetRenderTrainAsDerailed(GetVehiclePedIsIn(PlayerPedId(), false))
                    SetTrainCruiseSpeed(GetVehiclePedIsIn(PlayerPedId(), false),0)
                    TriggerServerEvent("az_train:removeBomb", position)
                elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), position, true) < 2 then
                    wait = 0
                    Config.HelpNotification(Config.Lang["BombDefuse"])
                    if IsControlJustReleased(0, 38) then
                        Config.SendNotification(Config.Lang["BombRemove"])
                        TriggerServerEvent("az_train:removeBomb", position)
                    end
                end
            end
            Citizen.Wait(wait)
        end
    end)
end)

function RequestModelSync(mod)
    tempmodel = GetHashKey(mod)
    RequestModel(tempmodel)
    while not HasModelLoaded(tempmodel) do
        Citizen.Wait(1)
    end
end
