local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local inMenu = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('kibra-emlakv2:client:OpenStash', function()
	TriggerServerEvent("inventory:server:OpenInventory", "stash", "EmlakDepo")
	TriggerEvent("inventory:client:SetCurrentStash", "EmlakDepo")
end)

Citizen.CreateThread(function()
	while true do
		local Sleep = 2000
		local PlayerPed = PlayerPedId()
		local PlayerCoord = GetEntityCoords(PlayerPed)
		local EmlakManagamentDist = #(PlayerCoord - KIBRA.EmlakCoords)
		local EmlakStash = #(PlayerCoord - KIBRA.EmlakDepo)
		
		if EmlakManagamentDist <= 1.5 then
			Sleep = 5
			if PlayerData.job and PlayerData.job.name == KIBRA.EmlakJob then
				QBCore.Functions.DrawText3D(KIBRA.EmlakCoords.x, KIBRA.EmlakCoords.y, KIBRA.EmlakCoords.z, "~g~[E] -~w~ Emlak Yönetim")
				if IsControlJustReleased(0,38) then
					TriggerServerEvent('kibra-emlakv2:server:OpenEmlakManagamentMenu')
				end
			end
		end
		
		if EmlakStash <= 1 then
			Sleep = 5
			QBCore.Functions.DrawText3D(KIBRA.EmlakDepo.x, KIBRA.EmlakDepo.y, KIBRA.EmlakDepo.z, "~g~[E] -~w~ Emlak Depo")
			if IsControlJustReleased(0, 38) then
				KasaStashMenu()
			end
		end

		Citizen.Wait(Sleep)
	end
end)

RegisterNetEvent('kibra-emlakv2:client:OpenEmlakMenu', function(Data)
	inMenu = true 
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = 'EmlakYonetimPanel',
		ChangeNamePrice = KIBRA.EmlakChangeNamePrice,
		EmlakName = Data.EmlakName,
		EmlakPara = Data.EmlakPara
	})
end)

RegisterNUICallback('OpenSalesHouses', function()
	local EvTablo = exports['kibra-houses']:EvTablo()
	local elements = {}
	for i = 1, #EvTablo, 1 do
		table.insert(elements, {label = i..' Numaralı Daire - '..EvTablo[i].HouseAddress..' - $'..EvTablo[i].HousePrice, value = i})
		QBCore.UI.Menu.CloseAll()
		QBCore.UI.Menu.Open('default', GetCurrentResourceName(), 'KibraDevWorks', {
			title    = "Emlak Satış Daireleri",
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local Player, Distance = QBCore.Functions.GetClosestPlayer()
			if Player ~= -1 and Distance <= 2.0 then
				TriggerServerEvent('kibra-emlakv2:server:BuyHouse', i, GetPlayerServerId(Player), EvTablo[i].HousePrice)
			else
				QBCore.Functions.Notify('Yakında Kimse Yok!', 'error')
			end
		end, function(data, menu)
			menu.close()
		end)
	end
end)

RegisterNUICallback('BlackMoneyWash', function(BlackMoney)
	if KIBRA.BlackMoneyWash then
		TriggerServerEvent('kibra-emlakv2:server:BlackMoneyWash', tonumber(BlackMoney.KacPara))
	else
		QBCore.Functions.Notify('Bu özellik kullanılabilir değil!')
	end
end)

RegisterNetEvent('kibra-emlakv2:client:CheckTargetMoney', function(HouseId, Price, HousePassword, PlySrc)
	local elements = {
		{label = 'Evet', value = "yes"},
		{label = "Hayır", value = "no"}
	}
	QBCore.UI.Menu.CloseAll()
	QBCore.UI.Menu.Open('default', GetCurrentResourceName(), 'KibraDevWorks', {
		title    = HouseId..' numaralı daireyi $'..Price..' karşılığında satın almayı onaylıyor musunuz ?',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == "yes" then
			TriggerServerEvent('kibra-emlakv2:server:HouseBuy', GetPlayerServerId(PlayerId()), HouseId, Price, HousePassword, PlySrc)
		elseif data.current.value == "no" then
			QBCore.UI.Menu.CloseAll()
			QBCore.Functions.Notify(HouseId..' numaralı evi satın almaktan vazgeçtiniz.')
		end
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNUICallback('EmlakPasswordChange', function(Data)
	TriggerServerEvent('kibra-emlakv2:server:ChangePassword', tonumber(Data.Password))
end)

RegisterNUICallback('ParaYatir', function(ParaData)
	TriggerServerEvent('kibra-emlakv2:server:EmlakParaYatir', ParaData.KacPara)
end)

RegisterNUICallback('ParaCek', function(ParaData)
	TriggerServerEvent('kibra-emlakv2:server:EmlakParaCek', ParaData.KacPara)
end)

RegisterNUICallback('ChangeNameEmlak', function(EmlakName)
	TriggerServerEvent('kibra-emlakv2:server:EmlakNameChange', EmlakName.EmlakName)
end)

function KasaStashMenu() 
	inMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({type = 'EmlakPasswordMenu'})
end

function EmlakManagamentMenu() 
	inMenu = true 
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = 'EmlakYonetimPanel',
		ChangeNamePrice = KIBRA.EmlakChangeNamePrice
	})
end

RegisterNUICallback('PasswordToStash', function(EmlakPassword)
	TriggerServerEvent('kibra-emlakv2:server:CheckCasePassword', tonumber(EmlakPassword.Password))
end)

RegisterNUICallback('ClosePasswordMenu', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'ClosePasswMenu'})
    Citizen.Wait(500)
    inMenu = false
end)

RegisterNUICallback('CloseEmlakMenu', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'CloseEmlakMenu'})
    Citizen.Wait(500)
    inMenu = false
end)



Citizen.CreateThread(function()
    if KIBRA.EmlakBlip.BlipShow then
		local blip = AddBlipForCoord(KIBRA.EmlakBlip.BlipCoord.x, KIBRA.EmlakBlip.BlipCoord.y, KIBRA.EmlakBlip.BlipCoord.z)
		SetBlipSprite(blip, KIBRA.EmlakBlip.BlipId)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, KIBRA.EmlakBlip.BlipSize)
		SetBlipColour(blip, KIBRA.EmlakBlip.BlipColor)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Emlak Ofisi")
		EndTextCommandSetBlipName(blip)
    end
end)