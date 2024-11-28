stds.cfx = {
    read_globals = {
        Citizen = {
            fields = { 'Wait', 'CreateThread', 'SetTimeout', 'Await', 'Trace', 'InvokeNative' }
        },
        exports = { other_fields = true },
        GlobalState = { other_fields = true },
        'Player',
        'Vehicle',
        'Wait',
        'CreateThread',
        'SetTimeout',
        'Await',
        'Trace',
        'quat',
        'vec',
        'vector2',
        'vec2',
        'vector3',
        'vec3',
        'vector4',
        'vec4',
        'AddEventHandler',
        'RegisterNetEvent',
        'TriggerEvent',
        'RemoveEventHandler',
        'RageUI',
        'RenderSprite',
        'RenderRectangle',
        'RenderText',
        'MeasureStringWidth',
        'LeftArrowHovered',
        'RightArrowHovered',
        'UpdateOnscreenKeyboard',
        'SetScriptGfxAlign',
        'SetScriptGfxAlignParams',
        'ResetScriptGfxAlign',
        'DrawScaleformMovieFullscreen',
        'SetScriptGfxDrawOrder',
        'GetGameplayCamRelativeHeading',
        'IsDisabledControlJustPressed',
        'SetMouseCursorActiveThisFrame',

        'PlayerPedId',
        'GetEntityCoords',
        'SetEntityHeading',
        'PlayerPedId',
        'GetEntityCoords',
        'SetEntityHeading',

        json = { fields = { 'encode', 'decode' } }
    }
}

stds.shared = { read_globals = { math = { fields = { 'round' } } } }

stds.cfx_sv = {
    globals = { 'GlobalState' },
    read_globals = {
        'source',
        'TriggerClientEvent',
        'TriggerLatentClientEvent',
        'RegisterServerEvent',
        'GetPlayerIdentifiers',
        'GetPlayers',
        'PerformHttpRequest',
        'CreateVehicle'
    }
}

stds.cfx_cl = {
    read_globals = { 'TriggerServerEvent', 'RegisterNUICallback', 'SendNUIMessage', 'GlobalState' }
}

stds.cfx_manifest = {
    read_globals = {
        'author',
        'description',
        'repository',
        'version',
        'rdr3_warning',
        'fx_version',
        'games',
        'game',
        'authors',
        'author',
        'server_scripts',
        'server_script',
        'client_scripts',
        'client_script',
        'shared_scripts',
        'shared_script',
        'ui_page',
        'files',
        'file',
        'export',
        'exports',
        'replace_level_meta',
        'data_file',
        'this_is_a_map',
        'server_only',
        'loadscreen',
        'dependency',
        'dependencies',
        'provide',
        'lua54',
        'disable_lazy_natives',
        'clr_disable_task_scheduler',
        'my_data',
        'ui_page_preload',
        'loadscreen_manual_shutdown'
    }
}

stds.esx_legacy = {
    read_globals = {
        MySQL = { fields = { 'ready', 'insert', 'update', 'scalar', 'single', 'prepare', 'query' } }
    }
}

exclude_files = {
    '**/ox_*/*',
    '**/lib/menu/**',
    '**/rp-radio/*',
    '**/pma-voice/*',
    '**/qs-*/*',
    '**/cs-video-call/*',
    '**/rageui/*',
    '**/cfx-*/*',

    '**/uj_vesp_ipl/*',
    '**/fiv3devs_pacificbluffs/*',
    '**/fiv3devs_bahamamamas/*',
    '**/cfx_gn_collection/*',
    '**/Burger_shot/*',
    '**/AB45-MajestyMansion/*',
    '**/rcore_*/*',
    '**/PlasmaTron/*',
    '**/patoche_bumpercar_script/*',
    '**/PlasmaLobby/*',
    '**/PlasmaGun/*',
    '**/PlasmaGame/*',
    '**/PlasmaRandom/*',
    '**/katana_2/*',
    '**/gn_tplift_mountzonah/*',
    '**/uj_vesp_optimaze/*',
    '**/PatamodsElevatorV2/*',
    '**/rdzk_r_calm_coffee/*'
}

-- manifest
files['**/fxmanifest.lua'].std = 'cfx_manifest'
files['**/__resource.lua'].std = 'cfx_manifest'
files['**/fxmanifest.lua'].ignore = { '113', '611', '111', '614' }
files['**/__resource.lua'].ignore = { '113', '611', '111', '614' }
-- clients
files['**/client.lua'].std = 'cfx+cfx_cl+shared'
files['**/cl_*.lua'].std = 'cfx+cfx_cl+shared'
files['**/client/**/*.lua'].std = 'cfx+cfx_cl+shared'
files['**/client.lua'].std = 'cfx+cfx_cl+shared'
files['**/cl_*.lua'].std = 'cfx+cfx_cl+shared'
files['**/client/**/*.lua'].std = 'cfx+cfx_cl+shared'
-- server
files['**/server.lua'].std = 'cfx+cfx_sv+shared'
files['**/sv_*.lua'].std = 'cfx+cfx_sv+shared'
files['**/server/**/*.lua'].std = 'cfx+cfx_sv+shared'
files['**/server.lua'].std = 'cfx+cfx_sv+shared'
files['**/sv_*.lua'].std = 'cfx+cfx_sv+shared'
files['**/server/**/*.lua'].std = 'cfx+cfx_sv+shared'
-- shared
files['**/shared.lua'].std = 'cfx+cfx_sv+cfx_cl+shared'
files['**/shared/**/*.lua'].std = 'cfx+cfx_sv+cfx_cl+shared'
files['**/shared.lua'].std = 'cfx+cfx_sv+cfx_cl+shared'
files['**/shared/**/*.lua'].std = 'cfx+cfx_sv+cfx_cl+shared'
-- default
max_line_length = 140
max_cyclomatic_complexity = 100
self = false
codes = true
quiet = 1
color = true
ignore = {
    '611',
    '612',
    '033',
    '542',
    '111',
    '432',
    '321',
    '143',
    '411',
    '214',
    '582',
    '614',
    '112',
    '113',
    '311',
    '211',
    '212',
    '213',
    '631',
    '431',
    '033',
    '412',
    '142',
    '413',
    '232',
    '512'
}
