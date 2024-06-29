local gapi = require(script.gapi)
local module = require(script.main)
local config = require(script.config)
local emojis = require(config)

local print = function(...)
	print("[Overhead] ".. ...)
end

game.Players.PlayerAdded:Connect(function (plr)
	local pinfo = module.GetPlrGroups(plr)
	
	local infos = {
		['Ranks'] = {},
		['Gamepasses'] = {},
		['Divs'] = {},
		['TeamColor'] = {},
		['Mobile'] = nil,
	}
	
	local kran = nil
	local gp = pinfo.grupos
	local div = pinfo.divs
	local gamepass = pinfo.gamepass
	
	if #gp > 0 and #div >0 then
		print('plr', plr.Name, 'groups:', table.concat(gp, ', '))
		print('plr', plr.Name, 'divs:', table.concat(div, ', '))
	end
	
	for i, v in next, gp do
		local info = gapi:GetGroupInfoAsync(v)
		local rank = gapi:GetRankInGroup(plr, v)
		local roles = info.Roles
		for i, k in next, roles do
			if k.Rank == rank then
				kran = k
				table.insert(infos.Ranks, 1, kran.Name)
			end
		end
	end
	
	for i, v in next, div do
		table.insert(infos.Divs, 1, v)
	end
	
	for i, v in next, gamepass do
		table.insert(infos.Gamepasses, 1, v)
	end
	
	local tc = module.GetTeamColor(plr)
	table.insert(infos.TeamColor, 1, tc)
	
	if not plr:IsDescendantOf(game.Players) then warn('plr n é parent de game.Players') return end
	
	local uis = game:GetService('UserInputService')
	local UIS = game:GetService('UserInputService')

	if UIS.TouchEnabled and not UIS.KeyboardEnabled then
		infos.Mobile = true
	else if UIS.KeyboardEnabled and UIS.MouseEnabled then
		infos.Mobile = false
			if script.celulares:FindFirstChild(plr.Name) then -- previne entrar pelo celular e dps entrar pelo pc
				script.Mobiles[plr.Name]:Destroy()
			end
	end
	end
	
	repeat
		wait(1)
	until plr.Character:FindFirstChild('Head')
	module.setar(plr, infos)
	
	plr.CharacterAdded:Connect(function()
		module.setar(plr, infos)
	end)
	
end)