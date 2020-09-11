local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local r,g,b,a = 200,45,45,255
local type = 23
local zdif = 1.0 -- 1.2
local voice = {default = 5.0, shout = 12.0, whisper = 1.0, current = 0}
local locale = {
voice = '~r~Voz:~s~ ',
changed = 'Voz alterada para ',
normal = 'Normal',
shout = 'Gritar',
whisper = 'Sussurrar',
}

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(voice.default)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        if IsControlJustPressed(0, Keys['H']) and IsControlPressed(0, Keys['LEFTSHIFT']) then
            voice.current = (voice.current + 1) % 3
            if voice.current == 0 then
                NetworkSetTalkerProximity(voice.default)
				exports['mack_notify']:DoHudText('inform', locale.changed..locale.normal)
            elseif voice.current == 1 then
                NetworkSetTalkerProximity(voice.shout)
				exports['mack_notify']:DoHudText('inform', locale.changed..locale.shout)
            elseif voice.current == 2 then
                NetworkSetTalkerProximity(voice.whisper)
				exports['mack_notify']:DoHudText('inform', locale.changed..locale.whisper)
            end
        end
        if IsControlPressed(0, Keys['H']) and IsControlPressed(0, Keys['LEFTSHIFT']) then
            if voice.current == 0 then
                voiceS = voice.default
            elseif voice.current == 1 then
                voiceS = voice.shout
            elseif voice.current == 2 then
                voiceS = voice.whisper
            end
			if voiceS == 5.0 then
				voiceT = locale.normal
			elseif voiceS == 12.0 then
				voiceT = locale.shout
			elseif voiceS == 1.0 then
				voiceT = locale.whisper
			end
			Marker(type, coords.x, coords.y, coords.z, voiceS * 2.0)
			DrawText3Ds(coords.x, coords.y, coords.z, locale.voice..voiceT)
		elseif IsControlPressed(0, Keys['H']) then
			if voice.current == 0 then
                voiceS = voice.default
            elseif voice.current == 1 then
                voiceS = voice.shout
            elseif voice.current == 2 then
                voiceS = voice.whisper
            end
			if voiceS == 5.0 then
				voiceT = locale.normal
			elseif voiceS == 12.0 then
				voiceT = locale.shout
			elseif voiceS == 1.0 then
				voiceT = locale.whisper
			end
			Marker(type, coords.x, coords.y, coords.z, voiceS * 2.0)
			DrawText3Ds(coords.x, coords.y, coords.z, locale.voice..voiceT)
        end
    end
end)

function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  SetTextScale(0.4, 0.4)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 215)
  SetTextOutline()
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 270
  DrawRect(_x,_y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

function Marker(type, x, y, z, voiceS)
    DrawMarker(type, x, y, z - zdif, 0.0, 0.0, 0.0, 0, 0.0, 0.0, voiceS, voiceS, 1.0, r, g, b, a, false, true, 2, false, false, false, false)
end