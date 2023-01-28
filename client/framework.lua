if Config.FrameWork == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()

    PlayerJob = {}

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
        PlayerJob = JobInfo
    end)
elseif Config.FrameWork == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        ESX.PlayerData = xPlayer
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        ESX.PlayerData.job = job
    end)

    RegisterNetEvent('esx:setJob2')
    AddEventHandler('esx:setJob2', function(job2)
        ESX.PlayerData.job2 = job2
    end)

    RegisterNetEvent('esx:setJob3')
    AddEventHandler('esx:setJob3', function(job3)
        ESX.PlayerData.job3 = job3
    end)
elseif Config.FrameWork == 'custom' then
    
end