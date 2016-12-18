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
		local task_name = "primary"..GameRules.primary_task_index[id+1]
		local __state = GameRules.primarysT[task_name]["state"]
		if bit.band(__state,2^tonumber(id))==0 then
			GameRules.primarysT[task_name]["state"] = bit.bor(__state,2^tonumber(id))
			if GameRules.primarysT[task_name]["type"] == 2 then
				mytask_system:OnUICreate(id,GameRules.primarysT[task_name])
			elseif GameRules.primarysT[task_name]["type"] == 4 then
				mytask_system:OnUICreate(id,GameRules.primarysT[task_name])
			else
				mytask_system:OnUICreate(id,GameRules.primarysT[task_name])
				mytask_system:OnUIRefresh(id,GameRules.primarysT[task_name],GameRules.curNums1[task_name])
			end
			local __entName = GameRules.primarysT[task_name]["entName"]
			local __entName_a = stringSplit(__entName,',')
			for i=1,#__entName_a do
				local __ent = Entities:FindByName(nil,__entName_a[i])
				if __ent then
					local __pos = __ent:GetAbsOrigin()
					CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ping_at_minimap",{pos=__pos})
				end
			end
			mytask_system:OnAddInitItem(hero,GameRules.primarysT[task_name])
			mytask_system:AddParticle(hero)
			mytask_system:OnEmitMySound(GameRules.primarysT[task_name],1)
		else
			SendErrorMsg(hPlayer,1)
			mytask_system:OnEmitMySound(GameRules.primarysT[task_name],2)
		end
	else
		local temp_index = data['task_index']
		local task_name = "other"..temp_index
		local __state = GameRules.othersT[task_name]["state"]
		if bit.band(__state,2^tonumber(id))==0 then
			GameRules.othersT[task_name]["state"] = bit.bor(__state,2^tonumber(id))
			if GameRules.othersT[task_name]["type"] == 2 then
				mytask_system:OnUICreate(id,GameRules.othersT[task_name])
			elseif GameRules.othersT[task_name]["type"] == 4 then
				mytask_system:OnUICreate(id,GameRules.othersT[task_name])
			else
				mytask_system:OnUICreate(id,GameRules.othersT[task_name])
				mytask_system:OnUIRefresh(id,GameRules.othersT[task_name],GameRules.curNums2[task_name])
			end
			local __entName = GameRules.othersT[task_name]["entName"]
			local __entName_a = stringSplit(__entName,',')
			for i=1,#__entName_a do
				local __ent = Entities:FindByName(nil,__entName_a[i])
				if __ent then
					local __pos = __ent:GetAbsOrigin()
					CustomGameEventManager:Send_ServerToPlayer(hPlayer,"ping_at_minimap",{pos=__pos})
				end
			end
			for k,v in pairs(GameRules.curNums2[task_name]) do
				GameRules.curNums2[task_name][k][id+1] = 0
			end
			mytask_system:OnAddInitItem(hero,GameRules.othersT[task_name])
			mytask_system:AddParticle(hero)
			mytask_system:OnEmitMySound(GameRules.othersT[task_name],1)
		else
			SendErrorMsg(hPlayer,1)
			mytask_system:OnEmitMySound(GameRules.othersT[task_name],2)
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
	for k,v in pairs(itemTable) do
		--print(v)
		local _item = hero:GetItemInSlot(k-1)
		if _item then
			if not _item:IsStackable() then
				if v~=0 then
					hero:RemoveItem(_item)
				end
			else
				local _cur_charge = _item:GetCurrentCharges()
				if _cur_charge>v then
					_item:SetCurrentCharges(_cur_charge-v)
				else
					hero:RemoveItem(_item)
				end
			end
		end
	end
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function OnPipeiItem( v1,hero )
	local aimItem = v1["aimItem"]
	local specialItem = v1["specialItem"]
	local aimItem_t = stringSplit(aimItem,',')
	local js1 = 0 
	local js2 = 0
	
	if specialItem then
		local specialItem_t = stringSplit(specialItem,',')
		local t_record = {0,0,0,0,0,0,0,0}
		for i=#specialItem_t,1,-1 do
			local __item_num = stringSplit(specialItem_t[i],'*')

			for j=0,5 do
				if t_record[j+1]==0 then
					local _item = hero:GetItemInSlot(j)
					if _item then
					
						local _itemName = _item:GetAbilityName()
						if __item_num[1]==_itemName then
							local charges = tonumber(__item_num[2])
							if _item:IsStackable() then
								if _item:GetCurrentCharges()>=charges then
									js1 = js1 + 1 
									t_record[j+1] = charges
									break
								end
							else
								js1 = js1 + 1 
								t_record[j+1] = 1
								break
							end
						end
					end
					
				end
			end
		end
		if js1 >= #specialItem_t then
			RemoveItemByTask(hero,t_record)
			return 1,js1
		end
	end
	local t_record = {0,0,0,0,0,0}
	for i=#aimItem_t,1,-1 do
		local __item_num = stringSplit(aimItem_t[i],'*')
		for j=0,5 do
			if t_record[j+1]==0 then
				local _item = hero:GetItemInSlot(j)
				if _item then
				
					local _itemName = _item:GetAbilityName()
					if __item_num[1]==_itemName then
						local charges = tonumber(__item_num[2])
						if _item:IsStackable() then
							if _item:GetCurrentCharges()>=charges then
								js2 = js2 + 1 
								t_record[j+1] = charges
								break
							end
						else
							js2 = js2 + 1 
							t_record[j+1] = 1
							break
						end
					end
				end
				
			end
		end
	end
	if js2 >= #aimItem_t then
		RemoveItemByTask(hero,t_record)
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
		local task_name = "primary"..GameRules.primary_task_index[id+1]
		local __state = GameRules.primarysT[task_name]["state"]
		if bit.band(__state,2^tonumber(id))~=0 then
			if GameRules.primarysT[task_name]["type"] == 2 then
				local __com,__mult = OnPipeiItem(GameRules.primarysT[task_name],hero)
				if __com~=3 then
					mytask_system:OnAwardPlayer(hero,GameRules.primarysT[task_name],__com,__mult)
					mytask_system:OnUIRemove(id,GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])],3)
					GameRules.primarysT[task_name]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					mytask_system:PrimaryIndexIncrease(id)
				else
					SendErrorMsg(hPlayer,4)
					mytask_system:OnEmitMySound(GameRules.primarysT[task_name],2)
				end
				--CustomGameEventManager:Send_ServerToPlayer(hPlayer,"removeitem__backpack",{})
			-- elseif GameRules.primarysT[task_name]["type"] == 3 then
			-- 	if getAllOne(GameRules.curNums["primarys"][id+1]) then
			-- 		GameRules.curNums["primarys"][id+1] = 0
			-- 		--[[award]]
			-- 		mytask_system:OnAwardPlayer(hero,GameRules.primarysT[task_name])
			-- 		mytask_system:OnUIRemove(id,GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])])
			-- 		mytask_system:AddParticle(hero)
			-- 		mytask_system:OnEmitMySound(GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])],3)
			-- 		GameRules.primarysT[task_name]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
			-- 		mytask_system:PrimaryIndexIncrease(id)
			-- 	else
			-- 		SendErrorMsg(hPlayer,2)
			-- 		mytask_system:OnEmitMySound(GameRules.primarysT[task_name],2)
			-- 	end
			elseif GameRules.primarysT[task_name]["type"] == 4 then
				local __arrive = primarysT[task_name]["arrive"]
	
				if bit.band(__arrive,2^id)~=0 then
					mytask_system:OnAwardPlayer(hero,GameRules.primarysT[task_name])
					mytask_system:OnUIRemove(id,GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])],3)
					GameRules.primarysT[task_name]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					mytask_system:PrimaryIndexIncrease(id)
					GameRules.primarysT[task_name]["arrive"] = bit.band(__arrive,bit.bnot(2^tonumber(id)))
			    else
			    	SendErrorMsg(hPlayer,2)
					mytask_system:OnEmitMySound(primarysT[task_name],2)
			    end
				
			else
				local totalNum = GameRules.primarysT[task_name]["aimNums"]
				local bComp = true
				for k,v in pairs(GameRules.curNums1[task_name]) do
					if v[id+1]<GameRules.primarysT[task_name]["aimNums"] then
						bComp = false 
					end
				end
				if bComp then
					for k,v in pairs(GameRules.curNums1[task_name]) do
						GameRules.curNums1[task_name][k][id+1] = 0
					end
					mytask_system:OnAwardPlayer(hero,GameRules.primarysT[task_name])
					mytask_system:OnUIRemove(id,GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.primarysT["primary"..(GameRules.primary_task_index[id+1])],3)
					GameRules.primarysT[task_name]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					mytask_system:PrimaryIndexIncrease(id)
				else
					SendErrorMsg(hPlayer,2)
					mytask_system:OnEmitMySound(GameRules.primarysT[task_name],2)
				end
			end
		else
			SendErrorMsg(hPlayer,3)
			mytask_system:OnEmitMySound(GameRules.primarysT[task_name],2)
		end
	else
		local temp_index = data['task_index']
		local task_name = "other"..temp_index
		local __state = GameRules.othersT[task_name]["state"]
		if bit.band(__state,2^tonumber(id))~=0 then
			if GameRules.othersT[task_name]["type"] == 2 then
				local __com,__mult = OnPipeiItem(GameRules.othersT[task_name],hero)
				if __com~=3 then
					GameRules.othersT[task_name]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					--print("state:"..GameRules.othersT[task_name]["state"])
					--GameRules.curNums[task_name][id+1] = 0
					mytask_system:OnAwardPlayer(hero,GameRules.othersT[task_name],__com,__mult)
					mytask_system:OnUIRemove(id,GameRules.othersT[task_name])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.othersT[task_name],3)
					
				else
					SendErrorMsg(hPlayer,4)
					--mytask_system:OnEmitMySound(GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],2)
				end
				--CustomGameEventManager:Send_ServerToPlayer(hPlayer,"removeitem__backpack",{})
			
			elseif GameRules.othersT[task_name]["type"] == 4 then
				local __arrive = GameRules.othersT[task_name]["arrive"]
				if bit.band(__state,2^id)~=0 then
					if bit.band(__arrive,2^id)~=0 then
						GameRules.othersT[task_name]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
				        GameRules.othersT[task_name]["arrive"] = bit.band(__arrive,bit.bnot(2^tonumber(id)))
				        mytask_system:OnUIRefresh(id,GameRules.othersT[task_name])
				        mytask_system:OnAwardPlayer(hero,GameRules.othersT[task_name])
						mytask_system:OnUIRemove(id,GameRules.othersT[task_name])
						mytask_system:AddParticle(hero)
						mytask_system:OnEmitMySound(GameRules.othersT[task_name],3)
				    else
				    	SendErrorMsg(hPlayer,2)
						mytask_system:OnEmitMySound(GameRules.othersT[task_name],2)
				    end
				else
					SendErrorMsg(hPlayer,3)
					mytask_system:OnEmitMySound(GameRules.othersT[task_name],2)
			    end
			else
				local totalNum = GameRules.othersT[task_name]["aimNums"]
				local bComp = true
				print("123"..task_name)
				for k,v in pairs(GameRules.curNums2[task_name]) do
					print(v[id+1])
					print("-----------")
					print(totalNum)
					if v[id+1]<totalNum then
						bComp = false 
					end
				end
				if bComp then
					for k,v in pairs(GameRules.curNums2[task_name]) do
						GameRules.curNums2[task_name][k][id+1] = 0
					end
					GameRules.othersT[task_name]["state"] = bit.band(__state,bit.bnot(2^tonumber(id)))
					mytask_system:OnAwardPlayer(hero,GameRules.othersT[task_name])
					mytask_system:OnUIRemove(id,GameRules.othersT[task_name])
					mytask_system:AddParticle(hero)
					mytask_system:OnEmitMySound(GameRules.othersT[task_name],3)
				else
					SendErrorMsg(hPlayer,2)
					mytask_system:OnEmitMySound(GameRules.othersT[task_name],2)
				end
			end
		else
			SendErrorMsg(hPlayer,3)
			mytask_system:OnEmitMySound(GameRules.othersT[task_name],2)
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