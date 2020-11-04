ESX = nil


local pesu = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_pesula:hasEnteredMarker', function ()
	ESX.UI.Menu.CloseAll()
	
	CurrentAction     = 'start_job'
	CurrentActionMsg  = ('Paina ~INPUT_CONTEXT~ pestäksesi rahaa')
	CurrentActionData = {}

end)

AddEventHandler('esx_pesula:hasExitedMarker', function ()
  CurrentAction = nil
  TriggerServerEvent('esx_pesula:stopPesu')
  pesu = false
end)

Citizen.CreateThread(function()
  while true do

    Citizen.Wait(50)

	if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	  if IsControlPressed(0, 38) then
		
        if CurrentAction == 'start_job' then
			pesu = true
			TriggerServerEvent('esx_pesula:startPesu')
			SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, 1)
			--TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true);
        end
		
		CurrentAction = nil
      end
    end
	
	if pesu then
		ESX.ShowHelpNotification("Paina ~INPUT_VEH_DUCK~ keskeyttääksesi pesun")
		if IsControlPressed(0, 73) then
			ESX.ShowNotification("Rahanpesu keskeytetty!")
			TriggerServerEvent('esx_pesula:stopPesu')
			pesu = false
		end
	end
	
  end
end)

RegisterNetEvent('esx_pesula:tarkistaanimaatio')
AddEventHandler('esx_pesula:tarkistaanimaatio', function()
	if IsPedUsingAnyScenario(GetPlayerPed(-1)) == false then
		TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true);
	end	
end)

RegisterNetEvent('esx_pesula:lopetaanimaatio')
AddEventHandler('esx_pesula:lopetaanimaatio', function()
	ClearPedTasks(GetPlayerPed(-1))
	pesu = false
	ESX.ShowNotification("~r~Sinulla ei ole tarpeeksi likaista rahaa pestäväksi!")
end)

Citizen.CreateThread(function ()
  while true do
    Wait(111)

    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    if(GetDistanceBetweenCoords(coords, -1064.465, -1663.461, 4.559, true) < 2.0) then --PESULAN COORDINAATIT!!!!!!!!!!!!!!!
      isInMarker  = true
      currentZone = "pesula"
    end


    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_pesula:hasEnteredMarker')
    end

    if not isInMarker and HasAlreadyEnteredMarker then
	  TriggerEvent('esx_pesula:hasExitedMarker')
      HasAlreadyEnteredMarker = false
    end
  end
end)