
function ui_event_init()
	-- 物品从背包中丢出
	CustomGameEventManager:RegisterListener("hsj_ui_event_backpack_drop_item",OnHSJ_UI_BackpackDropItem)

	-- 背包物品对换位置
	CustomGameEventManager:RegisterListener("hsj_ui_event_backpack_swap_pos",OnHSJ_UI_BackpackSwapPosition)

	-- 捡起物品
	CustomGameEventManager:RegisterListener("hsj_ui_event_backpack_right_click_item",OnHSJ_UI_RightClickItem)

	-- 丢弃物品
	CustomGameEventManager:RegisterListener("hsj_ui_event_backpack_menu_drop_item",OnHSJ_UI_BackpackMenuDropItem)

	-- 出售物品
	CustomGameEventManager:RegisterListener("hsj_ui_event_backpack_menu_sell_item",OnHSJ_UI_BackpackMenuSellItem)

	-- 放置到末尾
	CustomGameEventManager:RegisterListener("hsj_ui_event_backpack_item_pos_to_end",OnHSJ_UI_BackpackItemPosToEnd)

	-- 打开礼物
	CustomGameEventManager:RegisterListener("hsj_ui_event_open_gift",OnHSJ_UI_OpenGift)

	-- 丢弃物品
	CustomGameEventManager:RegisterListener("hsj_ui_event_dota_drop_item",OnHSJ_UI_DotaDropItem)

	-- 背包交互
	CustomGameEventManager:RegisterListener("hsj_ui_event_backpack_update_backpack",OnHSJ_UI_BackpackUpdateBackpack)

end

-- 扣钱
function SubGold( PlayerID,gold )
	if PlayerResource:GetGold(PlayerID) >= gold then
		local unreliable_gold = PlayerResource:GetUnreliableGold(PlayerID)
		local sub = unreliable_gold - gold

		if sub < 0 then
			PlayerResource:SetGold(PlayerID, 0, false)

			local reliable_gold = PlayerResource:GetReliableGold(PlayerID)
			PlayerResource:SetGold(PlayerID, reliable_gold + sub, true)
		else
			PlayerResource:SetGold(PlayerID, sub, false)
		end

		return true
	end
	return false
end

-- 判断物品栏已满
function UIIsItemFull( unit )

	if not unit:HasInventory() then
		return nil
	end

	local num = 0
	for i=0,5 do
		if unit:GetItemInSlot(i) ~= nil then
			num = num + 1
		end
	end
	if num < 6 then
		return true
	else
		return false
	end
end

-- 删除物品
function UIRemoveItemByName( unit,itemname )
	for i=0,5 do
		local item = unit:GetItemInSlot(i)
		if item then
			if item:GetAbilityName() == itemname then
				return item
			end
		end
	end
end

-- 判断物品栏是否有物品
function UIHasItem( unit, item )
	for i=0,5 do
		local itemSlot = unit:GetItemInSlot(i)
		if itemSlot == item then
			return true
		end
	end
	return false
end

-- 购买物品
function UIBuyItem( event,data )
	if data.entindex and data.entindex ~= -1 and data.info then
		local unit = EntIndexToHScript(data.entindex)
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player ~=nil and unit ~= nil then

			-- 判断购买者
			-- if not Shops:HasInHome(unit) and not Shops:HasInSide(unit) then
			-- 	return
			-- end

			-- 判断物品栏
			local buy = not Backpack:IsFull( unit )
			if buy == nil then
				data.text="#not_inventory"
				SendErrorMsg(event,data)
				return
			elseif buy == false then
				data.text="#dota_hud_error_cant_purchase_inventory_full"
				SendErrorMsg(event,data)
				return
			end 

			-- 判断是否需要子物品
			local itemChild = nil
			if data.info.NeedItem then
				for k,v in pairs(data.info.NeedItem) do
					
					if unit:HasItemInInventory(v) then
						itemChild = v
					end
					
					break
				end
			else
				itemChild = true;
			end

			-- 删除子物品
			if not itemChild then
				data.text="#upgrade_item_fail"
				SendErrorMsg(event,data)
				return
			elseif itemChild ~= true then
				local hOldItem = UIRemoveItemByName(unit,itemChild)
				unit:RemoveItem(hOldItem)

				-- 返回金钱
				local gold = GetItemCost(itemChild)
				local unreliable_gold = PlayerResource:GetUnreliableGold(data.PlayerID)
				PlayerResource:SetGold(data.PlayerID, unreliable_gold + gold, false)
			end

			local gold = GetItemCost( data.info.name )

			if SubGold( data.PlayerID, gold ) then
				Backpack:CreateItem( unit, data.info.name )
			else
				data.text="#dota_hud_error_not_enough_gold"
				SendErrorMsg(event,data)
			end
		end
	else
		data.text="#dota_hud_error_cant_sell_shop_not_in_range"
		SendErrorMsg(event,data)
	end
end

-- 升级物品
function UIUpgradeItem( event,data )
	if data.entindex then
		local unit = EntIndexToHScript(data.entindex)
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player ~=nil and unit ~= nil then

			-- 判断物品栏
			local buy = UIIsItemFull(unit)
			if buy == nil then
				data.text="#not_inventory"
				SendErrorMsg(event,data)
				return
			end

			-- 判断是否有物品
			if not unit:HasItemInInventory(data.itemChildName) then
				data.text="#upgrade_item_fail"
				SendErrorMsg(event,data)
				return
			end

			local gold = GetItemCost( data.itemName )

			if SubGold( data.PlayerID, gold ) then
				local hOldItem = UIRemoveItemByName(unit,data.itemChildName)
				local cost = hOldItem.m_ChildrenCost or 0
				unit:RemoveItem(hOldItem)

				local item = CreateItem(data.itemName, nil, nil)
				item.m_ChildrenCost = cost + GetItemCost( data.itemChildName )
				print(item.m_ChildrenCost)
			else
				data.text="#dota_hud_error_not_enough_gold"
				SendErrorMsg(event,data)
			end
		end
	end
end

-- 发送错误消息
function SendErrorMsg( event,data )
	CustomGameEventManager:Send_ServerToPlayer(
		PlayerResource:GetPlayer(data.PlayerID),
		"avalon_game_ui_show_bottom_message",
		{text=data.text,r=255,g=0,b=0})
end

function SendErrorMsgBox( event,data )
	CustomGameEventManager:Send_ServerToPlayer(
		PlayerResource:GetPlayer(data.PlayerID),
		"avalon_game_ui_add_message",
		{text=data.text,npc="#avalon_game_ui_message_npc_system"})
	
end

-- 取消修理
function CloseHealHeroShipClose( event,data )
	if data.entindex then
		local unit = EntIndexToHScript(data.entindex)
		if unit then
			unit._No_HealHeroShip = true
			unit:RemoveModifierByName("modifier_BaseHealHeroShip_heal_effect")
		end
	end
end

-- 强化
function OnHSJ_UI_StrengthenItem( event,data )
	if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" then
		local item = EntIndexToHScript(data.itemIndex)
		if item == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end

		if UIHasItem(hero,item) then
			SubGold(data.PlayerID,200)
			OnCourierEnhanceSpellStart({caster=hero,item=item})

		else
			local hasItem,packIndex = Backpack:HasItem(hero,item:GetEntityIndex())

			if hasItem then
				SubGold(data.PlayerID,200)
				OnCourierEnhanceSpellStart({caster=hero,item=item})
			end
		end

	end
end

-- 强化的材料
function OnHSJ_UI_StrengthenItemMaterial( event,data )
	if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" then
		local item = EntIndexToHScript(data.itemIndex)
		if item == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local materialItemName = GetItemMaterialName(item)

		CustomGameEventManager:Send_ServerToPlayer(player,"hsj_ui_event_strengthen_item_material_return",{itemname=materialItemName}) 

	end
end

-- 分解
function OnHSJ_UI_DecomposeItem( event,data )
	if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" then
		local item = EntIndexToHScript(data.itemIndex)
		if item == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end

		if UIHasItem(hero,item) then
			OnCourierDecomposeSpellStart({caster=hero,item=item})
		else
			local hasItem,packIndex = Backpack:HasItem(hero,item:GetEntityIndex())

			if hasItem then
				OnCourierDecomposeSpellStart({caster=hero,item=item})
			end
		end

	end
end

-- 分解后的材料
function OnHSJ_UI_DecomposeItemMaterial( event,data )
	if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" then
		local item = EntIndexToHScript(data.itemIndex)
		if item == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local materialItemName = GetItemMaterialName(item)

		CustomGameEventManager:Send_ServerToPlayer(player,"hsj_ui_event_decompose_item_material_return",{itemname=materialItemName}) 

	end
end

-- 合成
function OnHSJ_UI_ComposeItem( event,data )
	if GameRules:IsGamePaused() then return end
	if type(data.source) ~= "string" then return end

	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	local dataTable = nil
	if data.isGem == 0 then
		dataTable = item_compose_table
	else
		dataTable = item_gem_compose_table
	end

	if dataTable == nil then return end

	local composeInfo = dataTable[data.source]

	-- 无效配方
	if composeInfo == nil then
		data.text = "#hsj_ui_event_compose_item_invaild";
		SendErrorMsgBox(event,data)
		return 
	end

	local isComposed = false
	local composeItem = {}
	local item

	for k1,v1 in pairs(composeInfo["requestItem"]) do

		Backpack:Traverse( hero, function(pack,packIndex,itemIndex)
			local packItem = EntIndexToHScript(itemIndex)
			if packItem then
				local isChecked = false
				for k3,v3 in pairs(composeItem) do
					if packItem == v3 then
						isChecked = true
					end
				end
				if packItem:GetAbilityName() == v1 and (not isChecked) then
					table.insert(composeItem,packItem)
					return true
				end
			end
		end )

		for item_slot = 0,5 do
			item = hero:GetItemInSlot(item_slot)
			if item ~= nil then
				local isChecked = false
				for k3,v3 in pairs(composeItem) do
					if item == v3 then
						isChecked = true
					end
				end
				if item:GetAbilityName() == v1 and (not isChecked) then
					table.insert(composeItem,item)
					break
				end
			end
		end
	end

	if (#composeItem) == (#composeInfo["requestItem"]) then
				
		for k2,v2 in pairs(composeItem) do
			if UIHasItem(hero,v2) then
				hero:RemoveItem(v2)
			else
				Backpack:ConsumeItem(hero,v2)
			end
		end

		Backpack:CreateItem( hero, composeInfo["composeItem"] )

		isComposed = true
	else
		data.text = "#hsj_ui_event_compose_item_not_enough";
		SendErrorMsgBox(event,data)
	end

	if isComposed then
		local gold = PlayerResource:GetGold(data.PlayerID)
		if gold >= 2000 then
			SubGold(data.PlayerID,2000)
		else
			return
		end
	end

end

-- 自动寻路
function OnHSJ_UI_AutoSearchPath( event,data )
	if GameRules:IsGamePaused() then return end
	if type(data.QuestName) == "string" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		
		hsj_MoveToQuestTarget(hero,data.QuestName)
	end
end

-- 物品从背包中丢出
function OnHSJ_UI_BackpackDropItem( event,data )
	if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" and type(data.unitIndex) == "number" and type(data.pos_x) == "number" and type(data.pos_y) == "number" and type(data.pos_z) == "number" then
		local unit = EntIndexToHScript(data.unitIndex)
		if unit == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		
		local item = EntIndexToHScript(data.itemIndex)

		Backpack:DropItemToOtherUnitPosition(hero, unit, item, Vector(data.pos_x,data.pos_y,data.pos_z))
		
		
	end
end

-- 背包物品对换位置
function OnHSJ_UI_BackpackSwapPosition( event,data )
	if GameRules:IsGamePaused() then return end
	if type(data.packIndex1) == "number" and type(data.packIndex2) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		
		Backpack:SwapItem( hero, data.packIndex1, data.packIndex2 )
	end
end

-- 捡起物品
function OnHSJ_UI_RightClickItem( event,data )
	if type(data.unitIndex) == "number" and type(data.targetIndex) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end
		
		local unit = EntIndexToHScript(data.unitIndex)
		local target = EntIndexToHScript(data.targetIndex)

		if unit == nil or target == nil then return end
		if target:GetClassname() ~= "dota_item_drop" then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end

		if hero ~= unit and unit:GetUnitName() == "unit_courier" then
			if (unit:GetOrigin() - target:GetOrigin()):Length2D() <= 150 then
				local item = target:GetContainedItem()

				Backpack:AddItem( hero, item )
			end
		else
			if hero:GetNumItemsInInventory() >= 6 and (hero:GetOrigin() - target:GetOrigin()):Length2D() <= 150 then
				local item = target:GetContainedItem()

				Backpack:AddItem( hero, item )
			end
		end
		
			
	end
end

-- 丢弃物品
function OnHSJ_UI_BackpackMenuDropItem( event,data )
	if type(data.itemIndex) == "number" and type(data.unitIndex) == "number" then
		local unit = EntIndexToHScript(data.unitIndex)
		if unit == nil then return end

		local item = EntIndexToHScript(data.itemIndex)
		if item == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		
		Backpack:DropItemToOtherUnit( hero, unit, item )
	end
end

function OnHSJ_UI_BackpackMenuSellItem( event,data )
	if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" then
		local item = EntIndexToHScript(data.itemIndex)
		if item == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		
		Backpack:SellItem( hero, item )
	end
end

function OnHSJ_UI_BackpackItemPosToEnd( event,data )
	if type(data.packIndex) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		
		Backpack:ItemPosToEnd( hero, data.packIndex )
	end
end

function OnHSJ_UI_OpenGift( event,data )
	if type(data.itemIndex) == "number" then
		local ItemAbility = EntIndexToHScript(data.itemIndex)
		if ItemAbility == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end

		local hasItem = Backpack:HasItem(hero,data.itemIndex)
		if not hasItem then return end

		local itemName = ItemAbility:GetAbilityName()

		if itemName == "item_1012" then

			if hero:IsHero() then
				if ItemAbility:IsItem() then
					local randomInt = RandomInt(0, 100)
					Backpack:ConsumeItem(hero,ItemAbility)

					if randomInt <= 20 then
						hero:SetBaseStrength(hero:GetBaseStrength()+50)
						hero:SetBaseAgility(hero:GetBaseAgility()+50)
						hero:SetBaseIntellect(hero:GetBaseIntellect()+50)

						data.text = "#chrismas_bonus_attribute";
						SendErrorMsgBox(event,data)
						-- CPlayerMessage:SendMessage(hero:GetEntityIndex(),"#chrismas_bonus_attribute")
					elseif randomInt <= 40 and randomInt > 20 then
						data.text = "#chrismas_bonus_merits";
						SendErrorMsgBox(event,data)
						-- CPlayerMessage:SendMessage(hero:GetEntityIndex(),"#chrismas_bonus_merits")

						local merits = hero:GetContext("hsj_hero_merits")
						hero:SetContextNum("hsj_hero_merits", merits + 200, 0)
					elseif randomInt <= 60 and randomInt > 40 then
						hero:ModifyGold(1000,true,DOTA_ModifyGold_Unspecified)

						data.text = "#chrismas_bonus_gold";
						SendErrorMsgBox(event,data)
						-- CPlayerMessage:SendMessage(hero:GetEntityIndex(),"#chrismas_bonus_gold")
					elseif randomInt <= 80 and randomInt > 60 then
						hero:AddExperience(3000,false,true)

						data.text = "#chrismas_bonus_exp";
						SendErrorMsgBox(event,data)
						-- CPlayerMessage:SendMessage(hero:GetEntityIndex(),"#chrismas_bonus_exp")
					elseif randomInt <= 98 and randomInt > 80 then

						Backpack:CreateItem(hero,"item_0062")
						Backpack:CreateItem(hero,"item_0063")
						Backpack:CreateItem(hero,"item_0064")

						-- local item = CreateItem("item_0062", hero:GetPlayerOwner(), hero:GetPlayerOwner())
						-- hero:AddItem(item)
						-- item = CreateItem("item_0063", hero:GetPlayerOwner(), hero:GetPlayerOwner())
						-- hero:AddItem(item)
						-- item = CreateItem("item_0064", hero:GetPlayerOwner(), hero:GetPlayerOwner())
						-- hero:AddItem(item)

						data.text = "#chrismas_bonus_equip";
						SendErrorMsgBox(event,data)
						-- CPlayerMessage:SendMessage(hero:GetEntityIndex(),"#chrismas_bonus_equip")
					elseif randomInt <= 100 and randomInt > 98 then
						ModifyEquipMulti(hero,2,nil)

						data.text = "#chrismas_bonus_equip_state";
						SendErrorMsgBox(event,data)
						-- CPlayerMessage:SendMessage(hero:GetEntityIndex(),"#chrismas_bonus_equip_state")
					end
				end
			end
		elseif itemName == "item_1011" then
			if hero:IsHero() then
				if ItemAbility:IsItem() then
					local itemKind = GetHeroItemKind(hero)
					Backpack:ConsumeItem(hero,ItemAbility)
					if itemKind == ITEM_KIND_SWORD then
						-- local item = CreateItem("item_0230", hero:GetPlayerOwner(), hero:GetPlayerOwner())
						-- hero:AddItem(item)
						Backpack:CreateItem(hero,"item_0230")
					elseif itemKind == ITEM_KIND_KNIFE then
						-- local item = CreateItem("item_0254", hero:GetPlayerOwner(), hero:GetPlayerOwner())
						-- hero:AddItem(item)
						Backpack:CreateItem(hero,"item_0254")
					elseif itemKind == ITEM_KIND_STICK then
						-- local item = CreateItem("item_0242", hero:GetPlayerOwner(), hero:GetPlayerOwner())
						-- hero:AddItem(item)
						Backpack:CreateItem(hero,"item_0242")
					elseif itemKind == ITEM_KIND_MAGIC then
						-- local item = CreateItem("item_0266", hero:GetPlayerOwner(), hero:GetPlayerOwner())
						-- hero:AddItem(item)
						Backpack:CreateItem(hero,"item_0266")
					elseif itemKind == ITEM_KIND_BOW then
						-- local item = CreateItem("item_0278", hero:GetPlayerOwner(), hero:GetPlayerOwner())
						-- hero:AddItem(item)
						Backpack:CreateItem(hero,"item_0278")
					end
				end
			end
		end
	end
end

function OnHSJ_UI_DotaDropItem( event,data )
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	Backpack:ComposeItemsRefresh(hero)
end

function OnHSJ_UI_BackpackUpdateBackpack( event,data )
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	for i=1,BackpackConfig.MaxItem do
		Backpack:UpdateItem( hero, i )
	end
end

ui_event_init()