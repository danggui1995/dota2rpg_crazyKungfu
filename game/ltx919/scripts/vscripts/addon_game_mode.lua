-- Generated from template
require('custom_lv')
require('libraries/notifications')
require('in_task')
require('musicsystem')
require('precache')
require('task/mytask_system')
require('item/duanzao')
require('chuansong')
--require('item/itemsystem')
require('libraries/timers')
--require('events')
if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "particles/neutral_fx/ghost_base_attack.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheEveryThingFromKV( context )
end


function OnSlotToBackpack( event,data )
	local hero = EntIndexToHScript(data.hero)
	--print(hero:GetUnitName())
	local id = hero:GetPlayerID()
	local hPlayer = PlayerResource:GetPlayer(id)
	local backpackIndex = #GameRules.Item_Duanzao[id+1]
	--print("backpack"..backpackIndex)
	local __slot = data.slot
	--print("__slot"..__slot)
	local hItem = hero:GetItemInSlot(__slot)
	if hItem then
		local itemName = hItem:GetAbilityName()
		--print(itemName)
		itemIndex = hItem:GetEntityIndex()
		table.insert(GameRules.Item_Duanzao[id+1],itemIndex)
		hero:TakeItem(hItem)
		CustomGameEventManager:Send_ServerToPlayer(hPlayer,"addItem__duanzao",GameRules.Item_Duanzao[id+1])
	end
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

GameRules.gw_lv = 1
GameRules.nPlayers_ltx= 0
GameRules.cur_gw=0
GameRules.num_gw=GameRules.nPlayers_ltx*3+8
GameRules.base_lv=1
GameRules.task_sx = {0,0,0,0,0,0,0,0,0,0,0,0}
GameRules.task_cy = {0,0,0,0,0,0,0,0,0,0,0,0}
GameRules.sx_cur = {0,0,0,0,0,0,0,0,0,0,0,0}
GameRules.cy_cur = {0,0,0,0,0,0,0,0,0,0,0,0}
--GameRules.xg_num = 0
GameRules.task_num = 
{		
	npc_task_num_ji_normal=0,
	npc_task_num_xiongge=0,
	fb2=0,fb3=0,
	npc_task_num_newtask1=0,
	npc_task_num_newtask2=0,
	npc_task_num_newtask3=0,
	npc_task_num_newtask4=0,
	npc_task_num_newtask5=0,
	npc_task_num_newtask6=0,
	npc_task_num_newtask7=0,
	npc_task_num_newtask8=0,
	npc_task_num_newtask9=0
}
--GameRules.ji_num = 0
GameRules.fb_state = {0,0,0,0}
GameRules.fb_guaiwu = {0,0,0,0}
GameRules.pk_item = {}
GameRules.pk_id = {-1,-1}
GameRules.pk_state = {0,0}
GameRules.pk_state2 = 0
GameRules.Item_Duanzao = {{},{},{},{},{},{},{},{},{},{},{},{}}
GameRules.lgf1_num = 0
GameRules.lgf2_num = 0
GameRules.duwu_num = 0
GameRules.newsg1 = 0
GameRules.newsg2 = 0
GameRules.newsg3 = 0
GameRules.lgf_lv = 1
GameRules.item_sj = {}
GameRules.tiaozhan = {1,1,1,1}
GameRules.tiaozhan_t = {}
GameRules.nlys = {0,0,0,0,0,0,0,0,0,0}
GameRules.tingguai_flag = 0
GameRules.tingguai_cd = 360
GameRules.courier = {}
GameRules.tzsx = 
{
	["zhuque"] = {3,"taozhuang_zhuque"},
	["qinglong"] = {3,"taozhuang_qinglong"},
	["baihu"] = {3,"taozhuang_baihu"},
	["xuanwu"] = {3,"taozhuang_xuanwu"},
	["xiangyu"] = {4,"taozhuang_xiangyu"},
	["xuantie"] = {2,"taozhuang_xuantie"},
	["zhenhun"] = {2,"taozhuang_zhenhun"},
	["houyi"] = {2,"taozhuang_houyi"},
	["moshen"] = {3,"taozhuang_moshen"},
	["xingtian"] = {2,"taozhuang_xingtian"},
	["jiutianxuannv"] = {4,"taozhuang_jiutianxuannv"},
	["chiyou"] = {5,"taozhuang_chiyou"}
}
GameRules.global_time = 30--130
GameRules.global_cdTime = 10--30

--dota_max_physical_items_purchase_limit

GameRules.slzl = {{},{},{},{},{},{0,0,0,0}}
--GameRules.UnitTable = {{},{},{},{},{},{},{},{},{},{},{},{}}

GameRules.dandao = 
{
	--=
	npc_dota_hero_dazzle=
	"particles/units/heroes/hero_dazzle/dazzle_base_attack.vpcf",
	--=
	npc_dota_hero_huskar=
	"particles/units/heroes/hero_huskar/huskar_base_attack.vpcf",
	--""=
	npc_dota_hero_invoker=
	"particles/units/heroes/hero_invoker/invoker_base_attack.vpcf",
	--""=
	npc_dota_hero_lina=
	"particles/units/heroes/hero_lina/lina_base_attack.vpcf",
	--""=
	npc_dota_hero_morphling=
	"particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
	--""=
	npc_dota_hero_razor=
	"particles/units/heroes/hero_razor/razor_base_attack.vpcf",
	--""=
	npc_dota_hero_shadow_demon=
	"particles/units/heroes/hero_shadow_demon/shadow_demon_base_attack.vpcf",
	--""=
	npc_dota_hero_nevermore=
	"particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf",
	--""=
	npc_dota_hero_sniper=
	"particles/units/heroes/hero_sniper/sniper_base_attack.vpcf",
	--""=
	npc_dota_hero_tinker=
	"particles/units/heroes/hero_tinker/tinker_base_attack.vpcf",
	--""=
	npc_dota_hero_windrunner=
	"particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf",
	--""=
	npc_dota_hero_witch_doctor=
	"particles/units/heroes/hero_witchdoctor/witchdoctor_base_attack.vpcf",
	--""=
	npc_dota_hero_zeus=
	"particles/units/heroes/hero_zuus/zuus_base_attack.vpcf",

	npc_dota_hero_templar_assassin=
	"particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf"

}


GameRules.time_start = 0
function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetPreGameTime(10.0)
	GameRules:SetHeroSelectionTime(30)
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 6 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetUseCustomHeroXPValues ( true )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled(true)
	GameRules:SetFirstBloodActive( false )						--是否产生第一滴血
  	GameRules:SetHideKillMessageHeaders( true )					--隐藏击杀信息
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(CAddonTemplateGameMode, 'OnPlayerGainLevel'), self) 
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CAddonTemplateGameMode,"OnGameRulesStateChange"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(CAddonTemplateGameMode,"ResetRebornTime"), self)
	--ListenToGameEvent("dota_inventory_player_got_item", Dynamic_Wrap(CAddonTemplateGameMode,"OnGetItem"), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(CAddonTemplateGameMode, 'OnPlayerPickHero'), self)
	ListenToGameEvent('player_chat', Dynamic_Wrap(CAddonTemplateGameMode, 'OnPlayerMessage'), self)
	
	-- ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(CAddonTemplateGameMode, 'OnItemPickedUp'), self)
	-- ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(CAddonTemplateGameMode, 'OnItemPurchased'), self)
	-- ListenToGameEvent('dota_inventory_player_got_item', Dynamic_Wrap(CAddonTemplateGameMode, 'OnItemGot'), self)
	-- ListenToGameEvent('inventory_updated', Dynamic_Wrap(CAddonTemplateGameMode, 'OnInventoryUpdated'), self)
	
	self._eGameMode=GameRules:GetGameModeEntity()
	self._eGameMode:SetUseCustomHeroLevels(true)
	self._eGameMode:SetCustomHeroMaxLevel(CUSTOM_MAX_LEVEL)
	self._eGameMode:SetCustomXPRequiredToReachNextLevel( CUSTOM_XP_TABLE ) --  TODO
	--self._eGameMode:SetItemAddedToInventoryFilter( Dynamic_Wrap( CAddonTemplateGameMode, "ItemAddedFilter" ), self )

    self._eGameMode:SetCameraDistanceOverride(1300)
    self._eGameMode:SetLoseGoldOnDeath(false)
   --	self._eGameMode:SetExecuteOrderFilter(Dynamic_Wrap(CAddonTemplateGameMode, "ExecuteOrderFilter"),self)
   	self._eGameMode:SetDamageFilter(Dynamic_Wrap(CAddonTemplateGameMode,"OnDamageFilter"),self)
   	self._eGameMode:SetFogOfWarDisabled(true)
	--tower:AddNewModifier( tower, nil, "modifier_invulnerable", {} )  无敌的Modifier
	GameRules.DropTable = LoadKeyValues("scripts/kv/item_drops.kv")
	GameRules.ForgeTable = LoadKeyValues("scripts/kv/item_forge.kv")
	GameRules.SuitTable = LoadKeyValues("scripts/kv/item_suit.kv")

	OnInitItemForge()
--	GameRules.taskTable = LoadKeyValues("scripts/kv/taskTable.kv")
--	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_TOP_TIMEOFDAY, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( 1, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( 2, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_ACTION_PANEL, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_ACTION_MINIMAP, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_PANEL, true )
--	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_ITEMS, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_SHOP, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_GOLD, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( 9, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( 10, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( 11, false )
--	GameRules:GetGameModeEntity():SetHUDVisible( 12, false )
	CustomGameEventManager:RegisterListener("ListennerOnAcceptTask",OnAcceptTask)
	CustomGameEventManager:RegisterListener("ListennerOnSubmitTask",OnSubmitTask)
	CustomGameEventManager:RegisterListener("baseup_armor",OnBaseUpArmor)
	CustomGameEventManager:RegisterListener("__to_chuansong",OnChuanSong)
	CustomGameEventManager:RegisterListener("__diff_selected",OnDiffSelected)
	--CustomGameEventManager:RegisterListener("slot_to_backpack_my",OnSlotToBackpack)
	--CustomGameEventManager:RegisterListener("duanzao_onclick",OnDuanZaoClick)
	--CustomGameEventManager:RegisterListener("tijiaowupin_onclick",OnTijiaowupinClick)
	--CustomGameEventManager:RegisterListener("UI_BuyItem",OnBuyItem)
	--CustomGameEventManager:RegisterListener("__start_pk",OnOpenYazhu)
	--CustomGameEventManager:RegisterListener("slot_to_backpack_pk",OnSlotToBackpack_pk)
	--CustomGameEventManager:RegisterListener("pkItem__cancle",OnPkCancle)
	--CustomGameEventManager:RegisterListener("pkItem__sure",OnPkSure)
	CustomGameEventManager:RegisterListener("__fb_shuaguai",OnFbShuaGuai)
	CustomGameEventManager:RegisterListener("__on_hc",OnHc)
	--CustomGameEventManager:RegisterListener("__on_tg",OnTg)
	CustomGameEventManager:RegisterListener("__forge__item",ForgeItem)
	LinkLuaModifier("modifier_ltx_cleave_attack", "ability/modifiers/modifier_ltx_cleave_attack", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_tiaozhan_lua", "ability/modifiers/modifier_tiaozhan.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_ltx_magical_damage_bonus_percent", "ability/modifiers/modifier_ltx_magical_damage_bonus_percent", LUA_MODIFIER_MOTION_NONE)
	

end
GameRules.diff = 1
function OnDiffSelected( event,data )
	GameRules.diff = data.diff
	for i=0,6 do
		if PlayerResource:IsValidPlayerID(i) then
			local hero = PlayerResource:GetSelectedHeroEntity(i)

			if hero then
				hero:ModifyGold(300*(GameRules.diff-1), false, 0)
				hero.damage_ratio = 1 - (GameRules.diff * 0.12)
			end
		end
	end
	Notifications:TopToAll({text="diff_selected", style={color="black",["font-size"]="40px"}, duration=6})
	Notifications:TopToAll({text="diff"..data.diff, style={color="black",["font-size"]="40px"}, duration=6,continue=true})
	ShowDiffcult()
end
function ShowDiffcult()
	-- if _G.showdiffcult == nil then
	-- 	_G.showdiffcult = SpawnEntityFromTableSynchronous( "quest", {
	-- 		--name = "#CFRoundCountingDown",
	-- 		name = "showdiffcult",
	-- 		title =  "currentDiffcult"
	-- 	})
	-- 	_G.showdiffcult:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, GameRules.diff )
	-- 	_G.showdiffcult:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.diff)
	-- end

	CustomGameEventManager:Send_ServerToAllClients("addPermanentBar",{id=_G.cdId+1,name="currentDiffcult{0}",params={'diff'..GameRules.diff}})
		
end


function MyContains( __table,__value )
	for k,v in pairs(__table) do
		if v==__value then
			return true
		end
	end
	return false
end

function ForgeItem( event,data )
	local hero = EntIndexToHScript(data.unit)
	if not hero or not hero:HasInventory() then
		return 
	end
	local opt = data.opt 
	local __forge_table
	if opt == 1 then
		__forge_table = GameRules.ForgeTable["normal"]
	else 
		__forge_table = GameRules.ForgeTable["suit"]
	end
	local id = hero:GetPlayerOwnerID()
	for k,v in pairs(__forge_table) do
		local checked_table = {}
		local bHasForged = true
		for _k,_v in pairs(v["ItemSets"]) do
			local bHasPart = false 
			for i=0,5 do
				if not MyContains(checked_table,i) then
					local _item = hero:GetItemInSlot(i)
					if _item then
						local _itemName = _item:GetAbilityName()
						if _v==_itemName then
							bHasPart = true
							table.insert(checked_table,i)
							break
						end
					end
				end
			end
			if not bHasPart then
				bHasForged = false 
				break
			end
		end
		if bHasForged then
			local forge_chance = tonumber(v["Chance"])
			local rd = RandomInt(1,100)
			for i=0,5 do
				if MyContains(checked_table,i) then
					local __item = hero:GetItemInSlot(i)
					if __item then
						hero:RemoveItem(__item)
					end
				end
			end
			if rd<=forge_chance then
				hero:AddItemByName(k)
				Notifications:MidLeft(id,{text="forge_result_succeed", duration=3.0,style={color="red",["font-size"]="40px"}})
			else
				Notifications:MidLeft(id,{text="forge_result_failed", duration=3.0,style={color="red",["font-size"]="40px"}})
			end
			return 
		end
	end
	Notifications:MidLeft(id,{text="no_forge_result", duration=3.0,style={color="red",["font-size"]="40px"}})
end

function OnTg( event,data )
	GameRules.tingguai_flag = 1
	local hero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	hero:SpendGold(3500, 0)
	Notifications:TopToAll({text=data.playerName, duration=3.0,style={color="red",["font-size"]="40px"}})
	Notifications:TopToAll({text="#tg_success", duration=3.0,style={color="white",["font-size"]="40px"},continue=true})
	EmitGlobalSound("game.tingguai")
	--if GameRules.chuguai_t[GameRules.gw_lv] - GameRules:GetGameTime() + _G.time_start <=60 then
		if GameRules._entCountDown then
			UTIL_Remove(GameRules._entCountDown)
			GameRules._entCountDown = nil
		end
	--end
	for i=GameRules.gw_lv,30 do
		GameRules.chuguai_t[i] = GameRules.chuguai_t[i] + 60 
	end
	local configInfo = {}
	local temp = {}
	temp.tingguai = GameRules.tingguai_flag
	table.insert(configInfo,temp)
	CustomNetTables:SetTableValue("Config", "ConfigInfo", configInfo)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("tg_cooldown"),
		function()
			if GameRules:IsGamePaused() then
				return 1
			end
			if GameRules.tingguai_cd == 0 then
				GameRules.tingguai_flag = 0
				local configInfo = {}
				local temp = {}
				temp.tingguai = GameRules.tingguai_flag
				table.insert(configInfo,temp)
				CustomNetTables:SetTableValue("Config", "ConfigInfo", configInfo)
				return nil
			end
			GameRules.tingguai_cd = GameRules.tingguai_cd - 1
			return 1
		end,0)
end

function MoveUnitAndCamera(hero,id,aim)
	FindClearSpaceForUnit(hero, aim, false) 
	hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
    hero:Stop()
    PlayerResource:SetCameraTarget(id, hero)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera"),
    function (  ) PlayerResource:SetCameraTarget(id, nil) end,0.5)
end

function OnPkAward(hero)
	local id = hero:GetPlayerOwnerID()
	local point_base = Entities:FindByName(nil,"ent_base")
	local point_pos = point_base:GetAbsOrigin()
	MoveUnitAndCamera(hero,id,point_pos)
	for k,v in pairs( GameRules.pk_item ) do
		local itemIndex = v["itemIndex"]
		local hItem = EntIndexToHScript(itemIndex)
		hero:AddItem(hItem)
	end
	for i = #GameRules.pk_item, 1, -1 do
	    if GameRules.pk_item[i] then
	    	local _hItem = EntIndexToHScript( GameRules.pk_item[id+1][i] ) 
	    	local _itemName = _hItem:RemoveSelf()
	        table.remove(GameRules.pk_item, i)
	    end
	end
	GameRules.pk_state[1]=0
	GameRules.pk_state[2]=0
	GameRules.pk_id[1]=-1
	GameRules.pk_id[2]=-1
	GameRules.pk_state2 = 0
end

function OnPkSure( event,data )
	local id1 = data.PlayerID
	local hPlayer1 = PlayerResource:GetPlayer(id1)
	--CustomGameEventManager:Send_ServerToPlayer(hPlayer1,"__item_hide",{})
	local id2 = -1
	if id1 == GameRules.pk_id[1] then
		id2 = GameRules.pk_id[2]
	else
		id2 = GameRules.pk_id[1]
	end
	local hPlayer2 = PlayerResource:GetPlayer(id2)
	CustomGameEventManager:Send_ServerToPlayer(hPlayer2,"refresh__pk_state",{})
	if GameRules.pk_state[1] == 1 then 
		GameRules.pk_state[2] = 1
	else
		GameRules.pk_state[1] = 1
	end
	if bit.band(GameRules.pk_state[1],GameRules.pk_state[2])==1 then
		CustomGameEventManager:Send_ServerToPlayer(hPlayer1,"pkItem__hide",{})
		CustomGameEventManager:Send_ServerToPlayer(hPlayer2,"pkItem__hide",{})
		local hero1 = PlayerResource:GetSelectedHeroEntity(id1)
		local hero2 = PlayerResource:GetSelectedHeroEntity(id2)
		local point1 = Entities:FindByName(nil,"ent_juedou1")
		local point2 = Entities:FindByName(nil,"ent_juedou2")
		local point_pos1 = point1:GetAbsOrigin()
		local point_pos2 = point2:GetAbsOrigin()
		MoveUnitAndCamera(hero1,id1,point_pos1)
		MoveUnitAndCamera(hero2,id2,point_pos2)
		hero1:SetTeam(9)
		hero2:SetTeam(10)
	    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("pk_handle"),
	    function () 
	    	if GameRules.pk_state[1]==1 then
	    		hero1:SetTeam(2)
				hero2:SetTeam(2)
	    		local __base_ent = Entities:FindByName(nil,"ent_base")
	    		local __base_pos = __base_ent:GetAbsOrigin()
	    		local __id1 = GameRules.pk_id[1]
	    		local __id2 = GameRules.pk_id[2]
	    		local __hPlayer1 = PlayerResource:GetPlayer(__id1)
	    		local __hPlayer2 = PlayerResource:GetPlayer(__id2)
	    		local __hero1 = PlayerResource:GetSelectedHeroEntity(__id1)
	    		local __hero2 = PlayerResource:GetSelectedHeroEntity(__id2)
	    		MoveUnitAndCamera(__hero1,__id1,__base_pos)
	    		MoveUnitAndCamera(__hero2,__id2,__base_pos)
	    		Notifications:Top(__hPlayer1,{text="#weifenshengfu",duration=1,style={color="red"},continue=false})
				Notifications:Top(__hPlayer2,{text="#weifenshengfu",duration=1,style={color="red"},continue=false})
				OnPkCancle(event,data)
	    	end
	    	return nil
	    end,30)
	end
end

function OnPkCancle( event,data )
	local id1 = data.PlayerID
	local hero1 = PlayerResource:GetSelectedHeroEntity(id1)
	local id2 = -1
	if id1 == GameRules.pk_id[1] then
		id2 = GameRules.pk_id[2]
	else
		id2 = GameRules.pk_id[1]
	end
	local hero2 = PlayerResource:GetSelectedHeroEntity(id2)
	for k,v in pairs(GameRules.pk_item) do
		local __id = v["id"]
		local hItem = EntIndexToHScript(v["itemIndex"])
		if __id==id1 then
			hero1:AddItem(hItem)
		else
			hero2:AddItem(hItem)
		end
	end
	for i = #GameRules.pk_item, 1, -1 do
	    if GameRules.pk_item[i] then
	    	local _hItem = EntIndexToHScript( GameRules.pk_item[id+1][i] ) 
	    	local _itemName = _hItem:RemoveSelf()
	        table.remove(GameRules.pk_item, i)
	    end
	end
	local hPlayer__1 = PlayerResource:GetPlayer(id1)
	local hPlayer__2 = PlayerResource:GetPlayer(id2)
	GameRules.pk_state[1]=0
	GameRules.pk_state[2]=0
	GameRules.pk_id[1]=-1
	GameRules.pk_id[2]=-1
	GameRules.pk_state2 = 0
	--CustomGameEventManager:Send_ServerToPlayer(hPlayer__1,"__item_hide",{})
	--CustomGameEventManager:Send_ServerToPlayer(hPlayer__2,"__item_hide",{})
	CustomGameEventManager:Send_ServerToPlayer(hPlayer__1,"removeItem__pk",{})
	CustomGameEventManager:Send_ServerToPlayer(hPlayer__2,"removeItem__pk",{})
	CustomGameEventManager:Send_ServerToPlayer(hPlayer__2,"pkItem__hide",{})
end

function CAddonTemplateGameMode:OnPlayerMessage( event )
	--PrintTable(event)
	local playerId = event.playerid
	local text = event.text
	
	local steamId = PlayerResource:GetSteamAccountID(playerId)
	local hero = PlayerResource:GetSelectedHeroEntity(playerId)
	if steamId=="135093847" or steamId==135093748 then
		local strLength = string.len(text)
		--[[-suit chiyou]]
		local str = string.sub(text,7,strLength)
		for k,v in pairs(GameRules.SuitTable) do
			if k==str then
				for _k,_v in pairs(v["ItemSets"]) do
					PrintTable(_v)
					hero:AddItemByName(_v)
				end
			end
		end
	end

end

function OnSlotToBackpack_pk( event,data )
	local id = data.PlayerID
	local slot = data.slot 
	local hPlayer = PlayerResource:GetPlayer(id)
	local backpackIndex = #GameRules.pk_item
	local hero = PlayerResource:GetSelectedHeroEntity(id)
	local hItem = hero:GetItemInSlot(slot)
	if hItem then
		local t = {}
		local itemName = hItem:GetAbilityName()
		itemIndex = hItem:GetEntityIndex()
		t.itemIndex = itemIndex
		t.id = id
		table.insert(GameRules.pk_item,t)
		hero:TakeItem(hItem)
		CustomGameEventManager:Send_ServerToPlayer(hPlayer,"addItem__pk",GameRules.pk_item)
		PrintTable(GameRules.pk_item)
	end
end

function StrengthBase(health,armor)
	GameRules.base_lv = GameRules.base_lv + 1
	local ent =  Entities:FindByName(nil, "ent_base")

	local tmp_armor = ent:GetPhysicalArmorBaseValue() 
	ent:SetPhysicalArmorBaseValue(armor+tmp_armor)
	local maxHealth = ent:GetBaseMaxHealth()
	local curHealth = ent:GetHealth()
	ent:SetBaseMaxHealth(maxHealth+health)
	ent:SetMaxHealth(maxHealth + health)
	ent:Heal(health, nil) 

	EmitSoundOn("Hero_Chen.HandOfGodHealHero", ent )
	CustomGameEventManager:Send_ServerToAllClients("lv_update_base",{base_lv=GameRules.base_lv})
	local nIceIndex = ParticleManager:CreateParticle(
		"particles/omniknight_purification_ltx.vpcf", 
		PATTACH_CUSTOMORIGIN, 
		ent)
    ParticleManager:SetParticleControl(nIceIndex, 0, ent:GetOrigin())
    ParticleManager:SetParticleControl(nIceIndex, 1, Vector(300,300,300))
    ent:SetContextThink("deletep", 
    	function(  )
    		ParticleManager:DestroyParticle(nIceIndex,false)
    	end
    , 0.5)
end

function OnBaseUpArmor( index,keys )
	local opt = keys.opt
	local id = keys.PlayerID
	if opt == 1 then
		local nGold = PlayerResource:GetGold(id)
		if nGold <4000 then
			Notifications:Bottom(PlayerResource:GetPlayer(keys.PlayerID),{text="#jinbibuzu",duration=1,style={color="red"},continue=false})
			EmitSoundOnClient("warning.moregold",PlayerResource:GetPlayer(keys.PlayerID))
		else 
			StrengthBase(1000,5)
			local hero = PlayerResource:GetSelectedHeroEntity(id)
			hero:SpendGold(4000,DOTA_ModifyGold_PurchaseItem)
		end
	else
		local id = keys.PlayerID
		if GameRules.hero_shengwang[id+1] <7 then
			Notifications:Bottom(PlayerResource:GetPlayer(keys.PlayerID),{text="#shengwangbuzu",duration=1,style={color="red"},continue=false})
			EmitSoundOnClient("General.CastFail_AbilityInCooldown",PlayerResource:GetPlayer(id))
		else 
			StrengthBase(1000,5)
		   	GameRules.hero_shengwang[id+1] = GameRules.hero_shengwang[id+1] - 7
		   	local hPlayer = PlayerResource:GetPlayer(id)
		   	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__refresh_sw",{sw=GameRules.hero_shengwang[id+1]})
		end
	end
	

	--[[
	local tCaster = PlayerResource:GetSelectedHeroEntity(keys.PlayerID) 
	tCaster:AddAbility("base_update_armor")
	local tAbility = tCaster:FindAbilityByName("base_update_armor")
	tAbility:SetLevel(1)
	tCaster:CastAbilityNoTarget(tAbility,keys.PlayerID) 
	tCaster:RemoveAbility("base_update_armor")
	--]]
	-- 上面这段可以用来动态添加技能并释放  但是有点问题   释放之后金币变成了负数(也就是说API不会执行起来不会有限制)   技能设置为oncastbar=0,onlearnbar=0
end

function ShowStaticUI(  )
	
	--[[for i=0,11 do
		if(PlayerResource:IsValidPlayer(i)) then
			CustomUI:DynamicHud_Create(i,"main",
			"file://{resources}/layout/custom_game/base_panel.xml",nil)
		end
	end
	local tCaster = PlayerResource:GetSelectedHeroEntity(0) 
	tCaster:AddItemByName("item_gong1")
	CustomGameEventManager:Send_ServerToAllClients("init_diag_visible",{})		
	CustomGameEventManager:Send_ServerToAllClients("init_tijiao_visible",{})
	CustomUI:DynamicHud_Create(-1,"OtherRoot",
			"file://{resources}/layout/custom_game/other.xml",nil)	
	local tCaster = PlayerResource:GetSelectedHeroEntity(0)
	local enermy_tmp  =  Entities:FindByName(nil, "enermy_base")
	local tunit = CreateUnitByName("npc_dota_creep_hero5", enermy_tmp:GetAbsOrigin(), false, nil, nil ,DOTA_TEAM_BADGUYS)
		tunit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) 
		local tunit1 = CreateUnitByName("npc_dota_creep_hero4", tCaster:GetAbsOrigin(), false, nil, nil ,DOTA_TEAM_GOODGUYS)
		tunit1:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) 
		tunit1:SetControllableByPlayer(0,true)]]
		--[[local tCaster = PlayerResource:GetSelectedHeroEntity(0)
		for i=1,5 do
			local tunit = CreateUnitByName("npc_dota_test", tCaster:GetAbsOrigin(), false, nil, nil ,DOTA_TEAM_BADGUYS)
		tunit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) 
		tunit:SetControllableByPlayer(0, true)
		end]]
	
end


function CAddonTemplateGameMode:OnPlayerGainLevel(keys)
    local hero = EntIndexToHScript(keys.player):GetAssignedHero()
    hero:SetAbilityPoints(0)
    --hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
end


function CAddonTemplateGameMode:OnGameRulesStateChange( keys )
	-- body
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_PRE_GAME then
		mytask_system:OnTaskInit()
		--ItemSystem:Init()
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		
	end
end

function CAddonTemplateGameMode:OnPlayerPickHero( event )
	local hero = EntIndexToHScript(event.heroindex)
	local player = EntIndexToHScript(event.player)
	local playerID = hero:GetPlayerID()
	hero.equip = {0,0,0,0,0,0}
	
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("give_courier"),
		function (  )
			if GameRules.courier[playerID+1]==nil then
				hero.damage_ratio = 1 - GameRules.diff * 0.12
				if playerID ==0 then
					CustomUI:DynamicHud_Create(0,"haha",
					"file://{resources}/layout/custom_game/diff_xz.xml",nil)
				end
				local courier = CreateUnitByName("npc_dota_flying_courier_my", hero:GetAbsOrigin(), true, nil, hero, hero:GetTeam() )
				courier:SetOwner(hero)
				courier.owner = hero:GetPlayerOwner()
			    courier:SetControllableByPlayer(playerID, false)
			    GameRules.courier[playerID+1]= courier
			end
		end
	,1)
	hero:SetAbilityPoints(0)
	-- local ability_teleport = hero:GetAbilityByIndex(5)
	-- ability_teleport:SetLevel(1)
end

function CreateItemAtPosition( item_name,pos )
	local item = CreateItem(item_name, nil, nil)
	item:SetPurchaseTime(0)
	local drop = CreateItemOnPositionSync( pos, item )
	local pos_launch = pos+RandomVector(RandomFloat(150,200))
	item:LaunchLoot(false, 200, 0.75, pos_launch)
end

function playerInit()
	--[[
	local hero = PlayerResource:GetSelectedHeroEntity(0)
	if hero then
		local pos = hero:GetAbsOrigin()
		CreateItemAtPosition("item_qinglongdao_wuqi",pos)
		CreateItemAtPosition("item_qinglongzhanxue_xiez",pos)
		CreateItemAtPosition("item_qinglongkaijia_yifu",pos)

	end
	]]

	print(bit.band(1,3))
	print(bit.band(1,2))
	for i=0,12 do   --最多支持24个人    9/19记录
		if(PlayerResource:IsValidPlayer(i)) then
			GameRules.nPlayers_ltx=GameRules.nPlayers_ltx+1
		end
	end
	local configInfo = {}
	local temp = {}
	temp.tingguai = GameRules.tingguai_flag
	table.insert(configInfo,temp)
	CustomNetTables:SetTableValue("Config", "ConfigInfo", configInfo)
	GameRules.num_gw=GameRules.nPlayers_ltx*3+2
	print("GameRules.nPlayers_ltx",GameRules.nPlayers_ltx)
	CustomGameEventManager:Send_ServerToAllClients("init_pk_panel",{})
	SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
	local __slzl_r1 = RandomInt(1, 60)
	local __slzl_r2 = RandomInt(1, 60)
	local __slzl_r3 = RandomInt(1, 60)
	local __slzl_r4 = RandomInt(1, 60)
	table.insert(GameRules.slzl[5],__slzl_r1)
	table.insert(GameRules.slzl[5],__slzl_r2)
	table.insert(GameRules.slzl[5],__slzl_r3)
	table.insert(GameRules.slzl[5],__slzl_r4)
	ShowStaticUI()
	--[[
	local tCaster = PlayerResource:GetSelectedHeroEntity(0) 
	local heroName = "npc_dota_hero_phantom_assassin"
	PrecacheUnitByNameAsync(heroName, function()
	 	for i=1,5 do
			local hero = CreateUnitByName(heroName, tCaster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS )
		end
    end, 0)
	
	local playerInfo={}
	for i=1,12 do
		local t = {}
		if (PlayerResource:IsValidPlayer(i-1)) then
			t.steamid=tostring(PlayerResource:GetSteamAccountID(i-1))
			--print(t.steamid)
			t.id = i-1
			table.insert(playerInfo,t)
		end
	end
	CustomNetTables:SetTableValue("Player", "PlayerInfo", playerInfo)
	
	local ent_base_tmp=Entities:FindByName(nil,"ent_base")
	if ent_base_tmp:HasModifier("modifier_invulnerable") then
		ent_base_tmp:RemoveModifierByName("modifier_invulnerable")
	end
	local boss = CreateUnitByName(_G.hero_array[GameRules.gw_lv+1], ent_base_tmp:GetOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
	boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.4})
	boss:SetControllableByPlayer(0, true) 
	--[[local base_ltx = Entities:FindByName(nil , "ent_base")

	for i=0,12 do
		if PlayerResource:GetPlayer(i) ~= nil then
	        base_ltx:SetControllableByPlayer(i, true) 
		end
	end
	//  这一段是给玩家共享某个单位 一开始我是想做基地共享,但是金币的消耗还是单位所属玩家的]]

end
GameRules.t_downtime = 0
function ShowQuestBar( data )
	local __time = data or GameRules.global_time
	--CustomGameEventManager:Send_ServerToAllClients("startCountDown",{str="nextwave",time=GameRules.global_time})
	if GameRules._entCountDown == nil then

		GameRules.t_downtime = GameRules:GetGameTime() + __time - GameRules.time_start
		-- GameRules._entCountDown = SpawnEntityFromTableSynchronous( "quest", {
		-- 	--name = "#CFRoundCountingDown",
		-- 	name = "CountingDown",
		-- 	title =  "nextwave"
		-- })
		-- GameRules._entCountDown:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_ROUND, GameRules.gw_lv+1)

		-- GameRules._entCountDownBar = SpawnEntityFromTableSynchronous( "subquest_base", {
		-- 	show_progress_bar = true,
		-- 	progress_bar_hue_shift = -100
		-- } )
		-- GameRules._entCountDown:AddSubquest( GameRules._entCountDownBar )
		-- GameRules._entCountDownBar:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, __time)
		
		CountDownThink()
	end

end


function jsq_shuaguai(  )
	-- body
	UTIL_Remove(GameRules._entCountDown)
	GameRules._entCountDown = nil 
	EmitGlobalSound("GameStart.RadiantAncient")
	local ent = {
					Entities:FindByName(nil, "creep_born_top_ltx"),
					Entities:FindByName(nil, "creep_born_mid_ltx"),
					Entities:FindByName(nil, "creep_born_bot_ltx"),
					Entities:FindByName(nil, "ent_hero_born")
				} 
	local ent_base_tmp=Entities:FindByName(nil,"ent_base")
	local boss = nil
	--[[if (GameRules.gw_lv+1)%6==0 then
		boss = CreateUnitByName(_G.hero_array[(GameRules.gw_lv+1)/6], ent[4]:GetOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)
		boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.4})
	end
	if boss and boss:GetUnitName() == "npc_dota_creep_hero1" then
		local hAbility1 = boss:FindAbilityByName("earth_spirit_boulder_smash")
		local hAbility2 = boss:FindAbilityByName("earth_spirit_rolling_boulder")
		local hAbility3 = boss:FindAbilityByName("earth_spirit_geomagnetic_grip")
		hAbility1:SetLevel(4)
		hAbility2:SetLevel(4)
		hAbility3:SetLevel(4)
	end]]
	

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("sg_think"),
		function(  )
			for j=1,3 do
				if GameRules:IsGamePaused() then
					return 1
				end
				local tUnit = CreateUnitByName("npc_dota_creep_fk"..GameRules.gw_lv, 
						ent[j]:GetOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)
				tUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
        		local t_order = 
			    {                                       
			        UnitIndex = tUnit:entindex(), 
			        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			        TargetIndex = nil, 
			        AbilityIndex = 0, 
			        Position = ent_base_tmp:GetOrigin(),
			        Queue = 0 
			    }
				tUnit:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.1)
			end
			GameRules.cur_gw = GameRules.cur_gw + 1
			if(GameRules.cur_gw<GameRules.num_gw) then
				return 1
			else 
				GameRules.gw_lv = GameRules.gw_lv + 1
--				CustomGameEventManager:Send_ServerToAllClients("__refresh_boshu",{data=GameRules.gw_lv})	
				GameRules.cur_gw=0
				return nil
			end
		end 
	 , 0) 
end


function CAddonTemplateGameMode:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end
	local ent_tmp = Entities:FindByName(nil, "ent_base")
	if not ent_tmp:IsAlive() then
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
		EmitGlobalSound("game.losegame")
		CustomGameEventManager:Send_ServerToAllClients("__quit_game",{})	
		return
	end

	if(GameRules.gw_lv==31) then
		local ent_enermy_base_tmp = Entities:FindByName(nil, "enermy_base")
		if ent_enermy_base_tmp:HasModifier("modifier_invulnerable") then
			ent_enermy_base_tmp:RemoveModifierByName("modifier_invulnerable")
			Notifications:TopToAll({text="#nowcanattack", duration=5.0,style={color="white",["font-size"]="40px"}})
		end
	end
	local ent_tmp2 = Entities:FindByName(nil, "enermy_base")
	if not ent_tmp2:IsAlive() then
		GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
		CustomGameEventManager:Send_ServerToAllClients("__quit_game",{})	
		return
	end
end

--[[  150 210 

function jsq_deathJudge( )
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("death_Judge"),
		function(  )
			local timeKK = GameRules.gw_lv * 150
			if GameRules.tingguai_ex~=0 then
				timeKK = GameRules.tingguai_ex + (GameRules.gw_lv*150)
			end
			GameRules.tingguai_ex = GameRules.tingguai_ex -1 
			local timeNow = math.floor(GameRules:GetGameTime())
			if (timeNow - timeKK)-_G.time_start == 90 then
				ShowQuestBar()
			end
			if (timeNow-_G.time_start) % 150 ~= 0 and timeNow ~= _G.time_start then
				return 1
			end
			if (timeNow-_G.time_start) ~=0 then
				GameRules.lgf_lv = GameRules.lgf_lv + 1
			end
			if _G._entQuest then
				UTIL_Remove(_G._entQuest)
				_G._entQuest = nil
			end
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and GameRules.gw_lv <=30 then
				jsq_shuaguai()
				GameRules.gw_lv = GameRules.gw_lv + 1
				_G.cur_gw=0
				return 1
			else
				return nil
			end
		end , 1)
end]]

function StartSLZL( )
	local timeNow = math.floor(GameRules:GetGameTime())
	if GameRules.gw_lv == 10 then
		Timers:CreateTimer({
		    endTime = GameRules.slzl[5][1], -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		    callback = function()
		      	for k,v in pairs(GameRules.slzl[1]) do
					local ent_enemy = Entities:FindByName(nil,"enermy_base")
					local pos = ent_enemy:GetAbsOrigin()
					if v and v:IsAlive() then
						FindClearSpaceForUnit(v, pos, false)
						v:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
						GameRules.slzl[6][1] = 1
					end
				end
		    end
		  })
		
	elseif GameRules.gw_lv == 16 then
		Timers:CreateTimer({
		    endTime = GameRules.slzl[5][2], -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		    callback = function()
		      	for k,v in pairs(GameRules.slzl[2]) do
					local ent_enemy = Entities:FindByName(nil,"enermy_base")
					local pos = ent_enemy:GetAbsOrigin()
					if v and v:IsAlive() then
						FindClearSpaceForUnit(v, pos, false)
						v:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
						GameRules.slzl[6][2] = 1
					end
				end
		    end
		  })
	elseif GameRules.gw_lv == 22 then
		Timers:CreateTimer({
		    endTime = GameRules.slzl[5][3], -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		    callback = function()
		      	for k,v in pairs(GameRules.slzl[3]) do
					local ent_enemy = Entities:FindByName(nil,"enermy_base")
					local pos = ent_enemy:GetAbsOrigin()
					if v and v:IsAlive() then
						FindClearSpaceForUnit(v, pos, false)
						v:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
						GameRules.slzl[6][3] = 1
					end
				end
		    end
		  })
		
	elseif GameRules.gw_lv == 28 then
		Timers:CreateTimer({
		    endTime = GameRules.slzl[5][4], -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		    callback = function()
		      	for k,v in pairs(GameRules.slzl[4]) do
					local ent_enemy = Entities:FindByName(nil,"enermy_base")
					local pos = ent_enemy:GetAbsOrigin()
					if v and v:IsAlive() then
						FindClearSpaceForUnit(v, pos, false)
						v:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
						GameRules.slzl[6][4] = 1
					end
				end
		    end
		  })
		
	end
end

function CountDownThink(  )
	-- body
	-- if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	-- 	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("start_sg"),
	-- 		function(  )
	-- 			-- body
	-- 			local t_Time = GameRules.t_downtime - GameRules:GetGameTime()+GameRules.time_start 
	-- 			if GameRules._entCountDownBar~=nil then
	-- 				GameRules._entCountDownBar:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE,
	-- 				 t_Time)
	-- 			end
	-- 			return 1
	-- 		end,0)
	-- end
end
function RollDrops(unit,attacker)
    local DropInfo = GameRules.DropTable[unit:GetUnitName()]
    if DropInfo then
        for k,ItemTable in pairs(DropInfo) do
            local item_name
            if ItemTable.ItemAbility then
            	local __start = ItemTable.ItemAbility["1"]
            	local __end = ItemTable.ItemAbility["2"]
            	local __rd = RandomInt(tonumber(__start),tonumber(__end))
            	item_name = "item_ability_"..__rd
            elseif ItemTable.ItemSets then
                local count = 0
                for i,v in pairs(ItemTable.ItemSets) do
                    count = count+1
                end
                local random_i = RandomInt(1,count)
                item_name = ItemTable.ItemSets[tostring(random_i)]
            else
                item_name = ItemTable.Item
            end
            ItemTable.Chance = (ItemTable.Chance or 0)
            --[[
            if GameRules.hero_shengwang[attacker:GetPlayerOwnerID()+1]~=nil then
            	ItemTable.Chance = ItemTable.Chance + math.floor(math.sqrt(math.floor(math.sqrt(GameRules.hero_shengwang[attacker:GetPlayerOwnerID()+1]))))
            end
             ]]
            local chance = ItemTable.Chance
            local max_drops = ItemTable.Multiple or 1
            for i=1,max_drops do
                if RollPercentage(chance) then
                    local item = CreateItem(item_name, nil, nil)
                    item:SetPurchaseTime(0)
                    local pos = unit:GetAbsOrigin()
                    local drop = CreateItemOnPositionSync( pos, item )
                    local pos_launch = pos+RandomVector(RandomFloat(150,200))
                    item:LaunchLoot(false, 200, 0.75, pos_launch)
        --             local Delete = false
		    		-- drop:SetContextThink(DoUniqueString("CheckingItem") , 
		    		-- function()
		    		-- 	if GameRules:IsGamePaused() then  return 1 end
		    		-- 	if Delete == false then Delete = true
		    		-- 	else
		    		-- 		if (drop:GetContainedItem()).Owner == nil then
		    		-- 			drop:RemoveSelf() 
		    		-- 		else
		    		-- 			return nil
		    		-- 		end
		    		-- 	end
		    		-- 	return 60
		    		-- end,0)
                end
            end
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

GameRules.boss_respawn = 
{
	["npc_newboss_guojing"]="new_boss1",
	["npc_newboss_yangguo"]="new_boss2",
	["npc_newboss_zhangwuji"]="new_boss3",
	["npc_newboss_wangchongyang"]="new_boss4",

	["npc_newboss_lisuifeng"]="newboss5",
	["npc_newboss_xiaoqiushui"]="new_boss_sg3",
	["npc_newboss_lichenzhou"]="new_boss5",
	["npc_newboss_yankuangtu"]="new_boss6",

	["npc_newboss_cailiaoshi"] = "new_boss_cailiao",
	["fb2_boss"] = "fb2_boss_born",
	["fb3_boss"] = "fb3_boss_born",

	["npc_newboss_shizhixuan"] = "newboss_3",

	["npc_newboss_wanwan"] = "newboss_2",
	["npc_newboss_xuzilin"] = "newboss_1",
	["npc_newboss_kouzhong"] = "newboss_4"

}

function CAddonTemplateGameMode:ResetRebornTime( keys )
	local u_killed = EntIndexToHScript(keys.entindex_killed)
	local u_attacker = EntIndexToHScript(keys.entindex_attacker)
	if GameRules.pk_state2==1 and u_killed and u_killed:IsRealHero() and u_attacker and u_attacker:IsRealHero() and u_killed:GetTeam()~=DOTA_TEAM_BADGUYS and u_attacker:GetTeam()~=DOTA_TEAM_BADGUYS then
    	u_killed:SetTeam(DOTA_TEAM_GOODGUYS)
		u_attacker:SetTeam(DOTA_TEAM_GOODGUYS)
    	OnPkAward(u_attacker)
    end
	if u_killed:IsRealHero() and u_killed:GetTeam()==DOTA_TEAM_GOODGUYS then
		if not u_killed:IsReincarnating() then
			u_killed:SetTimeUntilRespawn(15+u_killed:GetLevel()/5)
			return
		end
	end
	local id = u_killed:GetPlayerOwnerID() 
	if id == -1 and u_killed:GetTeam()==DOTA_TEAM_GOODGUYS then
		return 
	end
	
	local id2 = u_attacker:GetPlayerOwnerID() 
	if id2 == -1 and u_attacker:GetTeam()~=DOTA_TEAM_BADGUYS then
		return
	end
	if u_killed:IsCreature() then
        RollDrops(u_killed,u_attacker)
    end
   
	
	local __killedName = u_killed:GetUnitName() 
	if __killedName=="npc_liangongfang_normal" then
		GameRules.lgf1_num = GameRules.lgf1_num - 1
		return
	end
	if __killedName=="npc_liangongfang_gold" then
		GameRules.lgf2_num = GameRules.lgf2_num - 1
		return
	end
	if string.find(__killedName,"slzl") ~= nil then
		for i=1,4 do
			for k,v in pairs(GameRules.slzl[i]) do
				if v==u_killed then
					table.remove(GameRules.slzl[i],k)
				end
			end
		end
		return
	end
	if __killedName=="npc_dota_duwu1" then
		GameRules.duwu_num = GameRules.duwu_num - 1
	end
	if string.find(__killedName,"_task_num_") ~= nil then
		GameRules.task_num[__killedName] = GameRules.task_num[__killedName] - 1
		return
	end
	if string.find(__killedName,"fb2_") ~= nil and __killedName~="fb2_boss" then
		GameRules.task_num["fb2"] = GameRules.task_num["fb2"] - 1
		return
	end
	if string.find(__killedName,"fb3_") ~= nil and __killedName~="fb3_boss" then
		GameRules.task_num["fb3"] = GameRules.task_num["fb3"] - 1
		return
	end
	if string.find(__killedName,"fb1")~=nil then
		local __index = string.sub(__killedName,3,3)
		GameRules.fb_guaiwu[tonumber(__index)] = GameRules.fb_guaiwu[tonumber(__index)] - 1
		if GameRules.fb_guaiwu[tonumber(__index)] == 0 then
			GameRules.fb_state[tonumber(__index)] = 0
		end
		return
	end
	if __killedName=="npc_sg_new1" then
		GameRules.newsg1 = GameRules.newsg1 - 1
		return
	end
	if __killedName=="npc_sg_new2" then
		GameRules.newsg2 = GameRules.newsg2 - 1
		return
	end
	if __killedName=="npc_sg_new3" then
		GameRules.newsg3 = GameRules.newsg3 - 1
		return
	end
	if string.find(__killedName,"myboss")~=nil then
		Notifications:TopToAll({text=__killedName, duration=5.0,style={color="red",["font-size"]="40px"}})
		Notifications:TopToAll({text="yijingsiwang", duration=5.0,style={color="red",["font-size"]="40px"},continue=true})
		EmitGlobalSound("game.bossdie")
		Timers:CreateTimer({
		    endTime = 30, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		    callback = function()
		      	local ent_dxg = Entities:FindByName(nil,"ent_"..__killedName)
				local pos = ent_dxg:GetAbsOrigin()
				local t_unit = CreateUnitByName(__killedName,pos, false, nil, nil, DOTA_TEAM_BADGUYS)
				t_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
				t_unit:SetAngles(0,270,0)
				Notifications:TopToAll({text=__killedName, duration=5.0,style={color="red",["font-size"]="40px"}})
				Notifications:TopToAll({text="yijingfuhuo", duration=5.0,style={color="red",["font-size"]="40px"},continue=true})
				EmitGlobalSound("game.bossreborn")
		    end
		  })
		return 
	end

	if string.find(__killedName,"newboss")~=nil then
		Notifications:TopToAll({text=__killedName, duration=5.0,style={color="red",["font-size"]="40px"}})
		Notifications:TopToAll({text="yijingsiwang", duration=5.0,style={color="red",["font-size"]="40px"},continue=true})
		EmitGlobalSound("game.bossdie")
		Timers:CreateTimer({
		    endTime = 30, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		    callback = function()
		      	local ent_dxg = Entities:FindByName(nil,GameRules.boss_respawn[__killedName])
				local pos = ent_dxg:GetAbsOrigin()
				local t_unit = CreateUnitByName(__killedName,pos, false, nil, nil, DOTA_TEAM_BADGUYS)
				t_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
				t_unit:SetAngles(0,270,0)
				Notifications:TopToAll({text=__killedName, duration=5.0,style={color="red",["font-size"]="40px"}})
				Notifications:TopToAll({text="yijingfuhuo", duration=5.0,style={color="red",["font-size"]="40px"},continue=true})
				EmitGlobalSound("game.bossreborn")
		    end
		  })
		return 
	end

	if __killedName=="fb2_boss" or __killedName=="fb3_boss" then
		Notifications:TopToAll({text=__killedName, duration=5.0,style={color="red",["font-size"]="40px"}})
		Notifications:TopToAll({text="yijingsiwang", duration=5.0,style={color="red",["font-size"]="40px"},continue=true})
		EmitGlobalSound("game.bossdie")
		Timers:CreateTimer({
		    endTime = 30, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		    callback = function()
		      	local ent_dxg = Entities:FindByName(nil,GameRules.boss_respawn[__killedName])
				local pos = ent_dxg:GetAbsOrigin()
				local t_unit = CreateUnitByName(__killedName,pos, false, nil, nil, DOTA_TEAM_BADGUYS)
				t_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
				t_unit:SetAngles(0,270,0)
				Notifications:TopToAll({text=__killedName, duration=5.0,style={color="red",["font-size"]="40px"}})
				Notifications:TopToAll({text="yijingfuhuo", duration=5.0,style={color="red",["font-size"]="40px"},continue=true})
				EmitGlobalSound("game.bossreborn")
		    end
		  })
		return 
	end
end

GameRules.initFlag = 0

function newShowQuest()
	Timers:CreateTimer({
	    endTime = GameRules.global_time, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	    callback = function()
	      	if GameRules.gw_lv <= 30 then
				ShowQuestBar()
				newChuGuai()
			end
	    end
	  })
end

function showTotalProgress(  )
	-- if _G.totalProgress == nil then
	-- 	_G.totalProgress = SpawnEntityFromTableSynchronous( "quest", {
	-- 		--name = "#CFRoundCountingDown",
	-- 		name = "TotalProgress",
	-- 		title =  "wavenum"
	-- 	})
	-- 	_G.totalProgressBar = SpawnEntityFromTableSynchronous( "subquest_base", {
	-- 		show_progress_bar = true,
	-- 		progress_bar_hue_shift = -100
	-- 	} )
	-- 	_G.totalProgress:AddSubquest( _G.totalProgressBar )
	-- end
	
	-- _G.totalProgressBar:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 30)
	-- _G.totalProgress:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.gw_lv)
	-- _G.totalProgressBar:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE,GameRules.gw_lv)
end

function newChuGuai()

	Timers:CreateTimer({
	    endTime = GameRules.global_time, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	    callback = function()
	      	if GameRules.gw_lv <= 30 then
	      		showTotalProgress()
				jsq_shuaguai()
				GameRules.lgf_lv = GameRules.lgf_lv + 1
				StartSLZL()
				newChuGuai()
			end
	    end
	  })
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:_CheckForDefeat()
		--[[for i=1,12 do
			local _hPlayer = PlayerResource:GetPlayer(i-1)
			if _hPlayer then
				local _hero = PlayerResource:GetSelectedHeroEntity(i-1)
				if _hero then
					local _str = _hero:GetStrength()
					local _agi = _hero:GetAgility()
					local _int = _hero:GetIntellect()
					local _str_g = _hero:GetStrengthGain()
					local _agi_g = _hero:GetAgilityGain()
					local _int_g = _hero:GetIntellectGain()
					local _hp_r = _hero:GetHealthRegen()
					local _mp_r = _hero:GetManaRegen()
					local _shengwang = GameRules.hero_shengwang[i]
					CustomGameEventManager:Send_ServerToPlayer(_hPlayer,"refresh_properties",{_str=_str,_agi=_agi,_int=_int,_shengwang=_shengwang,_str_g=_str_g,_int_g=_int_g,_agi_g=_agi_g,_hp_r=_hp_r,_mp_r=_mp_r})
				end
			end
		end]]
		
			
		if GameRules.initFlag == 0 then
			GameRules.initFlag = 1
			playerInit()
			InitBackGroundMusic()

			--print(PlayerResource:GetSelectedHeroEntity(0):GetAbsOrigin())
			OnQiangDaoSpawn()
			OnLianGongFang()
			OnZhen1()
			--local ppp = LoadKeyValues("scripts/npc/npc_items_custom.txt")
			--local ppp = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
			--tttttttt(ppp)
			GameRules.time_start = math.floor(GameRules:GetGameTime())
			newChuGuai()
			--newShowQuest()
			
		end
		local cur_time = math.floor(GameRules:GetGameTime())
		sendCountDownBarInfo(cur_time-GameRules.time_start)
		if cur_time-GameRules.time_start == 10 then
			OnNpcSpawn()
		end
		--[[
		if cur_time-GameRules.time_start == 11 then
			local targets = Entities:FindAllByName("npc_liangongfang_*")
			if targets then

				--print(targets)
				for k,v in pairs(targets) do
					print(k,v)
				end
				--PrintTable(targets)
			end
			--print(targets:GetUnitName())
		end]]
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function tttttttt(kvtable)
	for key, value in pairs(kvtable) do
    	local k = value["AbilityTextureName"]
    	if (k) then  
    		--print('<Image src="file://{images}/spellicons/'..string.sub(k,1,string.len(k))..'.PNG"/>')
        	print('<Image src="file://{images}/items/'..string.sub(k,6,string.len(k))..'.PNG"/>')
    	end
    end    
end

function OnInitItemForge()
	local forgeInfo = {}
	for _,v in pairs(GameRules.ForgeTable) do
		local ttt = {}
		for ___,vvv in pairs(v) do 
			local tt = {}
			table.insert(tt,___)
			local tempTable = {}
			for __,vv in pairs(vvv) do
				table.insert(tempTable ,vv)
			end
			table.insert(tt,tempTable)
			table.insert(ttt,tt)
		end
		
		table.insert(forgeInfo, ttt)
	end
	
	CustomNetTables:SetTableValue("Forges", "ForgesInfo", forgeInfo)
	OnInitSuitTable()
	
end

function OnInitSuitTable()
	--PrintTable(GameRules.SuitTable)
	local suitInfo = {}
	for _,v in pairs(GameRules.SuitTable) do

		local tt = {}
		table.insert(tt,_)
		local tempTable = {}
		for __,vv in pairs(v) do
			table.insert(tempTable ,vv)
		end
		table.insert(tt,tempTable)
	
		table.insert(suitInfo, tt)
	end
	
	CustomNetTables:SetTableValue("Suit", "SuitInfo", suitInfo)
	
end

function OnInitShopInfo()
	local shops = LoadKeyValues("scripts/shop.txt")
	local shopsInfo = {}
	for _,v in pairs(shops) do
		for __,vv in pairs(v) do
			local t = {}
			t.name = __
			t.type = _
			t.index = vv['index']
			t.__p = vv['__p']
			t.gold = GetItemCost(__)
			table.insert(shopsInfo ,t)
		end
	end
	
	table.sort( shopsInfo, function( a,b )
		return tonumber(a.index) < tonumber(b.index)
	end )

	CustomNetTables:SetTableValue("Shops", "ShopsInfo", shopsInfo)
	local compose = LoadKeyValues("scripts/kv/item_hc.kv")
	local composeInfo = {}
	for _,v in pairs(compose) do
		local t = {}
		t.name = _
		t.need = v
		table.insert(composeInfo ,t)
	end
	CustomNetTables:SetTableValue("Compose", "ComposeInfo", composeInfo)
end

--OnInitShopInfo()

function OnZhen1()
	local ent_table={}
	for i=1,10 do
		ent_table[i] = Entities:FindByName(nil,"zhen1_"..i)
	end
	for i=1,10 do
		local unit = Entities:FindByName(nil, "npc_zhen1_"..i)
		unit:PatrolToPosition(ent_table[i]:GetAbsOrigin())
	end
end

function OnLianGongFang()
	local spawn_point1 = Entities:FindByName(nil,"ent_liangongfang_xp")
	local spawn_point2 = Entities:FindByName(nil,"ent_liangongfang_gold")
	local pos1 = spawn_point1:GetAbsOrigin()
	local pos2 = spawn_point2:GetAbsOrigin()
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("refresh_lgf"),
	function()
		if GameRules.lgf1_num<10 then
			for i=1,10-GameRules.lgf1_num do
				local t_unit = CreateUnitByName("npc_liangongfang_normal",pos1, false, nil, nil, DOTA_TEAM_BADGUYS)
				t_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
				t_unit:CreatureLevelUp(GameRules.lgf_lv-1)
				GameRules.lgf1_num = GameRules.lgf1_num+1
			end
		end
		if GameRules.lgf2_num<10 then
			for i=1,10-GameRules.lgf2_num do
				local t_unit = CreateUnitByName("npc_liangongfang_gold",pos2, false, nil, nil, DOTA_TEAM_BADGUYS)
				t_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
				t_unit:CreatureLevelUp(GameRules.lgf_lv-1)
				GameRules.lgf2_num = GameRules.lgf2_num+1
			end
		end
		return 2
	end,0)
end

function OnHc(event,data)
	local id = data.PlayerID
	local hero = PlayerResource:GetSelectedHeroEntity(id)
	local ent_base = Entities:FindByName(nil,"ent_base")
	local aim = ent_base:GetAbsOrigin()
	MoveUnitAndCamera(hero,id,aim)
end

--[[这里有个问题不知道item被销毁了之后是否还在table中占用内存]]
function CAddonTemplateGameMode:ExecuteOrderFilter( keys )
	--PrintTable(keys)
	local itemGetter = nil 
	local itemName = ""
	local itemEntity = nil
	if keys.order_type == DOTA_UNIT_ORDER_GIVE_ITEM  then
		print("give item")
    	local target = EntIndexToHScript( keys.entindex_target )
    	itemGetter = target
		itemEntity = EntIndexToHScript(keys.entindex_ability)
		itemName = itemEntity:GetName()
		if itemEntity:IsPermanent() then     
			local __temp = -1
	    	if GameRules.item_sj[item] then
	    		__temp = GameRules.item_sj[item]
	    		GameRules.item_sj[item]=nil
	    	end
	        target:RemoveItem(itemEntity)
		    local item = CreateItem(itemName, target, target)
		    target:AddItem(item)
		    if __temp~=-1 then
		    	GameRules.item_sj[item] = __temp
		    end
		end--[[
	elseif keys.order_type== DOTA_UNIT_ORDER_PICKUP_ITEM or keys.order_type==DOTA_UNIT_ORDER_PURCHASE_ITEM or keys.order_type==DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH then
		--PrintTable(keys)
		itemGetter = EntIndexToHScript( keys.units["0"] )
		itemEntity = EntIndexToHScript(keys.entindex_target)
		print(itemEntity)
		print("pick")
	elseif keys.order_type== DOTA_UNIT_ORDER_SELL_ITEM or keys.order_type==DOTA_UNIT_ORDER_DROP_ITEM then
		local dropSource = EntIndexToHScript( keys.units["0"] )
		local dropItem = EntIndexToHScript(keys.entindex_ability)
		if dropSource and dropSource:IsRealHero() then
			CheckSuitOff(dropSource,dropItem)
		end
		print("drop")]]
	end
	--[[
	if itemGetter and itemGetter:IsRealHero() then
		--print(itemEntity:GetAbilityName())
		local isValid = CheckItemType(itemGetter,itemEntity)

		if isValid then
			CheckSuitOn(itemGetter,itemEntity)
		else
			Notifications:MidLeft(itemGetter:GetPlayerOwnerID(),{text="everyone_has_one_same_item",duration=3,style={color="#580643",["font-size"]="30px"}})
			--target:DropItemAtPositionImmediate(itemEntity,target:GetAbsOrigin())
			return false
		end
	end
	]]
	return true
end


function CAddonTemplateGameMode:OnDamageFilter( args )
	--PrintTable(args)
	local damage = args.damage
	local damageType = args.damagetype_const
	local caster
	--[[if not args.entindex_attacker_const then
		if args.damage == EntIndexToHScript(args.entindex_victim_const):GetMaxHealth() then
			EntIndexToHScript(args.entindex_victim_const):RemoveSelf()
			return
		end
	end--]]
	if args.entindex_attacker_const then
		caster = EntIndexToHScript(args.entindex_attacker_const)
	else
		return
	end	
	-- [[fix intellect cause damage amplify]]
	if args.entindex_inflictor_const then
		if caster:IsRealHero() then
			args.damage = args.damage/(1+((caster:GetIntellect()/16)/100))
		end
	end

	--[[destroy enemy's armor]]
	local victim = EntIndexToHScript(args.entindex_victim_const)
	if caster:HasModifier("modifier_liguanggong_buff") and damageType==DAMAGE_TYPE_PHYSICAL then
		
		local armor = victim:GetPhysicalArmorValue()
		args.damage = damage*(1+0.06*armor)
		--print(args.damage)
	end
	--[[absord magical damage]]
	if victim:HasModifier("modifier_anti_magic") and damageType==DAMAGE_TYPE_MAGICAL then
		if victim.magical_damage_collected==nil then
			victim.magical_damage_collected = 0
		end
		victim.magical_damage_collected = victim.magical_damage_collected + args.damage
		if victim.magical_total_damage then
			if victim.magical_damage_collected>victim.magical_total_damage then
				args.damage = victim.magical_damage_collected - victim.magical_total_damage
				victim:RemoveModifierByName("modifier_anti_magic")
			else
				args.damage = 0
			end
		end
		
	end

	if caster and caster:HasModifier("modifier_ltx_magical_damage_bonus_percent") then
		local hModifier = caster:FindModifierByName("modifier_ltx_magical_damage_bonus_percent")
		if hModifier then
			if damageType and damageType==DAMAGE_TYPE_MAGICAL then
				args.damage = args.damage * hModifier.bonus_percent / 100
			end
		end
	end

	--[[reborn]]
	--[[if victim:HasModifier("modifier_item_reborn") then
		local health = victim:GetHealth()
		if health-damage<=0 then
			local ability = victim:FindAbilityByName("item_nvwashi")
			if ability:IsCooldownReady() then
				local level = ability:GetLevel()
				ability:StartCooldown(ability:GetCooldown(level))
				local duration = ability:GetLevelSpecialValueFor("duration", level-1)
				ability:ApplyDataDrivenModifier(victim,victim,"modifier_item_reborn_particle",{duration=duration})
				return false
			end
		end
	end]]

	if caster:IsRealHero() and caster.damage_ratio then
		args.damage = args.damage * caster.damage_ratio
		-- print("-----------")
		-- print(caster.damage_ratio)
		-- print(args.damage)
		-- print("----------")
	end

	if caster:GetTeamNumber()==DOTA_TEAM_BADGUYS then
		args.damage = args.damage * (0.5+GameRules.diff*0.5)
	end

	return true
end

function CAddonTemplateGameMode:ItemAddedFilter( keys )
	local currentItem = EntIndexToHScript(keys.item_entindex_const)
	--print(keys.item_entindex_const)
	local currentItemName = currentItem:GetAbilityName()
	local currentUnit = EntIndexToHScript(keys.inventory_parent_entindex_const)
	local itemOwner = EntIndexToHScript(keys.item_parent_entindex_const)
	local resultItem = currentItem
	if currentUnit:IsRealHero() then 	-- 英雄拾取
		if not currentItem:IsPermanent() then
			return true
		end
		if itemOwner and itemOwner~= currentUnit then
			--local itemBuyTime = currentItem:GetPurchaseTime()
			local item = CreateItem(currentItemName, currentUnit, currentUnit)
			item.currentUnitName = currentUnit:GetUnitName()
			--item:SetPurchaseTime(itemBuyTime)
			currentUnit:AddItem(item)
			if not currentItem.curIndex then
				currentItem.curIndex = 0
			end

			item.curIndex = currentItem.curIndex
			currentUnit:RemoveItem(currentItem)

			resultItem = item
		end
		
		--[[local isValid = CheckItemType(currentUnit,resultItem)
		
		if isValid then
			CheckSuitOn(currentUnit,resultItem)
		else
			Notifications:MidLeft(currentUnit:GetPlayerOwnerID(),{text="everyone_has_one_same_item",duration=3,style={color="#580643",["font-size"]="30px"}})
			--target:DropItemAtPositionImmediate(item,target:GetAbsOrigin())
			return false
		end]]
	else
		if currentItemName=="item_full_bottle" then
			currentUnit:RemoveItem(currentItem)
			local item = CreateItem("item_empty_bottle", currentUnit, currentUnit)
			currentUnit:AddItem(item)
		end
	end
	return true
end
_G.cdId = 0;
function sendCountDownBarInfo(curTime)
	--[[
		what place here is wave count down time
		0<(time-100)%130<=30

		10-30
	]]
	if (curTime<0) then
		return 
	end
	local subTime = GameRules.global_time - GameRules.global_cdTime
	local curTimeIndex = (curTime-subTime)%GameRules.global_time
	if curTimeIndex>0 and curTimeIndex<=GameRules.global_cdTime  then
		CustomGameEventManager:Send_ServerToAllClients("refresh_countDownBar",{id=_G.cdId,curTime=curTimeIndex,name="no{0}wave",total=GameRules.global_cdTime,params={GameRules.gw_lv}})
	end



	--[[todo other count down bar]]
end

--[[
attach_hitloc: "附着受伤点",
attach_origin: "附着目标",
attach_attack: "附着攻击",
attach_attack1: "附着攻击1",
attach_attack2: "附着攻击2",
follow_origin: "跟随目标",
follow_hitloc: "跟随受伤点",
follow_overhead: "跟随头顶",
follow_chest: "跟随胸部",
follow_head: "跟随头部",
follow_customorigin: "跟随自定义目标",
follow_attachment: "跟随附件",
follow_eyes: "跟随双眼",
follow_attachment_substepped: "跟随附件分步",
follow_renderorigin: "跟随渲染目标",
follow_rootbone: "跟随根骨",
world_origin: "世界中心",
start_at_customorigin: "开始于自定义目标",
start_at_origin: "开始于目标",
start_at_attachment: "开始于附件",
]]