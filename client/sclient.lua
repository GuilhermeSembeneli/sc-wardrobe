---------------------------------------------------------------------------------------------------------
--VRP
---------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
SC = Tunnel.getInterface("sc-wardrobe")
---------------------------------------------------------------------------------------------------------
--VARIABLES
---------------------------------------------------------------------------------------------------------
local nui = false
---------------------------------------------------------------------------------------------------------
--THREAD
---------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local ScWait = 1000
        local ped = PlayerPedId()
        local pedhash = GetEntityModel(ped)
        local position = GetEntityCoords(ped)
        for k,v in pairs(SConfig.config)  do
            local distance = #(position - vector3(v.x, v.y, v.z))
            if distance <= 5 then
                ScWait = 5
                DrawMarker(1, v.x, v.y, v.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.3, 236, 34, 44, 100, false, true, 2, true, 0, 0,false)
                if distance < 1 then
                    if IsControlJustPressed(0, 38) and SC.CheckPerm(v.perm) then
                            nui = true
                        if pedhash == GetHashKey("mp_m_freemode_01") or pedhash == GetHashKey("mp_f_freemode_01") then
                            local convertSex = nil
                            if pedhash == 1885233650 then
                                convertSex = "male"
                            else
                                convertSex = "female"
                            end
                            FreezeEntityPosition(ped, true)
                            SetEntityHeading(ped, v.h)
                            SetCameraCoords()
                            nui = true
                            SetNuiFocus(true, true)
                            SendNUIMessage({send = 'open', ped = convertSex, GetPerm = SC.GetPerm() })
                        end      
                    end
                end
            end
        end
        Citizen.Wait(ScWait)
    end
end)

---------------------------------------------------------------------------------------------------------
--NUI
---------------------------------------------------------------------------------------------------------
RegisterNUICallback('closed', function()
    FreezeEntityPosition(PlayerPedId(), false)

    nui = false
    SendNUIMessage({send = 'closed'})
    DeleteCam()
    SetNuiFocus(false, false)
    FreezeEntityPosition(ped, false)
end)

RegisterNUICallback("Fards", function ( data)
    SC.ClothesWardrobe(data.clothes)
end)

RegisterNUICallback("Remove", function (data,cb)
    SC.RemoveClothes()
end)

---------------------------------------------------------------------------------------------------------
--FUNCTION
---------------------------------------------------------------------------------------------------------
function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local factor = #text / 460
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.3, 0.3)
    SetTextFont(6)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 160)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    DrawRect(_x,_y + 0.0115, 0.02 + factor, 0.027, 28, 28, 28, 95)
end

function SetCameraCoords()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(camera, false)
    if not DoesCamExist(camera) then
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(camera, true)
        RenderScriptCams(true, true, 1000, true, true)
                local ply = PlayerPedId()
                local plyCoords = GetEntityCoords(ply)
                local cameraCoords = GetOffsetFromEntityInWorldCoords(ply, 0.0, 2.0, 0.0)
                SetCamCoord(camera, cameraCoords.x, cameraCoords.y, cameraCoords.z + 0.85)
                PointCamAtCoord(camera, plyCoords.x, plyCoords.y, plyCoords.z + 0.15)
    end
end

function DeleteCam()
    SetCamActive(camera, false)
    RenderScriptCams(false, true, 0, true, true)
    camera = nil
end
