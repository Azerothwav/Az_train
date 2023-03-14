RegisterCommand('attachToTrain', function()
    local vehicle, distance = GetClosetVehicle()
    if distance < 2 and GetVehicleClass(vehicle) == 21 then
        AttachEntityToEntity(PlayerPedId(), vehicle, GetEntityBoneIndexByName(vehicle, 'chassis'), GetOffsetFromEntityGivenWorldCoords(vehicle, GetEntityCoords(PlayerPedId())), 0.0, 0.0, 0.0, false, false, true, false, 20, true)
    end
end, false)

RegisterCommand('detachToTrain', function()
    DetachEntity(PlayerPedId(), true, false)
end, false)