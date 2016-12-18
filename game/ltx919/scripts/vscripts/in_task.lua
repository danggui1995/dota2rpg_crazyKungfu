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
	local __ent_new_boss1 = Entities:FindByName(nil, "new_boss1")
	local __ent_new_boss2 = Entities:FindByName(nil, "new_boss2")
	local __ent_new_boss3 = Entities:FindByName(nil, "new_boss3")
	local __ent_new_boss4 = Entities:FindByName(nil, "new_boss4")
	local __ent_cailiao = Entities:FindByName(nil, "new_boss_cailiao")

	local __ent_ss1 = Entities:FindByName(nil,"newboss1")
	local __ent_ss2 = Entities:FindByName(nil,"newboss2")
	local __ent_ss3 = Entities:FindByName(nil,"newboss3")
	local __ent_ss4 = Entities:FindByName(nil,"newboss4")

	local __ent_szqx1 = Entities:FindByName(nil,"newboss5")
	local __ent_szqx2 = Entities:FindByName(nil,"new_boss_sg3")
	local __ent_szqx3 = Entities:FindByName(nil,"new_boss5")
	local __ent_szqx4 = Entities:FindByName(nil,"new_boss6")

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
		["__ent_s4"]=__ent_s4,
		["new_boss1"] = __ent_new_boss1,
		["new_boss2"] = __ent_new_boss2,
		["new_boss3"] = __ent_new_boss3,
		["new_boss4"] = __ent_new_boss4,
		["new_ss1"] = __ent_ss1,
		["new_ss2"] = __ent_ss2,
		["new_ss3"] = __ent_ss3,
		["new_ss4"] = __ent_ss4,
		["new_szqx1"] = __ent_szqx1,
		["new_szqx2"] = __ent_szqx2,
		["new_szqx3"] = __ent_szqx3,
		["new_szqx4"] = __ent_szqx4
	}
	local _table = {
		[1] = "npc_myboss_dongxie",
		[2] = "npc_myboss_beigai",
		[3] = "npc_myboss_nandi",
		[4] = "npc_myboss_xidu",
		[5] = "npc_newboss_guojing",
		[6] = "npc_newboss_yangguo",
		[7] = "npc_newboss_zhangwuji",
		[8] = "npc_newboss_wangchongyang",
		[9] = "npc_shenghen_zhuque",
		[10] = "npc_shenghen_xuanwu",
		[11] = "npc_shenghen_baihu",
		[12] = "npc_shenghen_qinglong",
		[13] = "npc_newboss_lisuifeng",
		[14] = "npc_newboss_xiaoqiushui",
		[15] = "npc_newboss_lichenzhou",
		[16] = "npc_newboss_yankuangtu"
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
		local new_boss = CreateUnitByName(_table[i+4],__table["new_boss"..i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		new_boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		local new_boss1 = CreateUnitByName(_table[i+8],__table["new_ss"..i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		new_boss1:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		local new_boss2 = CreateUnitByName(_table[i+12],__table["new_szqx"..i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		new_boss2:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	end
	local _boss = CreateUnitByName("npc_myboss_lixunhuan",__ent_l:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	_boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	--local cailiao = CreateUnitByName("npc_newboss_cailiaoshi",__ent_cailiao:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	--cailiao:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})

	local __fb1__boss = Entities:FindByName(nil,"fb2_boss_born")
	local __pos1 = __fb1__boss:GetAbsOrigin()
	local __fb1_boss = CreateUnitByName("fb2_boss",__pos1, true, nil, nil, DOTA_TEAM_BADGUYS)
	__fb1_boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})

	local __fb2__boss = Entities:FindByName(nil,"fb3_boss_born")
	local __pos2 = __fb2__boss:GetAbsOrigin()
	local __fb2_boss = CreateUnitByName("fb3_boss",__pos2, true, nil, nil, DOTA_TEAM_BADGUYS)
	__fb2_boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})

	local __shizhixuan = Entities:FindByName(nil,"newboss_3")
	local __pos_shizhixuan = __shizhixuan:GetAbsOrigin()
	local __shizhixuan_unit = CreateUnitByName("npc_newboss_shizhixuan",__pos_shizhixuan, true, nil, nil, DOTA_TEAM_BADGUYS)
	__shizhixuan_unit:AddNewModifier(nil,nil,"modifier_phased",{duration=0.1})

	local dt1 = Entities:FindByName(nil,"newboss_2")
	local dt2 = Entities:FindByName(nil,"newboss_1")
	local dt3 = Entities:FindByName(nil,"newboss_4")
	local _dt1 = CreateUnitByName("npc_newboss_wanwan",dt1:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	_dt1:AddNewModifier(nil,nil,"modifier_phased",{duration=0.1})

	local _dt2 = CreateUnitByName("npc_newboss_xuzilin",dt2:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	_dt2:AddNewModifier(nil,nil,"modifier_phased",{duration=0.1})

	local _dt3 = CreateUnitByName("npc_newboss_kouzhong",dt3:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	_dt3:AddNewModifier(nil,nil,"modifier_phased",{duration=0.1})
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

function SpawnNewSg()
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("refresh_new_task"),
	function()
		for i=1,9 do
			local ii = tostring(i)
			local unitName = "npc_task_num_newtask"..ii
			if GameRules.task_num[unitName]<10 then
				local entName = "newsg_"..ii

				local __ent = Entities:FindByName(nil,entName)
				local __unit = CreateUnitByName(unitName,__ent:GetAbsOrigin()+Vector(RandomInt(-100,100),RandomInt(-100,100),0), false, nil, nil, DOTA_TEAM_BADGUYS)
				__unit:AddNewModifier(nil,nil,"modifier_phased",{duration=0.1})
				GameRules.task_num[unitName] = GameRules.task_num[unitName] + 1
			end
			
		end
		return 20
	end
	,0)
	
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

function OnNewSg()
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("refresh_new"),
	function(  )
		local location1 = CreateRelationShip("new_sg2_zuoshang","new_sg2_youxia")
		local location2 = CreateRelationShip("new_sg1_zuoshang","new_sg1_youxia")
		local location3 = CreateRelationShip("new_sg3_zuoshang","new_sg3_youxia")
		if GameRules.newsg1 < 10 then
			local xiaoji1 = CreateUnitByName("npc_sg_new1",location1, false, nil, nil, DOTA_TEAM_BADGUYS)
			xiaoji1:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
			GameRules.newsg1 = GameRules.newsg1 + 1
		end

		if GameRules.newsg2 < 10 then
			local xiaoji2 = CreateUnitByName("npc_sg_new2",location2, false, nil, nil, DOTA_TEAM_BADGUYS)
			xiaoji2:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
			GameRules.newsg2 = GameRules.newsg2 + 1
		end

		if GameRules.newsg3 < 10 then
			local xiaoji3 = CreateUnitByName("npc_sg_new3",location3, false, nil, nil, DOTA_TEAM_BADGUYS)
			xiaoji3:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
			GameRules.newsg3 = GameRules.newsg3 + 1
		end


		return 2
	end,0)
end

function CreateRelationShip(zuoshang,youxia)
	local __zs = Entities:FindByName(nil,zuoshang)
	local __yx = Entities:FindByName(nil,youxia)
	local __pos1 = __zs:GetAbsOrigin()
	local __pos2 = __yx:GetAbsOrigin()
	local location = Vector(RandomFloat(__pos1.x,__pos2.x),RandomFloat(__pos2.y,__pos1.y),__pos1.z)
	return location 
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

function RefreshFB()
	
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("refresh_fb"),
	function(  )
		local fb2_zuoshang = Entities:FindByName(nil,"fb2_zuoshang")
		local fb2_youxia = Entities:FindByName(nil,"fb2_youxia")
		local fb3_zuoshang = Entities:FindByName(nil,"fb3_zuoshang")
		local fb3_youxia= Entities:FindByName(nil,"fb3_youxia")
		local __pos1 = fb2_zuoshang:GetAbsOrigin()
		local __pos2 = fb2_youxia:GetAbsOrigin()
		local __pos3 = fb3_zuoshang:GetAbsOrigin()
		local __pos4 = fb3_youxia:GetAbsOrigin()
		local location1 = Vector(RandomFloat(__pos1.x,__pos2.x),RandomFloat(__pos2.y,__pos1.y),__pos1.z)
		if GameRules.task_num["fb2"] <=0 then
			OnSpawnFB(2,__pos1,__pos2)
		end
		if GameRules.task_num["fb3"] <=0 then
			OnSpawnFB(3,__pos3,__pos4)
		end
		return 15
	end,15)
end

function OnSpawnFB( index,pos_zs,pos_yx )

	local fb_1_num = RandomInt(7, 15)
	local fb_2_num = RandomInt(1,15 - fb_1_num)
	local fb_3_num = RandomInt(1, 15 - fb_1_num - fb_2_num)
	for i=1,fb_1_num do
		local location = Vector(RandomFloat(pos_zs.x,pos_yx.x),RandomFloat(pos_yx.y,pos_zs.y),pos_zs.z)
		local fb1_g = CreateUnitByName("fb"..index.."_1",location, true, nil, nil, DOTA_TEAM_BADGUYS)
		fb1_g:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		GameRules.task_num["fb"..index] = GameRules.task_num["fb"..index]+1
	end
	for i=1,fb_2_num do
		local location = Vector(RandomFloat(pos_zs.x,pos_yx.x),RandomFloat(pos_yx.y,pos_zs.y),pos_zs.z)
		local fb1_g = CreateUnitByName("fb"..index.."_2",location, true, nil, nil, DOTA_TEAM_BADGUYS)
		fb1_g:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		GameRules.task_num["fb"..index] = GameRules.task_num["fb"..index]+1
	end
	for i=1,fb_3_num do
		local location = Vector(RandomFloat(pos_zs.x,pos_yx.x),RandomFloat(pos_yx.y,pos_zs.y),pos_zs.z)
		local fb1_g = CreateUnitByName("fb"..index.."_3",location, true, nil, nil, DOTA_TEAM_BADGUYS)
		fb1_g:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		GameRules.task_num["fb"..index] = GameRules.task_num["fb"..index]+1
	end
	
	
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
	OnNewSg()
	RefreshFB()
	SpawnNewSg()
end