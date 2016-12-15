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
	local data={
		unitname = target:GetUnitName(),
		owner = hCaster,
		pos = target:GetAbsOrigin(),
		team = hCaster:GetTeamNumber(),
		duration = event.duration,
		move = getMoveCapability(target),
		image = true
	 }
	onImage(data)

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
		end
	end
end
function DropItem( hero, item )
    -- Error Sound
    EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", hero:GetPlayerOwner())

    -- Create a new empty item
    local newItem = CreateItem( item:GetName(), nil, nil )
    newItem:SetPurchaseTime(item:GetPurchaseTime())

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
		return 
	end

	if caster and caster:IsRealHero() then
		SwitchItemType(caster,item,0)
		CheckSuitOff(caster,item)
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

function CheckSuitOn( caster,__item )
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
					if caster:FindAbilityByName("ability_empty5") then
						caster:RemoveAbility("ability_empty5")
						caster:AddAbility(v[2])
						local _ability = caster:FindAbilityByName(v[2])
						if _ability then
							_ability:SetLevel(1)
						end
					end
					local playerId = caster:GetPlayerOwnerID()
					Notifications:MidLeft(playerId,{text=PlayerResource:GetPlayerName(playerId),duration=3,style={color="#580643",["font-size"]="30px"}})
					Notifications:MidLeft(playerId,{text="collected",duration=3,style={color="#580643",["font-size"]="30px"},continue=true})
					Notifications:MidLeft(playerId,{text=v[2],duration=3,style={color="#580643",["font-size"]="30px"},continue=true})
					return 
				end
			end
		end
	end
end

function CheckSuitOff( caster,__item )

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
				if caster:HasAbility(v[2]) then
					caster:RemoveAbility(v[2])
					caster:AddAbility("ability_empty5")
				end
			end
		end
	end

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