--[[
function OnTransportPara( ... )
	local keysss,data=...
	local id = data['id']
	local hPlayer = PlayerResource:GetPlayer(id)
	local task_type = data['task_type']
	local op = data['op']
	local hero = PlayerResource:GetSelectedHeroEntity(id)

	if task_type==1 then   --送水任务
		local npc = Entities:FindByName(nil, "ent_task1")
		if op == 1 then  --这里是接任务
			if GameRules.task_sx[id+1]==0 then
				if hero:GetNumItemsInInventory()~=6 then
					GameRules.task_sx[id+1] = op
					CustomGameEventManager:Send_ServerToPlayer(
						hPlayer,
						"update_quest",
						{
							songshui = GameRules.task_sx,
							task_type = 1
						}
					)
					EmitSoundOn("Gift_Received_Stinger",npc)
					hero:AddItemByName("item_empty_bottle")
				else
					EmitSoundOn("General.CastFail_AbilityInCooldown",npc)
					Notifications:Bottom(PlayerResource:GetPlayer(id),{text="你的背包已满!!!",duration=1,style={color="red"},continue=false})
				end
			else
				EmitSoundOn("General.CastFail_AbilityInCooldown",npc)
				Notifications:Bottom(PlayerResource:GetPlayer(id),{text="你已经拥有此任务了!!!",duration=1,style={color="red"},continue=false})
			end
		elseif op == 0 then   --这里是提交任务
			local curXP = hero:GetCurrentXP()
			if GameRules.task_sx[id+1]==2 and hero:HasItemInInventory("item_full_bottle") then
				--这里是送小水
				AwardXpAndGold(400,1000,500,hero)
				GameRules.task_sx[id+1] = op
				CustomGameEventManager:Send_ServerToPlayer(
					hPlayer,
					"update_quest",
					{
						songshui = GameRules.task_sx,
						task_type = 1
					}
				)

				EmitSoundOn("Tutorial.TaskCompleted",npc)
				for i=0,5 do
					local hItem = hero:GetItemInSlot(i)
					if hItem~=nil then
						if (hItem:GetName())=="item_full_bottle" then
							hero:RemoveItem(hItem)
							break
						end
					end
				end
			elseif GameRules.task_sx[id+1]==3 and hero:HasItemInInventory("item_spec_bottle") then
				--这里是送大水
				AwardXpAndGold(2000,3000,1500,hero)
				GameRules.task_sx[id+1] = op
				CustomGameEventManager:Send_ServerToPlayer(
					hPlayer,
					"update_quest",
					{
						songshui = GameRules.task_sx,
						task_type = 1
					}
				)
				EmitSoundOn("Loot_Drop_Stinger_Mythical",npc)
				for i=0,5 do
					local hItem = hero:GetItemInSlot(i)
					if hItem~=nil then
						if (hItem:GetName())=="item_spec_bottle" then
							hero:RemoveItem(hItem)
							break
						end
					end
				end
			else
				EmitSoundOn("secretshop_secretshop_takeitoutside",npc)
				Notifications:Bottom(PlayerResource:GetPlayer(id),{text="你还没有完成该任务!!!",duration=1,style={color="red"},continue=false})
			end
		end
	elseif task_type==2 then     --除妖任务
		local hNpc = Entities:FindByName(nil, "ent_task2")
		if op==1 then 
			if GameRules.task_cy[id+1] == 0 then
				GameRules.task_cy[id+1] = op
				EmitSoundOn("Gift_Received_Stinger",hNpc)
				CustomGameEventManager:Send_ServerToPlayer(
					hPlayer,
					"update_quest",
					{
						chuyao = GameRules.task_cy,
						task_type = 2,
						cur = GameRules.cy_cur,
						whole = 10,
						op = 1
					}
				)
			else
				EmitSoundOn("General.CastFail_AbilityInCooldown",hNpc)
				Notifications:Bottom(PlayerResource:GetPlayer(id),{text="你已经拥有此任务了!!!",duration=1,style={color="red"},continue=false})
			end
			
		elseif op==0 then
			if GameRules.cy_cur[id+1] == 10 then
				if hero:HasItemInInventory("item_task2_message") then
					--奖励
					EmitSoundOn("Loot_Drop_Stinger_Mythical",hNpc)
					AwardXpAndGold(90000,120000,3000,hero)
				else
					--奖励
					EmitSoundOn("Tutorial.TaskCompleted",hNpc)
					AwardXpAndGold(40000,80000,6000,hero)
				end
				GameRules.task_cy[id+1] = op
				GameRules.cy_cur[id+1] = 0
				CustomGameEventManager:Send_ServerToPlayer(
					hPlayer,
					"update_quest",
					{
						chuyao = GameRules.task_cy,
						task_type = 2,
						cur = GameRules.cy_cur,
						whole = 10
					}
				)
			else
				EmitSoundOn("General.CastFail_AbilityInCooldown",hNpc)
				Notifications:Bottom(PlayerResource:GetPlayer(id),{text="你还没有完成该任务!!!",duration=1,style={color="red"},continue=false})
			end
		end
	end
end



]]

function OnSlzlSpawn()
	local __ent_slzl_s1 = Entities:FindByName(nil,"ent_zuoshang1_slzl")
	local __ent_slzl_x1 = Entities:FindByName(nil,"ent_youxia1_slzl")
	local __ent_slzl_s2 = Entities:FindByName(nil,"ent_zuoshang2_slzl")
	local __ent_slzl_x2 = Entities:FindByName(nil,"ent_youxia2_slzl")
	local __ent_slzl_s3 = Entities:FindByName(nil,"ent_zuoshang3_slzl")
	local __ent_slzl_x3 = Entities:FindByName(nil,"ent_youxia3_slzl")
	local __ent_slzl_s4 = Entities:FindByName(nil,"ent_zuoshang4_slzl")
	local __ent_slzl_x4 = Entities:FindByName(nil,"ent_youxia4_slzl")
	local __ent_boss1 = Entities:FindByName(nil,"ent_boss1_slzl")
	local __ent_boss2 = Entities:FindByName(nil,"ent_boss2_slzl")
	local __ent_boss3 = Entities:FindByName(nil,"ent_boss3_slzl")
	local __ent_boss4 = Entities:FindByName(nil,"ent_boss4_slzl")
	local __ent_boss5 = Entities:FindByName(nil,"ent_boss5_slzl")
	local __ent_boss6 = Entities:FindByName(nil,"ent_boss6_slzl")
	local __table1 = 
	{
		["__ent_slzl_x1"]=__ent_slzl_x1,
		["__ent_slzl_s1"]=__ent_slzl_s1,
		["__ent_slzl_x2"]=__ent_slzl_x2,
		["__ent_slzl_s2"]=__ent_slzl_s2,
		["__ent_slzl_x3"]=__ent_slzl_x3,
		["__ent_slzl_s3"]=__ent_slzl_s3,
		["__ent_slzl_x4"]=__ent_slzl_x4,
		["__ent_slzl_s4"]=__ent_slzl_s4,
		["__ent_boss1"]=__ent_boss1,
		["__ent_boss2"]=__ent_boss2,
		["__ent_boss3"]=__ent_boss3,
		["__ent_boss4"]=__ent_boss4,
		["__ent_boss5"]=__ent_boss5,
		["__ent_boss6"]=__ent_boss6
	}
	for i=1,4 do
		for j=1,10 do
			local _pos_s = __table1["__ent_slzl_x"..i]:GetAbsOrigin()
			local _pos_x = __table1["__ent_slzl_s"..i]:GetAbsOrigin()
			local location = Vector(RandomFloat(_pos_s.x,_pos_x.x),RandomFloat(_pos_x.y,_pos_s.y),_pos_s.z)
			local __name = "npc_dota_slzl_"..i.."1"
			if j>7 then
				__name = "npc_dota_slzl_"..i.."2"
			end
			local guaiwu = CreateUnitByName(__name,location, false, nil, nil, DOTA_TEAM_BADGUYS)
			guaiwu:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
			table.insert(GameRules.slzl[i],guaiwu)
		end
	end
	for i=1,6 do
		local location = __table1["__ent_boss"..i]:GetAbsOrigin()
		local guaiwu = CreateUnitByName("npc_dota_slzl_"..i,location, false, nil, nil, DOTA_TEAM_BADGUYS)
		guaiwu:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		if i>3 then
			table.insert(GameRules.slzl[4],guaiwu)
		else
			table.insert(GameRules.slzl[i],guaiwu)
		end
	end
end

function OnTask2Refresh( )
	local __ent_mo1 = Entities:FindByName(nil, "ent_npc_myboss_mo1")
	local __ent_mo2 = Entities:FindByName(nil, "ent_npc_myboss_mo2")
	local __ent_mo3 = Entities:FindByName(nil, "ent_npc_myboss_mo3")
	local __ent_o1 = Entities:FindByName(nil, "ent_npc_myboss_zongshi1")
	local __ent_o2 = Entities:FindByName(nil, "ent_npc_myboss_zongshi2")
	local __ent_o3 = Entities:FindByName(nil, "ent_npc_myboss_zongshi3")
	local __ent_s1 = Entities:FindByName(nil, "ent_npc_myboss_dongxie")
	local __ent_s2 = Entities:FindByName(nil, "ent_npc_myboss_beigai")
	local __ent_s3 = Entities:FindByName(nil, "ent_npc_myboss_nandi")
	local __ent_s4 = Entities:FindByName(nil, "ent_npc_myboss_xidu")
	local __ent_l = Entities:FindByName(nil, "ent_npc_myboss_lixunhuan")
	local __table = {
		["__ent_mo1"]=__ent_mo1,
		["__ent_mo2"]=__ent_mo2,
		["__ent_mo3"]=__ent_mo3,
		["__ent_o1"]=__ent_o1,
		["__ent_o2"]=__ent_o2,
		["__ent_o3"]=__ent_o3,
		["__ent_s1"]=__ent_s1,
		["__ent_s2"]=__ent_s2,
		["__ent_s3"]=__ent_s3,
		["__ent_s4"]=__ent_s4
	}
	local _table = {
		[1] = "npc_myboss_dongxie",
		[2] = "npc_myboss_beigai",
		[3] = "npc_myboss_nandi",
		[4] = "npc_myboss_xidu"
	}
	for i=1,3 do
		local __boss = CreateUnitByName("npc_myboss_mo"..i,__table["__ent_mo"..i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		__boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		local _boss = CreateUnitByName("npc_myboss_zongshi"..i,__table["__ent_o"..i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		_boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	end
	for i=1,4 do
		local _boss = CreateUnitByName(_table[i],__table["__ent_s"..i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		_boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	end
	local _boss = CreateUnitByName("npc_myboss_lixunhuan",__ent_l:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	_boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
end

function OnTask1Refresh( )
	local daxiongge = Entities:FindByName(nil,"ent_npc_myboss_daxiongge")
	local pos = daxiongge:GetAbsOrigin()
	local t_unit = CreateUnitByName("npc_myboss_daxiongge",pos, false, nil, nil, DOTA_TEAM_BADGUYS)
	t_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	t_unit:SetAngles(0,270,0)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("refresh_xg"),
	function(  )
		local zuoshang = Entities:FindByName(nil, "xiongge_zuoshang")
		local youxia = Entities:FindByName(nil, "xiongge_youxia")
		local pos_zs = zuoshang:GetAbsOrigin()
		local pos_yx = youxia:GetAbsOrigin()
		local location = Vector(RandomFloat(pos_zs.x,pos_yx.x),RandomFloat(pos_yx.y,pos_zs.y),pos_zs.z)
		if GameRules.task_num["npc_task_num_xiongge"] < 10 then
			local xiongge = CreateUnitByName("npc_task_num_xiongge",location, false, nil, nil, DOTA_TEAM_BADGUYS)
			xiongge:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
			GameRules.task_num["npc_task_num_xiongge"] = GameRules.task_num["npc_task_num_xiongge"] + 1
		end
		return 3
	end,0)
end

function OnDuwurefresh()
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("refresh_duwu"),
	function(  )
		local __zs = Entities:FindByName(nil,"ent_mo_zuoshang")
		local __yx = Entities:FindByName(nil,"ent_mo_youxia")
		local __pos1 = __zs:GetAbsOrigin()
		local __pos2 = __yx:GetAbsOrigin()
		local location = Vector(RandomFloat(__pos1.x,__pos2.x),RandomFloat(__pos2.y,__pos1.y),__pos1.z)
		if GameRules.duwu_num < 10 then
			local xiaoji = CreateUnitByName("npc_dota_duwu1",location, false, nil, nil, DOTA_TEAM_BADGUYS)
			xiaoji:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
			GameRules.duwu_num = GameRules.duwu_num + 1
		end
		return 2
	end,0)
end

function OnTaskJiRefresh( )
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("refresh_ji"),
	function(  )
		local __zs = Entities:FindByName(nil,"shaji_zuoshang")
		local __yx = Entities:FindByName(nil,"shaji_youxia")
		local __pos1 = __zs:GetAbsOrigin()
		local __pos2 = __yx:GetAbsOrigin()
		local location = Vector(RandomFloat(__pos1.x,__pos2.x),RandomFloat(__pos2.y,__pos1.y),__pos1.z)
		if GameRules.task_num["npc_task_num_ji_normal"] < 10 then
			local __rd = RandomInt(1, 100)
			if __rd<10 then
				local daji = CreateUnitByName("npc_ji_big",location, false, nil, nil, DOTA_TEAM_BADGUYS)
				daji:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
			else
				local xiaoji = CreateUnitByName("npc_task_num_ji_normal",location, false, nil, nil, DOTA_TEAM_BADGUYS)
				xiaoji:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
				GameRules.task_num["npc_task_num_ji_normal"] = GameRules.task_num["npc_task_num_ji_normal"] + 1
			end
		end
		return 2
	end,0)
end

function OnQiangDaoSpawn(  )
	local _qiangdao1 = Entities:FindByName(nil, "ent_npc_myboss_qiangdao1")
	local _qiangdao2 = Entities:FindByName(nil, "ent_npc_myboss_qiangdao2")
	local _qiangdao3 = Entities:FindByName(nil, "ent_npc_myboss_qiangdao3")
	local __table = {
		["_qiangdao1"]=_qiangdao1,
		["_qiangdao2"]=_qiangdao2,
		["_qiangdao3"]=_qiangdao3
	}
	for i=1,3 do
		local _qiangdao = CreateUnitByName("npc_myboss_qiangdao"..i, __table["_qiangdao"..i]:GetAbsOrigin(), true ,nil,nil, DOTA_TEAM_BADGUYS)
		_qiangdao:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	end
end

--[[
function AwardXpAndGold(xp1,xp2,gold,hero)
	local randomXp = RandomInt(xp1, xp2)
	local id = hero:GetPlayerID()
	hero:AddExperience(randomXp, DOTA_ModifyXP_Unspecified,false,false) 
	PlayerResource:SetGold(id, PlayerResource:GetGold(id)+gold,false)
end]]
function OnNpcSpawn( )
	OnTask1Refresh()
	OnTask2Refresh()
	OnTaskJiRefresh()
	OnDuwurefresh()
	OnSlzlSpawn()
end