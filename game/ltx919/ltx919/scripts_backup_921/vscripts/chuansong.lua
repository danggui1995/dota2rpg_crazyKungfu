function FB1_QuitArea( trigger )
	local hero = trigger.activator
	local hNpc = Entities:FindByName(nil, "ent_fb1_npc")
	local pos_out = hNpc:GetAbsOrigin()
	local id = hero:GetPlayerID()
	FindClearSpaceForUnit(hero, pos_out, false) 
	hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	hero:Stop()
	PlayerResource:SetCameraTarget(id, hero)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera"),
	    function (  ) PlayerResource:SetCameraTarget(id, nil) end,0.5)
end

function FB4_QuitArea( trigger )
	local hero = trigger.activator
	local hNpc = Entities:FindByName(nil, "ent_fb4_npc")
	local pos_out = hNpc:GetAbsOrigin()
	local id = hero:GetPlayerID()
	FindClearSpaceForUnit(hero, pos_out, false) 
	hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	hero:Stop()
	PlayerResource:SetCameraTarget(id, hero)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera"),
	    function (  ) PlayerResource:SetCameraTarget(id, nil) end,0.5)
end

function FB3_QuitArea( trigger )
	local hero = trigger.activator
	local hNpc = Entities:FindByName(nil, "ent_fb3_npc")
	local pos_out = hNpc:GetAbsOrigin()
	local id = hero:GetPlayerID()
	FindClearSpaceForUnit(hero, pos_out, false) 
	hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	hero:Stop()
	PlayerResource:SetCameraTarget(id, hero)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera"),
	    function (  ) PlayerResource:SetCameraTarget(id, nil) end,0.5)
end

function FB2_QuitArea( trigger )
	local hero = trigger.activator
	local hNpc = Entities:FindByName(nil, "ent_fb2_npc")
	local pos_out = hNpc:GetAbsOrigin()
	local id = hero:GetPlayerID()
	FindClearSpaceForUnit(hero, pos_out, false) 
	hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	hero:Stop()
	PlayerResource:SetCameraTarget(id, hero)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera"),
	    function (  ) PlayerResource:SetCameraTarget(id, nil) end,0.5)
end

function OnEnterShop( trigger )
	local hero = trigger.activator
	local hPlayer = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"change_state_shop",{opt = 1})
end

function OnQuitShop( trigger )
	local hero = trigger.activator
	local hPlayer = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"change_state_shop",{opt = 2})
end

function ShowJX( trigger )
	local hero = trigger.activator
	local hPlayer = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__show_door",{opt=2})
end

function HideJX( trigger )
	local hero = trigger.activator
	local hPlayer = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__hide_door",{opt=2})
end

function OnEnterDoor(trigger)
	local hero = trigger.activator
	local hPlayer = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__show_door",{})
end

function OnQuitDoor(trigger)
	local hero = trigger.activator
	local hPlayer = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__hide_door",{})
end

local function stringSplit(str, sep)
    if type(str) ~= 'string' or type(sep) ~= 'string' then
        return nil
    end
    local res_ary = {}
    local cur = nil
    for i = 1, #str do
        local ch = string.byte(str, i)
        local hit = false
        for j = 1, #sep do
            if ch == string.byte(sep, j) then
                hit = true
                break
            end
        end
        if hit then
            if cur then
                table.insert(res_ary, cur)
            end
            cur = nil
        elseif cur then
            cur = cur .. string.char(ch)
        else
            cur = string.char(ch)
        end
    end
    if cur then
        table.insert(res_ary, cur)
    end
    return res_ary
end

function OnAcceptTask(...)
	local keysss,data=...
	local id = data['id']
	local hPlayer = PlayerResource:GetPlayer(id)
	local task_type = data['task_type']
	local hero = PlayerResource:GetSelectedHeroEntity(id)
	if task_type == 1 then
		local __state = GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["state"]
		if bit.band(__state,2^tonumber(id))==0 then
			GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["state"] = bit.bor(__state,2^tonumber(id))
			if GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"] == 1 then
				mytask_system:OnUICreate(id,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
				mytask_system:OnUIRefresh(id,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
			elseif GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"] == 2 then
				mytask_system:OnUICreate(id,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
			elseif GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"] == 3 then
				mytask_system:OnUICreate(id,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
				mytask_system:OnUIRefresh(id,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
			elseif GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"] == 4 then
				mytask_system:OnUICreate(id,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
			end
			local __entName = GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["entName"]
			local __entName_a = stringSplit(__entName,',')
			for i=1,#__entName_a do
				local __ent = Entities:FindByName(nil,__entName_a[i])
				if __ent then
					local __pos = __ent:GetAbsOrigin()
					CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ping_at_minimap",{pos=__pos})
				end
			end
			mytask_system:OnAddInitItem(hero,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
			mytask_system:AddParticle(hero)
			mytask_system:OnEmitMySound(GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],1)
		else
			SendErrorMsg(hPlayer,1)
			mytask_system:OnEmitMySound(GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],2)
		end
	else
		local temp_index = data['task_index']
		local __state = GameRules.othersT["other"..temp_index]["state"]
		if bit.band(__state,2^tonumber(id))==0 then
			GameRules.othersT["other"..temp_index]["state"] = bit.bor(__state,2^tonumber(id))
			print(GameRules.othersT["other"..temp_index]["state"].."accept state")
			if GameRules.othersT["other"..temp_index]["type"] == 1 then
				mytask_system:OnUICreate(id,GameRules.othersT["other"..temp_index])
				mytask_system:OnUIRefresh(id,GameRules.othersT["other"..temp_index])
			elseif GameRules.othersT["other"..temp_index]["type"] == 2 then
				mytask_system:OnUICreate(id,GameRules.othersT["other"..temp_index])
			elseif GameRules.othersT["other"..temp_index]["type"] == 3 then
				mytask_system:OnUICreate(id,GameRules.othersT["other"..temp_index])
				mytask_system:OnUIRefresh(id,GameRules.othersT["other"..temp_index])
			elseif GameRules.othersT["other"..temp_index]["type"] == 4 then
				mytask_system:OnUICreate(id,GameRules.othersT["other"..temp_index])
			end
			local __entName = GameRules.othersT["other"..temp_index]["entName"]
			local __entName_a = stringSplit(__entName,',')
			for i=1,#__entName_a do
				local __ent = Entities:FindByName(nil,__entName_a[i])
				if __ent then
					local __pos = __ent:GetAbsOrigin()
					CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ping_at_minimap",{pos=__pos})
				end
			end
			mytask_system:OnAddInitItem(hero,GameRules.othersT["other"..temp_index])
			mytask_system:AddParticle(hero)
			mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],1)
		else
			SendErrorMsg(hPlayer,1)
			mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],2)
		end
	end
end

-- function OnPipeiItem( v1,id )
-- 	local aimItem = v1["aimItem"]
-- 	local specialItem = v1["specialItem"]
-- 	local aimItem_t = stringSplit(aimItem,',')
-- 	local js1 = 0 
-- 	local js2 = 0
-- 	if specialItem then
-- 		local specialItem_t = stringSplit(specialItem,',')
-- 		for k,v in pairs(GameRules.Item_Duanzao[id+1]) do
-- 			for i=1,#specialItem_t do
-- 				if specialItem_t[i]==EntIndexToHScript(v):GetAbilityName() then
-- 					js1 = js1 + 1 
-- 					break
-- 				end
-- 			end
-- 		end
-- 		if js1 >= #specialItem_t then
-- 			return 1,js1
-- 		end
-- 	end
-- 	for k,v in pairs(GameRules.Item_Duanzao[id+1]) do
-- 		for i=1,#aimItem_t do
-- 			if aimItem_t[i]==EntIndexToHScript(v):GetAbilityName() then
-- 				js2 = js2 + 1 
-- 				break
-- 			end
-- 		end
-- 	end
-- 	if js2 >= #aimItem_t then
-- 		return 2,js2
-- 	end
-- 	return 3,0
-- end

function RemoveItemByTask(hero,itemTable)
	for i=0,5 do
		local _item = hero:GetItemInSlot(i)
		if _item then
			for k,v in pairs(itemTable) do
				if _item:GetAbilityName()==v then
					hero:RemoveItem(_item)
				end
			end
		end
	end
end

function OnPipeiItem( v1,hero )
	local aimItem = v1["aimItem"]
	local specialItem = v1["specialItem"]
	local aimItem_t = stringSplit(aimItem,',')
	local js1 = 0 
	local js2 = 0
	local itemTable = {}
	if specialItem then

		local specialItem_t = stringSplit(specialItem,',')
		for j=0,5 do
			local _item = hero:GetItemInSlot(j)
			if _item then
				for i=1,#specialItem_t do
					local _itemName = _item:GetAbilityName()
					if specialItem_t[i]==_itemName then
						table.insert(itemTable,_itemName)
						js1 = js1 + 1 
						break
					end
				end
			end
		end
		if js1 >= #specialItem_t then
			RemoveItemByTask(hero,itemTable)
			return 1,js1
		end
	end
	for j=0,5 do
		local _item = hero:GetItemInSlot(j)
		if _item then
			for i=1,#aimItem_t do
				local _itemName = _item:GetAbilityName()
				if aimItem_t[i]==_itemName then
					table.insert(itemTable,_itemName)
					js2 = js2 + 1 
					break
				end
			end
		end
	end
	if js2 >= #aimItem_t then
		RemoveItemByTask(hero,itemTable)
		return 2,js2
	end
	return 3,0
end




function OnSubmitTask( ... )
	local keysss,data = ...
	local id = data['id']
	local hPlayer = PlayerResource:GetPlayer(id)
	local task_type = data['task_type']
	local hero = PlayerResource:GetSelectedHeroEntity(id)
	if task_type == 1 then
		local __state = GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["state"]
		if bit.band(__state,2^tonumber(id))~=0 then
			if GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"] == 1 then
				local totalNum = GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["aimNums"]
				if (GameRules.curNums["primarys"][id+1]>=GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["aimNums"]) then
					GameRules.curNums["primarys"][id+1] = 0
					--[[award]]
					mytask_system:OnAwardPlayer(hero,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
					mytask_system:OnUIRemove(id,GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])],3)
					GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					mytask_system:PrimaryIndexIncrease(id)
				else
					SendErrorMsg(hPlayer,2)
					mytask_system:OnEmitMySound(GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],2)
				end
			elseif GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"] == 2 then
				local __com,__mult = OnPipeiItem(GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],hero)
				if __com~=3 then
					mytask_system:OnAwardPlayer(hero,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],__com,__mult)
					mytask_system:OnUIRemove(id,GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])],3)
					GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					mytask_system:PrimaryIndexIncrease(id)
				else
					SendErrorMsg(hPlayer,4)
					mytask_system:OnEmitMySound(GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],2)
				end
				--CustomGameEventManager:Send_ServerToPlayer(hPlayer,"removeitem__backpack",{})
			elseif GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"] == 3 then
				if getAllOne(GameRules.curNums["primarys"][id+1]) then
					GameRules.curNums["primarys"][id+1] = 0
					--[[award]]
					mytask_system:OnAwardPlayer(hero,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
					mytask_system:OnUIRemove(id,GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])],3)
					GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					mytask_system:PrimaryIndexIncrease(id)
				else
					SendErrorMsg(hPlayer,2)
					mytask_system:OnEmitMySound(GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],2)
				end
			elseif GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"] == 4 then
				local __arrive = primarysT["primary"..GameRules.primary_task_index[id+1]]["arrive"]
				if bit.band(__state,2^id)~=0 then
					if bit.band(__arrive,2^id)~=0 then
						mytask_system:OnAwardPlayer(hero,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]])
						mytask_system:OnUIRemove(id,GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])])
						mytask_system:AddParticle(hero)
						mytask_system:OnEmitMySound(GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])],3)
						GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
						mytask_system:PrimaryIndexIncrease(id)
						GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["arrive"] = bit.band(__arrive,bit.bnot(2^tonumber(id)))
				    else
				    	SendErrorMsg(hPlayer,2)
						mytask_system:OnEmitMySound(primarysT["primary"..GameRules.primary_task_index[id+1]],2)
				    end
				else
					SendErrorMsg(hPlayer,3)
					mytask_system:OnEmitMySound(primarysT["primary"..GameRules.primary_task_index[id+1]],2)
			    end
			end
		else
			SendErrorMsg(hPlayer,3)
			mytask_system:OnEmitMySound(GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],2)
		end
	else
		local temp_index = data['task_index']
		local __state = GameRules.othersT["other"..temp_index]["state"]
		if bit.band(__state,2^tonumber(id))~=0 then
			if GameRules.othersT["other"..temp_index]["type"] == 1 then   --kill units
				if (GameRules.curNums["other"..temp_index][id+1]==GameRules.othersT["other"..temp_index]["aimNums"]) then
					GameRules.othersT["other"..temp_index]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					GameRules.curNums["other"..temp_index][id+1] = 0
					mytask_system:OnAwardPlayer(hero,GameRules.othersT["other"..temp_index])
					mytask_system:OnUIRemove(id,GameRules.othersT["other"..temp_index])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],3)
				else
					SendErrorMsg(hPlayer,2)
					mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],2)
				end
			elseif GameRules.othersT["other"..temp_index]["type"] == 2 then
				local __com,__mult = OnPipeiItem(GameRules.othersT["other"..temp_index],hero)
				if __com~=3 then
					GameRules.othersT["other"..temp_index]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					--print("state:"..GameRules.othersT["other"..temp_index]["state"])
					--GameRules.curNums["other"..temp_index][id+1] = 0
					mytask_system:OnAwardPlayer(hero,GameRules.othersT["other"..temp_index],__com,__mult)
					mytask_system:OnUIRemove(id,GameRules.othersT["other"..temp_index])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],3)
					
				else
					SendErrorMsg(hPlayer,4)
					--mytask_system:OnEmitMySound(GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],2)
				end
				--CustomGameEventManager:Send_ServerToPlayer(hPlayer,"removeitem__backpack",{})
			elseif GameRules.othersT["other"..temp_index]["type"] == 3 then
				if getAllOne(GameRules.curNums["other"..temp_index][id+1]) then
					GameRules.othersT["other"..temp_index]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					GameRules.curNums["other"..temp_index][id+1] = 0
					mytask_system:OnAwardPlayer(hero,GameRules.othersT["other"..temp_index])
					mytask_system:OnUIRemove(id,GameRules.othersT["other"..temp_index])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],3)
				else
					SendErrorMsg(hPlayer,2)
					mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],2)
				end
			elseif GameRules.othersT["other"..temp_index]["type"] == 4 then
				local __arrive = GameRules.othersT["other"..temp_index]["arrive"]
				if bit.band(__state,2^id)~=0 then
					if bit.band(__arrive,2^id)~=0 then
						GameRules.othersT["other"..temp_index]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
				        GameRules.othersT["other"..temp_index]["arrive"] = bit.band(__arrive,bit.bnot(2^tonumber(id)))
				        mytask_system:OnUIRefresh(id,GameRules.othersT["other"..temp_index])
				        mytask_system:OnAwardPlayer(hero,GameRules.othersT["other"..temp_index])
						mytask_system:OnUIRemove(id,GameRules.othersT["other"..temp_index])
						mytask_system:AddParticle(hero)
						mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],3)
				    else
				    	SendErrorMsg(hPlayer,2)
						mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],2)
				    end
				else
					SendErrorMsg(hPlayer,3)
					mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],2)
			    end
			end
		else
			SendErrorMsg(hPlayer,3)
			mytask_system:OnEmitMySound(GameRules.othersT["other"..temp_index],2)
		end
	end
end

function PrintTable (t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= 'table' then return end
	
	done = done or {}
	done[t] = true
	indent = indent or 0
	
	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end
	
	table.sort(l)
	for k, v in ipairs(l) do
		local value = t[v]
		
		if type(value) == "table" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..":")
			PrintTable (value, indent + 1, done)
		elseif type(value) == "userdata" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
			PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		else
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		end
	end
end
--type 1: kill units to numbers
--type 2: send a message
--type 3: find some thing
--type 4: fix an array
function AAAAAAA(trigger)
	local hero = trigger.activator
	local caller = trigger.caller
	if hero:GetTeam()==DOTA_TEAM_BADGUYS then
		return
	end
	local playerID = hero:GetPlayerOwnerID()
	local hPlayer = PlayerResource:GetPlayer(playerID)

	--print(self.primary_task_index[player+1])
	if caller:GetName() == "t_primarytask" then
		if not GameRules.primarysT["primary"..(GameRules.primary_task_index[playerID+1])] then
			return
		end
		local __type = GameRules.primarysT["primary"..GameRules.primary_task_index[playerID+1]]["type"]
		local __state = GameRules.primarysT["primary"..GameRules.primary_task_index[playerID+1]]["state"]
		--print(__state)
		mytask_system:OnUIShow(hPlayer,GameRules.primarysT["primary"..(GameRules.primary_task_index[playerID+1])])
		-- if __type== 2 and  bit.band(__state,2^tonumber(playerID))~=0 then
		-- 	--CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__item_show",{})
		-- 	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"tijiaowupin__show",GameRules.primarysT["primary"..GameRules.primary_task_index[playerID+1]])
		-- 	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"removeitem__backpack",GameRules.Item_Duanzao[playerID+1])
		-- else
		-- 	--PrintTable(mytask_system.primarysT["primary"..(GameRules.primary_task_index[playerID+1])])
		-- 	--print("primary_task_index: "..GameRules.primary_task_index[playerID+1])
		-- 	mytask_system:OnUIShow(hPlayer,GameRules.primarysT["primary"..(GameRules.primary_task_index[playerID+1])])
		-- end
	else
		local temp_index = ""
		local npcName = caller:GetName()
		if string.sub(npcName,string.len(npcName)-1,string.len(npcName)-1)=="r" then
			temp_index = string.sub(npcName,string.len(npcName),string.len(npcName))
		else
			temp_index = string.sub(npcName,string.len(npcName)-1,string.len(npcName))
		end
		local __state = GameRules.othersT["other"..temp_index]["state"]
		local __type = GameRules.othersT["other"..temp_index]["type"]
		mytask_system:OnUIShow(hPlayer,GameRules.othersT["other"..temp_index])
		--print(GameRules.othersT["other"..temp_index]["state"])
		-- if __type ==2 and bit.band(__state,2^tonumber(playerID))~=0 then
		-- 	--CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__item_show",{})
		-- 	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"tijiaowupin__show",GameRules.othersT["other"..temp_index])
		-- else
		-- 	mytask_system:OnUIShow(hPlayer,GameRules.othersT["other"..temp_index])
		-- end
	end
end

function BBBBBBB( trigger )
	local hero = trigger.activator
	local playerID = hero:GetPlayerOwnerID()
	local hPlayer = PlayerResource:GetPlayer(playerID)
	mytask_system:OnUIHide(hPlayer)
	--CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__item_hide",{})
end

function ShowForge( trigger )
	local hero = trigger.activator
	local playerID = hero:GetPlayerOwnerID()
	local hPlayer = PlayerResource:GetPlayer(playerID)
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__show__forge",{})
end

function HideForge( trigger )
	local hero = trigger.activator
	local playerID = hero:GetPlayerOwnerID()
	local hPlayer = PlayerResource:GetPlayer(playerID)
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__show__forge",{})
end