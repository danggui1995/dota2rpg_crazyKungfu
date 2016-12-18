require('utils/abilityUtils')
print("SWJG")
function OnRespawnUnit( event )
	local target = event.target 
	local hCaster = event.caster  

	local ability = event.ability
	target:RespawnUnit()
	target:SetOwner(hCaster)
	target:SetControllableByPlayer(hCaster:GetPlayerOwnerID(),true)
	target:AddNewModifier(hCaster,ability,"modifier_killed",{duration = event.duration})
	ability:ApplyDataDrivenModifier(hCaster,target,"modifier_xingtiandun_particle",{})

end

function OnForceAttack( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local t_order = 
    {                                       
        UnitIndex = target:entindex(), 
        OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
        TargetIndex = hCaster:entindex()
    }
	tUnit:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.1)
end

function OnJiuTianXuanNvZhangMana( event )
	local hCaster = event.caster
	local ability = event.event_ability 
	if ability:IsItem() then
		local maxmana = hCaster:GetMaxMana()
		hCaster:SetMana(maxmana)
	end
end

function OnSpawnImage( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	if not target:IsRealHero() then
		local data={
			unitname = target:GetUnitName(),
			owner = hCaster,
			pos = target:GetAbsOrigin(),
			team = hCaster:GetTeamNumber(),
			duration = event.duration,
			move = getMoveCapability(target)
		 }
		OnZhaoHuan(data)
	end
end

function StartAbilityGesture( event )
	local hCaster = event.caster
	local ability = event.ability
	hCaster:StartGesture(ACT_DOTA_ATTACK_EVENT)
end

function OnMofaWaike( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	target.magical_damage_collected = 0
	target.magical_total_damage = event.total_damage
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
function MyContains( __table,__value )
	for k,v in pairs(__table) do
		if v==__value then
			return true
		end
	end
	return false
end
function searchSuit(hero)

	for k,v in pairs(GameRules.SuitTable) do
		--print(k)
		--print(v["ItemSets"]["1"])
		local checked_table = {}
		local bHasForged = true
		for _k,_v in pairs(v["ItemSets"]) do
			--print(_v)
			local bHasPart = false 
			for i=0,5 do
				if not MyContains(checked_table,i) then
					local _item = hero:GetItemInSlot(i)
					--print(_item)
					if _item then
						local _itemName = _item:GetAbilityName()
						if _v==_itemName then
							--print(_v)
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
			--print(k)
			return k 
		end
	end
	return false
end


function OnItemEquiped( event )
	local caster = event.caster
	local item = event.ability
	if caster and caster:IsRealHero() then
		local bTypeCheck = CheckItemType(caster,item)
		if bTypeCheck then
			SwitchItemType(caster,item,1)
			CheckSuitOn(caster,item)
			OnAddItem(event)
		else
			Notifications:MidLeft(caster:GetPlayerOwnerID(),{text="everyone_has_one_same_item",duration=3,style={color="#580643",["font-size"]="20px"}})
			DropItem(caster,item)
			-- item.ForceRemove = true
			-- caster:DropItemAtPosition(RandomVector(100) +caster:GetOrigin(),item)
		end
	end
end
function DropItem( hero, item )
    -- Error Sound
    EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", hero:GetPlayerOwner())

    -- Create a new empty item
    local newItem = CreateItem( item:GetAbilityName(), nil, nil )

    -- This is needed if you are working with items with charges, uncomment it if so.
    -- newItem:SetCurrentCharges( goldToDrop )

    -- Make a new item and launch it near the hero
    local spawnPoint = Vector( 0, 0, 0 )
    spawnPoint = hero:GetAbsOrigin()
    local drop = CreateItemOnPositionSync( spawnPoint, newItem )
    newItem:LaunchLoot( false, 200, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 150 ) ) )
    newItem.curIndex = item.curIndex
  
    --finally, remove the item
    item.ForceRemove = true
    hero:RemoveItem(item)
 
    return newItem
end

function OnItemUnequiped( event )
	local caster = event.caster
	local item = event.ability
	if item.ForceRemove then
		item.ForceRemove = false
		return 
	end
	if caster and caster:IsRealHero() then
		SwitchItemType(caster,item,0)
		CheckSuitOff(caster)
	end
end

function SwitchItemType( caster,item,option )

	local itemName = item:GetAbilityName()
	local namelength = string.len(itemName)
	local item_type = string.sub(itemName,namelength-4+1,namelength)
	if item_type=="wuqi" then
		caster.equip[1]=option
	elseif item_type=="yifu" then
		caster.equip[2]=option
	elseif item_type=="touk" then
		caster.equip[3]=option
	elseif item_type=="xiez" then
		caster.equip[4]=option
	end
end

function CheckItemType( caster,item )
	local itemName = item:GetAbilityName()
	local namelength = string.len(itemName)
	local item_type = string.sub(itemName,namelength-4+1,namelength)
	--print(item_type)
	if item_type=="wuqi" then
		if caster.equip[1]==1 then
			return false
		end
	elseif item_type=="yifu" then
		if caster.equip[2]==1 then
			return false
		end
	elseif item_type=="touk" then
		if caster.equip[3]==1 then
			return false
		end
	elseif item_type=="xiez" then
		if caster.equip[4]==1 then
			return false
		end
	end
	return true
end

function CheckSuitOn( caster,item )
	caster:SetContextThink("searchSuit",
	function()
		local ability = searchSuit(caster)
		
		if ability then
			for k,v in pairs(GameRules.SuitTable[ability]) do
				local flag = false 
				for _k,_v in pairs(v) do
					if _v==item:GetAbilityName() then
						if caster:FindAbilityByName("ability_empty5") then
							caster:RemoveAbility("ability_empty5")
							caster:AddAbility(ability)
							local _ability = caster:FindAbilityByName(ability)
							if _ability then
								_ability:SetLevel(1)
							end
						end
						local playerId = caster:GetPlayerOwnerID()
						Notifications:MidLeft(playerId,{text=PlayerResource:GetPlayerName(playerId),duration=3,style={color="#580643",["font-size"]="30px"}})
						Notifications:MidLeft(playerId,{text="collected",duration=3,style={color="#580643",["font-size"]="30px"},continue=true})
						Notifications:MidLeft(playerId,{text=ability,duration=3,style={color="#580643",["font-size"]="30px"},continue=true})
						flag = true 
						break
					end
					
				end
				if flag then
					break
				end
			end
		end
	end,0.01)
	
	--[[
	if __item then
		local __itemName = __item:GetAbilityName()
		for k,v in pairs(GameRules.tzsx) do
			if string.find(__itemName,k,1)~=nil then
				if not caster.tzsx then
					caster.tzsx = {}
				end
				if not caster.tzsx[k] then
					caster.tzsx[k] = 0
				end
				caster.tzsx[k] = caster.tzsx[k] + 1
				if caster.tzsx[k] == v[1] then
					
					return 
				end
			end
		end
	end]]
end

function BeforeRemoveAbility( hCaster,ability )
	local abilityEmpty = "ability_empty5"
	
	local modifierTable = hCaster:FindAllModifiers()
	for k,v in pairs(modifierTable) do
		if v:GetAbility() == ability then
			hCaster:RemoveModifierByName(v:GetName())
		end
	end
end

function CheckSuitOff( caster )
	if not searchSuit(caster) then
		local ability = caster:GetAbilityByIndex(4)
		if ability:GetAbilityName()~="ability_empty5" then
			BeforeRemoveAbility(caster,ability)
			caster:RemoveAbility(ability:GetAbilityName())
			caster:AddAbility("ability_empty5")
		end
	end
	--[[
	if __item then
		local __itemName = __item:GetAbilityName()
		for k,v in pairs(GameRules.tzsx) do
			if string.find(__itemName,k,1)~=nil then
				if not caster.tzsx then
					caster.tzsx = {}
				end
				if not caster.tzsx[k] then
					caster.tzsx[k] = 0
				end
				caster.tzsx[k] = caster.tzsx[k] - 1
				
			end
		end
	end
]]
end

function OnAddItem( data )
	local hItem = data.ability 
	if not hItem.curIndex then
		hItem.curIndex = 0
	end
end

function OnBlink(event)
	local hCaster = event.caster
	local point = event.point
end

function OnCreateSH( event )
	local hCaster = event.caster
	local name1 =event.name 
	local totalname = "npc_shenghen_"..name1.."1"
	local data = {}
	data.unitname=totalname
	data.owner=hCaster
	data.pos=hCaster:GetAbsOrigin()
	data.team=hCaster:GetTeamNumber()
	local unit = OnZhaoHuan( data)
end

function OnGuanJin3( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target 
	local mana_spend = event.mana_spend
	local curMana = target:GetMana()
	if curMana>mana_spend then
		target:SetMana(curMana-mana_spend)
	else
		target:SetMana(0)
	end
end

function OnBiDuzhuEquiped( event )
	local item = event.ability
	item.bdz_counter = event.bdz_counter
end