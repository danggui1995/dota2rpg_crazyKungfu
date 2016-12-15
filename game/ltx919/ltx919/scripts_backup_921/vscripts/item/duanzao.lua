require('libraries/notifications')
print("duanzaoinit")
LinkLuaModifier( "modifier_tiaozhan_lua" , "scripts/vscripts/ability/modifiers/modifier_tiaozhan.lua" , LUA_MODIFIER_MOTION_NONE )
function OnBuyItem( event,data )
	if data.entindex and data.entindex ~= -1 and data.name then
		local unit = EntIndexToHScript(data.entindex)
		local hPlayer = unit:GetPlayerOwner()
		local id = unit:GetPlayerOwnerID()
		local hero = hPlayer:GetAssignedHero()
		if hPlayer ~=nil and unit ~= nil then
			local myGold = PlayerResource:GetGold(id)
			local gold = data.gold
			if gold>myGold then
				return
			end
			hero:SpendGold(gold,DOTA_ModifyGold_PurchaseItem)
			if unit:IsRealHero() then
				local js = 1
				for i=0,11 do
					if unit:GetItemInSlot(i) then
						js = js + 1
					end
				end
				if js>12 then
					local __item = CreateItem(data.name,unit,unit)
					local __pos = unit:GetAbsOrigin()
	                __item:SetPurchaseTime(0)
	                local drop = CreateItemOnPositionSync( __pos, __item )
	                local pos_launch = __pos+RandomVector(RandomFloat(150,200))
	                __item:LaunchLoot(false, 200, 0.75, pos_launch)
				else
					unit:AddItemByName(data.name)
				end
			else
				local js = 1
				for i=0,5 do
					if unit:GetItemInSlot(i) then
						js = js + 1
					end
				end
				if js>6 then
					local __item = CreateItem(data.name,unit,unit)
					local __pos = unit:GetAbsOrigin()
	                __item:SetPurchaseTime(0)
	                local drop = CreateItemOnPositionSync( __pos, __item )
	                local pos_launch = __pos+RandomVector(RandomFloat(150,200))
	                __item:LaunchLoot(false, 200, 0.75, pos_launch)
				else
					unit:AddItemByName(data.name)
				end
			end
			
			EmitSoundOnClient("General.Buy",hPlayer)
		end
	end
end

function OnSellItem( event,data )
	if data.entindex and data.entindex ~= -1 and data.name then
		local unit = EntIndexToHScript(data.entindex)
		local hPlayer = unit:GetPlayerOwner()
		local id = unit:GetPlayerOwnerID()
		local hero = PlayerResource:GetSelectedHeroEntity(id)
		if hPlayer ~=nil and unit ~= nil then
			local myGold = PlayerResource:GetGold(id)
			local gold = data.gold
			if gold>myGold then
				return
			end
			hero:SpendGold(gold,DOTA_ModifyGold_PurchaseItem)
			if unit:IsRealHero() then
				local js = 1
				for i=0,11 do
					if unit:GetItemInSlot(i) then
						js = js + 1
					end
				end
				if js>12 then
					local __item = CreateItem(data.name,unit,unit)
					local __pos = unit:GetAbsOrigin()
	                __item:SetPurchaseTime(0)
	                local drop = CreateItemOnPositionSync( __pos, __item )
	                local pos_launch = __pos+RandomVector(RandomFloat(150,200))
	                __item:LaunchLoot(false, 200, 0.75, pos_launch)
				else
					unit:AddItemByName(data.name)
				end
			else
				local js = 1
				for i=0,5 do
					if unit:GetItemInSlot(i) then
						js = js + 1
					end
				end
				if js>6 then
					local __item = CreateItem(data.name,unit,unit)
					local __pos = unit:GetAbsOrigin()
	                __item:SetPurchaseTime(0)
	                local drop = CreateItemOnPositionSync( __pos, __item )
	                local pos_launch = __pos+RandomVector(RandomFloat(150,200))
	                __item:LaunchLoot(false, 200, 0.75, pos_launch)
				else
					unit:AddItemByName(data.name)
				end
			end
			
			EmitSoundOnClient("General.Buy",hPlayer)
		end
	end
end

function OnChuanSong( event,data )
	local opt = data['opt']
	local id = data.PlayerID
	local hPlayer = PlayerResource:GetPlayer(id)
	local hero = PlayerResource:GetSelectedHeroEntity(id)
	local pointname = ""
	local jx_ent
	if opt==nil then
		local fb_type = data['area']
		if fb_type==1 then
			pointname = "ent_fb"..fb_type.."_enter"
		else
			pointname = "fb"..fb_type.."_enter"
		end
		local point = Entities:FindByName(nil,pointname)
		local point_pos = point:GetAbsOrigin()
		FindClearSpaceForUnit(hero, point_pos, false) 
		hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	    hero:Stop()
	    PlayerResource:SetCameraTarget(id, hero)
	    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera"),
	    function (  ) PlayerResource:SetCameraTarget(id, nil) end,0.5)
	else
		if GameRules.tiaozhan[opt]==1 then
			if opt== 3 then
				local nGold = PlayerResource:GetGold(id)
				if nGold <6000 then
					Notifications:Bottom(hPlayer,{text="#jinbibuzu",duration=1,style={color="red"},continue=false})
					EmitSoundOnClient("warning.moregold",hPlayer)
					return
				else 
					hero:SpendGold(6000,DOTA_ModifyGold_PurchaseItem)
					pointname = "nlys_hero"
					jx_ent = "nlys_npc"
					local ent_nlys = Entities:FindByName(nil,jx_ent)
					local ent_nlys_pos = ent_nlys:GetAbsOrigin()
					OnSpawnJx(hero,20,ent_nlys_pos,opt)
				end
			elseif opt == 4 then
				pointname = "ent_shilianzhilu_enter"
			else
				pointname = "ent_jx"..opt.."_hero"
				jx_ent = "ent_jx"..opt.."_jx"
				local ent_jx = Entities:FindByName(nil,jx_ent)
				local ent_jx_pos = ent_jx:GetAbsOrigin()
				if opt == 1 then
					local nGold = PlayerResource:GetGold(id)
					if nGold <2000 then
						Notifications:Bottom(hPlayer,{text="#jinbibuzu",duration=1,style={color="red"},continue=false})
						EmitSoundOnClient("warning.moregold",hPlayer)
						return
					else 
						hero:SpendGold(2000,DOTA_ModifyGold_PurchaseItem)
						OnSpawnJx(hero,2,ent_jx_pos,opt)
					end
				elseif opt == 2 then
					local nGold = PlayerResource:GetGold(id)
					if nGold <4000 then
						Notifications:Bottom(hPlayer,{text="#jinbibuzu",duration=1,style={color="red"},continue=false})
						EmitSoundOnClient("warning.moregold",hPlayer)
						return
					else 
						hero:SpendGold(4000,DOTA_ModifyGold_PurchaseItem)
						OnSpawnJx(hero,10,ent_jx_pos,opt)
					end
				end
			end
			local point = Entities:FindByName(nil,pointname)
			local point_pos = point:GetAbsOrigin()
			FindClearSpaceForUnit(hero, point_pos, false) 
			hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		    hero:Stop()
		    PlayerResource:SetCameraTarget(id, hero)
		    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera"),
		    function (  ) PlayerResource:SetCameraTarget(id, nil) end,0.5)
		else
			Notifications:Bottom(hPlayer,{text="#yijingyouren",duration=1,style={color="red"},continue=false})
			EmitSoundOnClient("General.CastFail_AbilityInCooldown",hPlayer)
		end
	end
end

function OnShowFBPanel( trigger )
	local hero = trigger.activator
	local caller = trigger.caller
	local img = caller:GetName()
	local hPlayer = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"fbPanel__show",{img=img})
end

function OnHideFBPanel( trigger )
	local hero = trigger.activator
	local caller = trigger.caller
	local hPlayer = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"fbPanel__hide",{})
end

function OnFbShuaGuai( event,data )
	local __index = data.index
	local __id = data.PlayerID
	local __hero = PlayerResource:GetSelectedHeroEntity(__id)
	local hPlayer = PlayerResource:GetPlayer(__id)
	local _index = tonumber(__index)
	if _index ==4 then
		return 
	end
	if GameRules.fb_state[_index]== 1 then
		Notifications:Bottom(hPlayer,{text="#yijingkaiqi",duration=1,style={color="red"},continue=false})
		EmitSoundOnClient("General.CastFail_AbilityInCooldown",hPlayer)
		return 
	end
	local ent_zuoshang_name = "fb"..__index.."_zuoshang"
	local ent_youxia_name = "fb"..__index.."_youxia"
	local zuoshang = Entities:FindByName(nil,ent_zuoshang_name)
	local youxia = Entities:FindByName(nil,ent_youxia_name)
	local pos_zs = zuoshang:GetAbsOrigin()
	local pos_yx = youxia:GetAbsOrigin()
	local fb_1_num = RandomInt(7, 15)
	local fb_2_num = RandomInt(1,15 - fb_1_num)
	local fb_3_num = RandomInt(1, 15 - fb_1_num - fb_2_num)
	for i=1,fb_1_num do
		local location = Vector(RandomFloat(pos_zs.x,pos_yx.x),RandomFloat(pos_yx.y,pos_zs.y),pos_zs.z)
		local fb1_g = CreateUnitByName("fb"..__index.."_1",location, true, nil, nil, DOTA_TEAM_BADGUYS)
		fb1_g:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		GameRules.fb_guaiwu[_index] = GameRules.fb_guaiwu[_index]+1
	end
	for i=1,fb_2_num do
		local location = Vector(RandomFloat(pos_zs.x,pos_yx.x),RandomFloat(pos_yx.y,pos_zs.y),pos_zs.z)
		local fb1_g = CreateUnitByName("fb"..__index.."_2",location, true, nil, nil, DOTA_TEAM_BADGUYS)
		fb1_g:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		GameRules.fb_guaiwu[_index] = GameRules.fb_guaiwu[_index]+1
	end
	for i=1,fb_3_num do
		local location = Vector(RandomFloat(pos_zs.x,pos_yx.x),RandomFloat(pos_yx.y,pos_zs.y),pos_zs.z)
		local fb1_g = CreateUnitByName("fb"..__index.."_3",location, true, nil, nil, DOTA_TEAM_BADGUYS)
		fb1_g:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		GameRules.fb_guaiwu[_index] = GameRules.fb_guaiwu[_index]+1
	end
	local hBoss = Entities:FindByName(nil,"fb"..__index.."_boss_born")
	local boss_pos = hBoss:GetAbsOrigin()
	local fb1_boss = CreateUnitByName("fb"..__index.."_boss",boss_pos, true, nil, nil, DOTA_TEAM_BADGUYS)
	fb1_boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	GameRules.fb_guaiwu[_index] = GameRules.fb_guaiwu[_index]+1
	GameRules.fb_state[_index] = 1
end

function OnOpenYazhu( event,data )
	local __aimId = data.id
	local __sourceId = data.PlayerID
	local hPlayer_aim = PlayerResource:GetPlayer(__aimId)
	local hPlayer_sou = PlayerResource:GetPlayer(__sourceId)
	if GameRules.pk_state2~=0 then
		Notifications:Bottom(hPlayer_sou,{text="#yijingyouren",duration=1,style={color="red"},continue=false})
		EmitSoundOnClient("General.CastFail_AbilityInCooldown",hPlayer)
		return
	end
	CustomGameEventManager:Send_ServerToPlayer(hPlayer_sou,"__item_show",{})
	CustomGameEventManager:Send_ServerToPlayer(hPlayer_aim,"__item_show",{})
	CustomGameEventManager:Send_ServerToPlayer(hPlayer_sou,"pkItem__show",{})	
	CustomGameEventManager:Send_ServerToPlayer(hPlayer_aim,"pkItem__show",{})	
	GameRules.pk_state2 = 1
	GameRules.pk_id[1]=__sourceId
	GameRules.pk_id[2]=__aimId
end

function OnSpawnJx( hero,mult,pos,opt )
	local unit_name = hero:GetUnitName()
	local illusion = CreateUnitByName(unit_name, pos, true, nil, nil, DOTA_TEAM_BADGUYS)
	local casterLevel = hero:GetLevel()
	local __int = hero:GetIntellect()
	local __str = hero:GetStrength()
	local __agi = hero:GetAgility()
	illusion:SetBaseStrength(__str*mult)
	illusion:SetBaseAgility(__agi*mult)
	illusion:SetBaseIntellect(__int*mult)
	for abilitySlot=0,4 do
		local ability = hero:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local i_name = illusion:GetAbilityByIndex(abilitySlot)
			illusion:RemoveAbility("ability_empty"..abilitySlot+1)
			illusion:AddAbility(abilityName)
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			illusionAbility:SetLevel(abilityLevel)
		end
	end
	for itemSlot=0,5 do
		local item = hero:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end
	illusion:AddNewModifier(nil, nil, "modifier_illusion", { duration = -1, outgoing_damage = 100, incoming_damage = 0 })
	illusion:MakeIllusion()
	--illusion:AddNewModifier(illusion, nil, "modifier_tiaozhan_lua", {})
	hero:AddNewModifier(hero, nil, "modifier_tiaozhan_lua", {})
	local temp={}
	temp.jx = illusion
	temp.yx = hero
	temp.jl = opt
	GameRules.tiaozhan[opt] = 2
	table.insert(GameRules.tiaozhan_t,temp)
end
