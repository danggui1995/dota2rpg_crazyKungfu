if ItemSystem == nil then
	ItemSystem = {}
	ItemSystem.ItemInfo = {}
	ItemSystem.SynInfo = {}
end

function ItemSystem:Init()
	local GameMode = GameRules:GetGameModeEntity() 
	--ItemSystem.hct = LoadKeyValues("scripts/kv/item_hc.kv")
	--[[
	for k,v in pairs(self.SetInfo) do
		for _,modifier_name in pairs(v.modifiers) do
			LinkLuaModifier(modifier_name,"abilities/modifiers/"..modifier_name..".lua", LUA_MODIFIER_MOTION_NONE)
		end
	end]]
	ListenToGameEvent("dota_item_picked_up",Dynamic_Wrap(ItemSystem, "OnItemPickedUp"),self)
end

function ItemSystem:OnItemPickedUp( keys )
	if keys.HeroEntityIndex == nil then
		return
	end
    local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
    local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    local itemname = keys.itemname
    if itemEntity:IsPermanent() then       
    	for i=0,5 do
	        local item = heroEntity:GetItemInSlot(i)
            if itemEntity == item then
            	local __temp = -1
            	if GameRules.item_sj[item] then
            		__temp = GameRules.item_sj[item]
            		GameRules.item_sj[item]=nil
            	end
	            heroEntity:RemoveItem(itemEntity)
			    local item = CreateItem(itemname, heroEntity, heroEntity)
			    heroEntity:AddItem(item)
			    if __temp~=-1 then
			    	GameRules.item_sj[item] = __temp
			    end
	            break
	        end
	    end
	end
end

function ItemSystem:OnItemCompose( hero )
	if not hero then return end
	local CurPlayerItem = {}
	PrintTable(ItemSystem.hct[itemName])
	local CurItemSynInfo = ItemSystem.hct[itemName]
	if CurItemSynInfo == nil then print("Invalid Item") return end
	local PlayerSynInfo = {}
	for itemN,num in pairs(CurItemSynInfo) do
		local BeFound = false
		for i =0,5 do
			local itemEnt=hero:GetItemInSlot(i)
			if itemEnt~=nil then 
				if itemN == itemEnt:GetName() then
					local count = itemEnt:GetCurrentCharges() 
					if PlayerSynInfo[itemN] == nil then PlayerSynInfo[itemN] = 0 end
					if count == 0 then count = count+1 end
					CurPlayerItem[i] = true
					PlayerSynInfo[itemN] = PlayerSynInfo[itemN] + count -- 如果匹配到了 记录下来数量 
					BeFound = true 
				end
			end
		end
		if BeFound == false then
			print(itemN .. " is not found")
			 PlayerSynInfo[itemN] = 0
		end
	end
	for ItemName,Num in pairs(CurItemSynInfo) do
		if  PlayerSynInfo[ItemName] == nil or CurItemSynInfo[ItemName] >  PlayerSynInfo[ItemName] then
			print("Player has " .. ItemName .."  ".. PlayerSynInfo[ItemName]..",but required ".. CurItemSynInfo[ItemName])
			FireGameEvent("custom_error_show", {player_ID = i,_error = "#CantSyn"}) 
			return
		end
	end
	CurItemSynInfo = table.deepcopy(ItemSystem.SynInfo[itemName])
	for i = 0,5 do
		local itemEnt=hero:GetItemInSlot(i)
		
		if itemEnt~=nil then 
			local ItemName = itemEnt:GetName()
			if ItemName == itemEnt:GetName() then
				if CurItemSynInfo[ItemName] > 0 then
					local count = itemEnt:GetCurrentCharges() 
					if count == 0 then count = count +1 end
					if CurItemSynInfo[ItemName] >= count then --如果数量少于需求
						hero:RemoveItem(itemEnt)
						CurItemSynInfo[ItemName] = CurItemSynInfo[ItemName] - count
					else --如果大于要求
						itemEnt:SetCurrentCharges(count - CurItemSynInfo[ItemName]) 
						CurItemSynInfo[ItemName] = 0			
					end
				end
			end
		end
	end

	local item = CreateItem(itemName,nil,nil)
	hero:AddItem(item)
end

function CDOTA_BaseNPC:FindItem( itemname )
	if IsValidEntity(self) then
		for i=0,12 do
			local item = self:GetItemInSlot(i)
			if item then
				if item:GetAbilityName() == itemname then
					return item
				end
			end
		end
	end
end