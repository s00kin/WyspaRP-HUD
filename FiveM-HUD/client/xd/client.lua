local WRPLoaded = false
AddEventHandler('sokin:loading', function(status)
	if status == 2 then
		WRPLoaded = true
	end
end)



local Ped = {
	Id = nil,
	Health = 0,
	Armor = 0,
	Stamina = 0,
	Oxygen = 0,
	Direction = 'N',
	Zone = '',
	Street = '',
	Vehicle = false,
	GpsDistance = 0.0,
	GpsDirection = 0
}


local HUD = {
	Minimap = nil,
	Masked = false,
	Ready = false,
	Hide = false,
	Pause = false,
	NeedsRebuild = nil,
	LastBuild = 'minimap',
	Admin = false,
	PhoneVisible = false,
	Blip = nil,
	State = false,
	Big = false,
	Offset = Config.Minimap.Rect['minimap'],
	Wheel = nil,

	VehicleClass = nil,
	VehicleStopped = true,
	VehicleEngine = false,
	VehicleGear = 'P'
}


local setScriptGfxAlign = SetScriptGfxAlign
local getScriptGfxPosition = GetScriptGfxPosition
local resetScriptGfxAlign = ResetScriptGfxAlign
local resolutionFunc = GetActiveScreenResolution
local aspectFunc = GetAspectRatio
local radarFunc = IsRadarHidden
local streetFunc = GetStreetNameFromHashKey
local nuiProxy = SendNUIMessage
local _in = Citizen.InvokeNative
local ptr = Citizen.PointerValueInt()

local function RebuildRadar(data, clip, big)
	if clip == 1 then
		if not replaced then
	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "sokin", "radarmasksm")
			replaced = true
		end
	elseif replaced then
		RemoveReplaceTexture("platform:/textures/graphics", "radarmaskm")
		replaced = false
	end

	SetMinimapClipType(clip)
	for k, v in pairs(data) do
		SetMinimapComponentPosition(k, 'L', 'B', v.Pos.x, v.Pos.y, v.Size.x, v.Size.y)
	end

	local m = RequestScaleformMovie("minimap")
	if big then
		HUD.Offset = Config.Minimap.Bigmap['bigmap']
	else
		HUD.Offset = data['minimap']
	end


	SetRadarBigmapEnabled(true, false)
	if not big then
		Citizen.Wait(0)
		SetRadarBigmapEnabled(false, false)
	end

	return m
end

local function VisibilityHelper(wyspa)
	return HUD.PhoneVisible
end

local function CheckRadar(state)
	HUD.State = radarFunc() ~= 1
	if HUD.State ~= state then
		DisplayRadar(state)
		if state then
			nuiProxy({type = 'rebuild', value = HUD.LastBuild})
		else
			nuiProxy({type = 'rebuild', value = 'freeroam'})
		end
	end
end

local function GetMinimapAnchor(nui)
	local offset = HUD.Offset
	if not HUD.State then
		offset = Config.Minimap.Rect['minimap']
	end

	setScriptGfxAlign(string.byte('L'), string.byte('B'))
	local minimapTopX, minimapTopY = getScriptGfxPosition(offset.Pos.x, offset.Pos.y - offset.Size.y)
	local minimapBottomX, minimapBottomY = getScriptGfxPosition(offset.Pos.x + offset.Size.x, offset.Pos.y)

	resetScriptGfxAlign()
	if not nui then
		return { x = minimapTopX, y = minimapTopY }
	end

	local w, h = resolutionFunc()
	local x, y = w * minimapTopX, h * minimapTopY
	return { x = x, y = y, width = w * minimapBottomX - x, height = h * minimapBottomY - y, a = aspectFunc() }
end

local function GetStreetsCustom(coords)
	for _, street in ipairs(Config.CustomStreets) do
		if coords.x >= street.start_x and coords.x <= street.end_x and coords.y >= street.start_y and coords.y <= street.end_y then
			return "~y~" .. street.name
		end
	end

	local s1, s2 = _in(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, ptr, ptr)
	local result = {streetFunc(s1), streetFunc(s2)}
	if result[2] == "" then
		table.remove(result, 2)
	end

	return result
end

Citizen.CreateThread(function()
	if Config.Iswyspa then
		while not WRPLoaded do
			Citizen.Wait(50)
		end
	else
		while not NetworkIsSessionActive() do
			Citizen.Wait(50)
		end
	end
	
	

    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)

	for k, v in pairs(Config.Minimap.Bigmap) do
		SetMinimapComponentPosition(k, 'L', 'B', v.Pos.x, v.Pos.y, v.Size.x, v.Size.y)
	end
	Citizen.Wait(0)
	HUD.Minimap = RebuildRadar(Config.Minimap.Round, 1, false)

	SetBlipAlpha(GetMainPlayerBlipId(), 0)
	SetBlipAlpha(GetNorthRadarBlip(), 0)
	DisplayRadar(false)

	nuiProxy({type = 'init', value = GetPlayerServerId(PlayerId())})
	while not HUD.Ready do
		Citizen.Wait(50)
	end

	local scaleformFunc = CallScaleformMovieMethod
	local timer = GetGameTimer
	local bigmapFunc = IsBigmapActive
	local zoomFunc = SetRadarZoom
	local speedFunc = GetEntitySpeed
	local rpmFunc = GetVehicleCurrentRpm
	local frameFunc = HideMinimapInteriorMapThisFrame
        local ped = PlayerPedId()


		local Hidden, RPMTime = false, timer()
		while true do
			Citizen.Wait(0)
	
			HUD.Big = bigmapFunc()
			if HUD.Pause or HUD.Hide then
				Hidden = true
				CheckRadar(false)
				nuiProxy({type = 'hide'})
			else
				if Hidden then
					Hidden = false
					nuiProxy({type = 'show'})
				end
	
				if WRPLoaded and not LocalPlayer.state.InCayo then
					frameFunc()
				end
	
				local lastBuild = HUD.LastBuild
				if IsControlJustPressed(0, 121) then
					HUD.LastBuild = 'minimap'
					if not HUD.Big then
						HUD.Minimap = RebuildRadar(Config.Minimap.Rect, 0, true)
						HUD.LastBuild = 'bigmap'
					elseif HUD.VehicleClass then
						HUD.Minimap = RebuildRadar(Config.Minimap.RoundVehicle, 1, false)
					else
						HUD.Minimap = RebuildRadar(Config.Minimap.Round, 1, false)
					end
	
					HUD.Big = bigmapFunc()
				end
	
				CheckRadar((HUD.VehicleClass ~= nil) or VisibilityHelper())
				if lastBuild ~= HUD.LastBuild and HUD.State then
					nuiProxy({type = 'rebuild', value = HUD.LastBuild})
				end

	
				zoomFunc(1200)
			if HUD.VehicleClass then
				local data = {
					Speed = math.floor(speedFunc(Ped.Vehicle) * 3.6 + 0.5),
					Gear = HUD.VehicleGear,
					RPMScale = 0
				}
				if WRPLoaded then
					data.CruiseControl = GlobalState.CruisedSpeed
				end

				if not HUD.VehicleEngine then
					data.Gear = 'P'
				elseif HUD.VehicleStopped then
					data.Gear = 'N'
				elseif HUD.VehicleClass == 15 or HUD.VehicleClass == 16 then
					data.Gear = 'F'
				elseif HUD.VehicleClass == 14 then
					data.Gear = 'S'
				elseif data.Gear == 0 then
					data.Gear = 'R'
				end

				if (HUD.VehicleClass >= 0 and HUD.VehicleClass <= 5) or (HUD.VehicleClass >= 9 and HUD.VehicleClass <= 12) or HUD.VehicleClass == 17 or HUD.VehicleClass == 18 or HUD.VehicleClass == 20 then
					data.RPMScale = 7000
				elseif HUD.VehicleClass == 6 then
					data.RPMScale = 7500
				elseif HUD.VehicleClass == 7 then
					data.RPMScale = 8000
				elseif HUD.VehicleClass == 8 then
					data.RPMScale = 11000
				elseif HUD.VehicleClass == 15 or HUD.VehicleClass == 16 then
					data.RPMScale = -1
				end

				local now = timer()
				if RPMTime > now then
					--
				elseif data.RPMScale == -1 then
					data.RPM = Ped.Altitude
				else
					local r = rpmFunc(Ped.Vehicle)
					if not HUD.VehicleEngine then
						r = 0
					elseif r > 0.99 then
						r = r * 100
						r = r + math.random(-2, 2)

						r = r / 100
						if r < 0.12 then
							r = 0.12
						end
					else
						r = r - 0.1
					end

					data.RPM = math.floor(data.RPMScale * r + 0.5)
					if data.RPM < 0 then
						data.RPM = 0
					elseif data.Speed == 0.0 and r ~= 0 then
						data.RPM = math.random(data.RPM, (data.RPM + 50))
					end

					data.RPM = math.floor(data.RPM / 10) * 10
					RPMTime = now + 50
				end

				nuiProxy({
					type = 'update',
					data = data
				})
			end
	
			if HUD.NeedsRebuild ~= nil then
				local visible = VisibilityHelper()
				if HUD.NeedsRebuild then
					visible = true
					if not bigmapFunc() then
						HUD.Minimap = RebuildRadar(Config.Minimap.RoundVehicle, 1, false)
						HUD.LastBuild = 'minimap'
					else
						HUD.LastBuild = 'bigmap'
					end
				elseif not bigmapFunc() then
					HUD.Minimap = RebuildRadar(Config.Minimap.Round, 1, false)
					HUD.LastBuild = 'minimap'
					if not visible then
						nuiProxy({type = 'rebuild', value = 'freeroam'})
					end
				else
					HUD.LastBuild = 'bigmap'
					if not visible then
						nuiProxy({type = 'rebuild', value = 'freeroam'})
					end
				end

				HUD.NeedsRebuild = nil
				if visible then
					nuiProxy({type = 'rebuild', value = HUD.LastBuild})
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	RequestStreamedTextureDict("sokin")
	while not HasStreamedTextureDictLoaded("sokin") and not HUD.Ready do
		Citizen.Wait(0)
	end

	local MM = GetMinimapAnchor(true)
	nuiProxy({
		type = 'update',
		anchor = MM
	})

	local pauseFunc = IsPauseMenuActive
	local getPid = PlayerId
	local getPed = PlayerPedId
	local healthFunc = GetEntityHealth
	local armorFunc = GetPedArmour
	local staminaFunc = GetPlayerSprintStaminaRemaining
	local oxygenFunc = GetPlayerUnderwaterTimeRemaining
	local compassFunc = GetGameplayCamRot
	local scaleFormOne = BeginScaleformMovieMethod
	local scaleFormTwo = EndScaleformMovieMethodReturnValue
	local scaleFormThree = IsScaleformMovieMethodReturnValueReady
	local scaleFormFour = GetScaleformMovieMethodReturnValueInt
	local vehicleFunc = GetVehiclePedIsIn
	local classFunc = GetVehicleClass
	local stopFunc = IsVehicleStopped
	local engineFunc = GetIsVehicleEngineRunning
	local gearboxFunc = GetVehicleCurrentGear
	local zoneFunc = GetNameOfZone
	local coordsFunc = GetEntityCoords
	local headingFunc = GetEntityHeading
	local hoursFunc = GetClockHours
	local minutesFunc = GetClockMinutes

	while true do
		Citizen.Wait(200)
		if not HUD.Pause and pauseFunc() then
			HUD.Pause = true
		elseif HUD.Pause and not pauseFunc() then
			HUD.Pause = false
		end

		local pid = getPid()
		local ped = getPed()
		local coords = coordsFunc(ped, false)
		local heading = headingFunc(ped)


		MM = GetMinimapAnchor(true)
		if Ped.Id ~= ped then
			if HUD.Blip and DoesBlipExist(HUD.Blip) then
				RemoveBlip(HUD.Blip)
			end

			HUD.Blip = AddBlipForEntity(ped)
			SetBlipSprite(HUD.Blip, (Ped.Vehicle and 545 or 1))

			SetBlipScale(HUD.Blip, 1.0)
			SetBlipCategory(HUD.Blip, 1)
			SetBlipPriority(HUD.Blip, 10)
			SetBlipColour(HUD.Blip, 0) --55
			SetBlipAsShortRange(HUD.Blip, true)

			SetBlipRotation(HUD.Blip, math.ceil(heading))
			ShowHeadingIndicatorOnBlip(HUD.Blip, true)
			Ped.Id = ped

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Twoja pozycja")
			EndTextCommandSetBlipName(HUD.Blip)
		end


		local direction = nil
		for k, v in pairs(Config.Directions) do
			direction = heading
			if math.abs(direction - k) < 22.5 then
				direction = v
				break
			end
		end

		Ped.Direction = direction or 'N'
		Ped.Health = healthFunc(ped)
		Ped.Armor = armorFunc(ped)
		Ped.Altitude = math.ceil(coords.z)
		Ped.Rotation = compassFunc().z

		Ped.Stamina = staminaFunc(pid)
		if Ped.Stamina < 0.0 then
			Ped.Stamina = 0.0
		end

		Ped.Oxygen = oxygenFunc(pid)
		if Ped.Oxygen < 0.0 then
			Ped.Oxygen = 0.0
		end

		local vehicle = vehicleFunc(Ped.Id, false)
		if vehicle and vehicle ~= 0 then
			if not Ped.Vehicle then
        RemoveBlip(GetNorthRadarBlip())
        SetBlipAlpha(GetNorthRadarBlip(), 0)
				SetBlipSprite(HUD.Blip, 545)
				SetBlipScale(HUD.Blip, 1.0)
				SetBlipCategory(HUD.Blip, 1)
				SetBlipPriority(HUD.Blip, 10)
				SetBlipColour(HUD.Blip, 0) -- 55
				SetBlipAsShortRange(HUD.Blip, true)
	
				SetBlipRotation(HUD.Blip, math.ceil(heading))
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Twoja pozycja")
				EndTextCommandSetBlipName(HUD.Blip)
				HUD.NeedsRebuild = true
				Ped.Vehicle = vehicle
			end

			HUD.VehicleClass = nil
			if not WRLoaded  then
				HUD.VehicleClass = classFunc(Ped.Vehicle)
				HUD.VehicleStopped = stopFunc(Ped.Vehicle)
				HUD.VehicleEngine = engineFunc(Ped.Vehicle)
				HUD.VehicleGear = gearboxFunc(Ped.Vehicle)
			end
		elseif Ped.Vehicle then
			RemoveBlip(GetNorthRadarBlip())
			SetBlipAlpha(GetNorthRadarBlip(), 0)
			SetBlipSprite(HUD.Blip, 1)
			SetBlipScale(HUD.Blip, 1.0)
			SetBlipCategory(HUD.Blip, 1)
			SetBlipPriority(HUD.Blip, 10)
			SetBlipColour(HUD.Blip, 0)
			SetBlipAsShortRange(HUD.Blip, true)

			SetBlipRotation(HUD.Blip, math.ceil(heading))
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Twoja pozycja")
			EndTextCommandSetBlipName(HUD.Blip)
			HUD.NeedsRebuild = false
			HUD.VehicleClass = nil
			Ped.Vehicle = false
		end

		
      
		if WRPLoaded then
			HUD.PhoneVisible = exports['gcphone']:getMenuIsOpen()
			Ped.Clock = string.format("%02d:%02d", hoursFunc(), minutesFunc())
		else
			Ped.Clock = string.format("%02d:%02d", hoursFunc(), minutesFunc())
		end

		local zone = zoneFunc(coords.x, coords.y, coords.z)
		Ped.Zone = Config.Zones[zone:upper()] or zone:upper()

		Ped.Street = GetStreetsCustom(coords)
		nuiProxy({
			type = 'update',
			anchor = MM,
			data = Ped
		})
	end
end)




AddEventHandler('HUD:Update', function(data)
	nuiProxy({
		type = 'update',
		data = data
	})
end)

RegisterNetEvent("HUD:Axon")
AddEventHandler('HUD:Axon', function(data)
	nuiProxy({
		type = 'axon',
		data = data
	})
end)

AddEventHandler('HUD:Inventory', function(data)
	nuiProxy({
		type = 'inventory',
		data = data
	})
end)

AddEventHandler('HUD:Description', function(label, description)
	nuiProxy({
		type = 'description',
		label = label,
		description = description
	})
end)

AddEventHandler('HUD:Wheel', function(data, selection)
	if data then
		HUD.Wheel = data
	end

	if not HUD.Wheel then
		return
	end

	nuiProxy({
		type = 'wheel',
		data = HUD.Wheel
	})
	if not selection then
		SetCursorLocation(0.5, 0.5)
		--SetNuiFocus(true, true)
		SetNuiFocusKeepInput(true)
	else
		nuiProxy({
			type = 'wheel',
			data = HUD.Wheel,
			selection = selection
		})
	end
end)

AddEventHandler('HUD:LoadWheel', function(data)
	HUD.Wheel = data
end)

AddEventHandler('HUD:Hide', function(hide, ticket)
	HUD.Hide = hide
	if hide and ticket then
		nuiProxy({
			ticket = true
		})
	end
end)

AddEventHandler('HUD:HideUI', function(hide, ticket)
	local data = {
		type = (hide and 'hide' or 'show')
	}
	if hide and ticket then
		data.ticket = true
	end

	nuiProxy(data)
end)

RegisterNUICallback('ready', function(data, cb)
	HUD.Ready = true
	cb('ok')
end)

RegisterNUICallback('focus', function(data, cb)
	SetNuiFocus(data.status, data.status)
	if data.sound then
		PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
	end

	cb('ok')
end)

RegisterNUICallback('shortcut', function(data, cb)
    SetNuiFocus(false, false)
	if type(data.value) == 'table' then
		TriggerEvent(table.unpack(data.value))
	else
		TriggerEvent(data.value)
	end

	PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    cb('ok')
end)

RegisterCommand('hud', function(...)
	nuiProxy({
		type = 'options'
	})
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
	BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV')
	EndScaleformMovieMethod() 
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

