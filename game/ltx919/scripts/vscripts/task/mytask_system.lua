--     ==<<                   created by csust 李天行 @2016-01-14                   >>==
require('libraries/notifications')
biaoji=0
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

if mytask_system == nil and biaoji==0 then

	mytask_system = class({})
	GameRules.primary_task_index = 	{1,1,1,1,1,1,1,1,1,1,1,1}
	GameRules.hero_shengwang 	= 	{0,0,0,0,0,0,0,0,0,0,0,0}
	print("task_init")
	GameRules.primarysT = {}
	GameRules.othersT = {}
	local kvTable = LoadKeyValues("scripts/kv/taskTable.kv")
	if kvTable then
		GameRules.primarysT = kvTable["primarys"]
		GameRules.othersT = kvTable["others"]
		GameRules.curNums1 = {}
		GameRules.curNums2 = {}
		
		
		for k,v in pairs(GameRules.primarysT) do
			local __temp1 = {}
			if v["aimNums"] then
				local arr_aim = stringSplit(v["unitName"],'+')
				for __i=1,#arr_aim do
					__temp1[arr_aim[__i]] = {0,0,0,0,0,0,0}
				end
			end
			GameRules.curNums1[k] = __temp1
		end
		for k,v in pairs(GameRules.othersT) do
			local __temp2 = {}
			if v["aimNums"] then
				local arr_aim = stringSplit(v["unitName"],'+')
				for __i=1,#arr_aim do
					__temp2[arr_aim[__i]] = {0,0,0,0,0,0,0}
				end
			end
			GameRules.curNums2[k] = __temp2
		end
		-- PrintTable(GameRules.curNums1)
		-- print("----------------------")
		-- PrintTable(GameRules.curNums2)
	else
		Warning("load kv file failed!")
	end
end
biaoji =1 
function mytask_system:OnTaskInit()
	ListenToGameEvent("entity_killed",Dynamic_Wrap(mytask_system, "OnKillUnit"),self)
	print("task__init_event")
end


function getBitString(arg)  --bit:d2b  
	local t={}
	if arg==0 then
		return "00000"
	end
	while(arg~=0) 
	do 
		table.insert(t,arg%2)
		arg=math.floor(arg/2)
	end
	local str=""
	for i=1,#t do
		str=str..t[i]
	end
	return str
end  
function getAllOne(arg)
	if arg== 0 then
		return false
	end
	local t={}
	while(arg~=0) 
	do 
		if arg%2==0 then
		return false
		end
		arg=math.floor(arg/2)
	end
	return true
end  

function mytask_system:OnKillUnit( event )
	local u_killed = EntIndexToHScript(event.entindex_killed)
	local u_attacker = EntIndexToHScript(event.entindex_attacker)
	if not u_attacker or not IsValidEntity(u_attacker) or not u_killed or not IsValidEntity(u_killed) then
		return
	end
	if u_attacker:GetTeam()==DOTA_TEAM_BADGUYS then
		return 
	end
	--PrintTable(mytask_system.curNums)
	--print("come int onkillunit")
	local hPlayer = u_attacker:GetPlayerOwner()
	local id = u_attacker:GetPlayerOwnerID()
	if id==-1 then
		return
	end
	local killedName = u_killed:GetUnitName()
	for k,v in pairs(GameRules.curNums2) do
		--print(k)
		if GameRules.othersT[k] then
			local __other_state = GameRules.othersT[k]["state"]
			local __other_total = GameRules.othersT[k]["aimNums"]
			if bit.band(__other_state,2^id)~=0 then
				--PrintTable(v[killedName])
				if v[killedName] then
					--print(v[killedName][id+1])
					if v[killedName][id+1]<__other_total then
						GameRules.curNums2[k][killedName][id+1] = GameRules.curNums2[k][killedName][id+1] + 1
						--PrintTable(GameRules.curNums2)
						self:OnUIRefresh(id,GameRules.othersT[k],GameRules.curNums2[k][killedName][id+1],killedName)
					end
				end
				-- for _k,_v in pairs(GameRules.curNums["primarys"][id+1]) do
				-- 	if _k==u_killed:GetUnitName() then
				-- 		GameRules.other
				-- end
				-- local __unit = GameRules.othersT[k]["unitName"]
				-- local __unit_array = stringSplit(__unit,"+")
				-- for __i=1,#__unit_array do
				-- 	if __unit_array[__i] == u_killed:GetUnitName() then
				-- 		--print("come in kill")
				-- 		GameRules.curNums[k][id+1] = bit.bor(GameRules.curNums[k][id+1],2^(__i-1))
				-- 		--print(GameRules.curNums[k][id+1])
						
				-- 	end
				-- end
			end
			--print(__other_total.."\t"..__other_state)
			-- if bit.band(__other_state,2^id)~=0 and GameRules.curNums[k][id+1] <__other_total then
			-- 	if GameRules.othersT[k]["unitName"] == u_killed:GetUnitName() then
			-- 	    GameRules.curNums[k][id+1]
			-- 	    = GameRules.curNums[k][id+1] + 1
			-- 	    -- print(mytask_system.curNums[k][id+1])
			-- 	    self:OnUIRefresh(id,GameRules.othersT[k],GameRules.curNums[k][id+1])
			-- 	    return
			-- 	end
			-- end 
		end
	end

	if not GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]] then
		return
	end

	local __primary_state = GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["state"]
	local __primary_total = GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["aimNums"]
	for k,v in pairs(GameRules.curNums1) do
		if GameRules.primarysT[k] then
			if bit.band(__primary_state,2^id)~=0 then
				if v[killedName] then
					if v[killedName][id+1]<__primary_total then
						GameRules.curNums1[k][killedName][id+1] = GameRules.curNums1[k][killedName][id+1] + 1
						self:OnUIRefresh(id,GameRules.primarysT[k],GameRules.curNums1[k][killedName][id+1],killedName)
					end
				end
			end
		end
	end
	-- if GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"]==3 and bit.band(__primary_state,2^id)~=0 then
	-- 	local __unit = GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["unitName"]
	-- 	local __unit_array = stringSplit(__unit,"+")
	-- 	for __i=1,#__unit_array do
	-- 		if __unit_array[__i] == u_killed:GetUnitName() then
	-- 			GameRules.curNums["primarys"][id+1] = bit.bor(GameRules.curNums["primarys"][id+1],2^(__i-1))
	-- 			self:OnUIRefresh(id,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],GameRules.curNums["primarys"][id+1])
	-- 		end
	-- 	end
	-- end
	-- if GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["type"]==1 and bit.band(__primary_state,2^id)~=0 and GameRules.curNums["primarys"][id+1] <__primary_total then
	-- 	--print(mytask_system.primarysT["primary"..GameRules.primary_task_index[id+1]]["unitName"])
	-- 	--print(u_killed:GetUnitName())
	-- 	if GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]]["unitName"] == u_killed:GetUnitName() then
	-- 		--print("come in kill__")
	-- 		--print(GameRules.curNums["primarys"][id+1])
	-- 	    GameRules.curNums["primarys"][id+1]
	-- 	    = GameRules.curNums["primarys"][id+1] + 1
	-- 	     --print(mytask_system.curNums["primarys"][id+1])
	-- 	    self:OnUIRefresh(id,GameRules.primarysT["primary"..GameRules.primary_task_index[id+1]],GameRules.curNums["primarys"][id+1])
	-- 		return
	-- 	end
	-- end
	
	--PrintTable(mytask_system.curNums)
end

function mytask_system:OnAddInitItem(hero,kvTable)
	if kvTable["initItem"] then
		hero:AddItemByName(kvTable["initItem"])
	end
end

function mytask_system:OnEmitMySound(kvTable,__type)
	local npcName = kvTable["annoucer"]
	local hNpc = nil
	if npcName then
		hNpc = Entities:FindByName(nil,npcName)
	else
		hNpc = Entities:FindByName(nil,"npc_primarytaskman")
	end
	if __type== 1 then
		EmitSoundOn("Gift_Received_Stinger",hNpc)   --accept
	elseif __type == 2 then
		EmitSoundOn("General.CastFail_AbilityInCooldown",hNpc)  --error
	elseif __type == 3 then
		EmitSoundOn("Tutorial.TaskCompleted",hNpc)   --finishi
	elseif __type == 4 then
		EmitSoundOn("ui.books.pageturns",hNpc)    --come in
	elseif __type == 5 then
		EmitSoundOn("secretshop_secretshop_comeagain_02",hNpc)   --come out
	end
end

--[[function mytask_system:OnItemPanelCreate(player)
	local hPlayer = PlayerResource:GetPlayer(player)
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"item_panel_create",{})
end]]

function mytask_system:OnUIShow(player,kvTable)

	CustomGameEventManager:Send_ServerToPlayer(player,"quest_show",kvTable)
end

function mytask_system:OnUIHide(player)
	CustomGameEventManager:Send_ServerToPlayer(player,"quest_hide",{})
	CustomGameEventManager:Send_ServerToPlayer(player,"tijiaowupin__hide",{})
end

function mytask_system:OnUIRefresh(player,kvTable,curNums,unitName)
	local hPlayer = PlayerResource:GetPlayer(player)
	local tot = kvTable["aimNums"]
	local str = ""
	if kvTable["type"] == 4 then
		str = "~~: "
		CustomGameEventManager:Send_ServerToPlayer(hPlayer,"quest_set_line",{player=player,title=kvTable["title"],
			str = str,unitName = "#yiwancheng",op=0})
	else
		if unitName then
			str = " : "..curNums.." / "..tot
			CustomGameEventManager:Send_ServerToPlayer(hPlayer,"quest_set_line",{player=player,title=kvTable["title"],
			str = str,unitName = unitName})
		else
			for k,v in pairs(curNums) do
				str = " : 0 / "..tot
				CustomGameEventManager:Send_ServerToPlayer(hPlayer,"quest_set_line",{player=player,title=kvTable["title"],
				str = str,unitName = k})
			end
		end
	end
end

function mytask_system:OnUICreate(player,kvTable)
	local hPlayer = PlayerResource:GetPlayer(player)
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"quest_create",{player=player,title=kvTable["title"]})
end

function mytask_system:OnUIRemove(player,kvTable)
	local hPlayer = PlayerResource:GetPlayer(player)
	--print("primary_task_index: "..GameRules.primary_task_index[player+1])
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"quest_remove",{title=kvTable["title"]})
end

function SendErrorMsg( player,eType )
	if eType == 1 then
		Notifications:Bottom(player,{text="#alreadyAccept",duration=1,style={color="red"},continue=false})
	elseif eType == 2 then
		Notifications:Bottom(player,{text="#notFinish",duration=1,style={color="red"},continue=false})
	elseif eType == 3 then
		Notifications:Bottom(player,{text="#notAccept",duration=1,style={color="red"},continue=false})
	elseif eType== 4 then
		Notifications:Bottom(player,{text="#noItem",duration=1,style={color="red"},continue=false})
	end
end

function mytask_system:AddParticle(hero)
	local acceptParticle = "particles/econ/events/ti6/hero_levelup_ti6.vpcf"
	local pts = ParticleManager:CreateParticle(acceptParticle,  PATTACH_CUSTOMORIGIN_FOLLOW,hero)
	ParticleManager:SetParticleControl(pts, 0,hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(pts, 1,hero:GetAbsOrigin())
end

function mytask_system:OnAwardPlayer(hero,kvTable,__type,__mult)
	local awardAbility = kvTable["awardAbility"]
	if awardAbility then
		local ___array = stringSplit(awardAbility,',')
		local __rd_jn = RandomInt(tonumber(___array[1]),tonumber(___array[2]))
		local __item = CreateItem("item_ability_"..__rd_jn, hero, hero)
		hero:AddItem(__item)
	end

	if string.find(kvTable["title"],"primary") then
		hero.damage_ratio = hero.damage_ratio + 0.2
	end

	if __type == nil and __mult == nil then
		local award = kvTable["award"]
		local award_array = stringSplit(award,",")
		local id = hero:GetPlayerID()
		for i=1,#award_array do
			if string.sub(award_array[i],1,1)=="g" then
				local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
				local award_num = tonumber(award_str)
				hero:ModifyGold(award_num, false, 0)
				--award gold num
			elseif string.sub(award_array[i],1,1)=="e" then
				local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
				local award_num = tonumber(award_str)
				hero:AddExperience(award_num, DOTA_ModifyXP_Unspecified,false,false) 
				--award exp num
			elseif string.sub(award_array[i],1,1)=="i" then
				local __rate = kvTable["rate"]
				if __rate then
					if RollPercentage(tonumber(__rate)) then
						local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
						local award_sp = stringSplit(award_str,"|")
						local __rd = RandomInt(1,#award_sp)
						

						AddItemOnGround(award_sp[__rd],hero)
						--award item
					end
				else
					local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
					local award_sp = stringSplit(award_str,"|")
					local __rd = RandomInt(1,#award_sp)
					AddItemOnGround(award_sp[__rd],hero)
					--award item
				end
			elseif string.sub(award_array[i],1,1)=="s" then
				local __sw = string.sub(award_array[i],2,string.len(award_array[i]))
				local __sw_num = tonumber(__sw)
				GameRules.hero_shengwang[id+1] = GameRules.hero_shengwang[id+1] + __sw_num
				local hPlayer = PlayerResource:GetPlayer(id)
				CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__refresh_sw",{sw=GameRules.hero_shengwang[id+1]})
			end
		end
	elseif __type==1 then
		local award = kvTable["specialAward"]
		local award_array = stringSplit(award,",")
		local id = hero:GetPlayerID()
		for i=1,#award_array do
			if string.sub(award_array[i],1,1)=="g" then
				local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
				local award_num = tonumber(award_str)*__mult*1.5
				hero:ModifyGold(award_num, false, 0)
				--award gold num
			elseif string.sub(award_array[i],1,1)=="e" then
				local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
				local award_num = tonumber(award_str)*__mult*1.5
				hero:AddExperience(award_num, DOTA_ModifyXP_Unspecified,false,false) 
				--award exp num
			elseif string.sub(award_array[i],1,1)=="i" then
				local __rate = kvTable["rate"]
				if __rate then
					if RollPercentage(tonumber(__rate)) then
						local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
						local award_sp = stringSplit(award_str,"|")
						local __rd = RandomInt(1,#award_sp)
						--print(award_sp[__rd])
						AddItemOnGround(award_sp[__rd],hero)
						--award item
					end
				else
					local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
					local award_sp = stringSplit(award_str,"|")
					local __rd = RandomInt(1,#award_sp)
					--print(award_sp[__rd])

					AddItemOnGround(award_sp[__rd],hero)
					--award item
				end
			elseif string.sub(award_array[i],1,1)=="a" then
				local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
				local award_sp = stringSplit(award_str,"|")
				local __start = tonumber(award_sp[1])
				local __end = tonumber(award_sp[2])
				local __rd = RandomInt(__start,__end)
				hero:AddItemByName("item_ability_"..__rd)
			elseif string.sub(award_array[i],1,1)=="s" then
				local __sw = string.sub(award_array[i],2,string.len(award_array[i]))
				local __sw_num = tonumber(__sw)
				GameRules.hero_shengwang[id+1] = GameRules.hero_shengwang[id+1] + __sw_num
				local hPlayer = PlayerResource:GetPlayer(id)
				CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__refresh_sw",{sw=GameRules.hero_shengwang[id+1]})
			end
		end
	elseif __type == 2 then
		local award = kvTable["award"]
		local award_array = stringSplit(award,",")
		local id = hero:GetPlayerID()
		for i=1,#award_array do
			if string.sub(award_array[i],1,1)=="g" then
				local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
				local award_num = tonumber(award_str)*__mult*1.5
				hero:ModifyGold(award_num, false, 0)
				--award gold num
			elseif string.sub(award_array[i],1,1)=="e" then
				local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
				local award_num = tonumber(award_str)*__mult*1.5
				hero:AddExperience(award_num, DOTA_ModifyXP_Unspecified,false,false) 
				--award exp num
			elseif string.sub(award_array[i],1,1)=="i" then
				local __rate = kvTable["rate"]
				if __rate then
					if RollPercentage(tonumber(__rate)) then
						local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
						local award_sp = stringSplit(award_str,"|")
						local __rd = RandomInt(1,#award_sp)
						AddItemOnGround(award_sp[__rd],hero)
						--award item
					end
				else
					local award_str = string.sub(award_array[i],2,string.len(award_array[i]))
					local award_sp = stringSplit(award_str,"|")
					local __rd = RandomInt(1,#award_sp)
					AddItemOnGround(award_sp[__rd],hero)
					--award item
				end
			elseif string.sub(award_array[i],1,1)=="s" then
				local __sw = string.sub(award_array[i],2,string.len(award_array[i]))
				local __sw_num = tonumber(__sw)
				GameRules.hero_shengwang[id+1] = GameRules.hero_shengwang[id+1] + __sw_num
				local hPlayer = PlayerResource:GetPlayer(id)
				CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__refresh_sw",{sw=GameRules.hero_shengwang[id+1]})
			end
		end
	end
end

function AddItemOnGround(item_name,unit)
	local item = CreateItem(item_name, nil, nil)
    item:SetPurchaseTime(0)
    local pos = unit:GetAbsOrigin()
    local drop = CreateItemOnPositionSync( pos, item )
    local pos_launch = pos+RandomVector(RandomFloat(150,200))
    item:LaunchLoot(false, 200, 0.75, pos_launch)
end

function mytask_system:PrimaryIndexIncrease(player)
	GameRules.primary_task_index[player+1] = GameRules.primary_task_index[player+1] + 1
end