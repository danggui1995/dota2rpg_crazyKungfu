require('libraries/notifications')
function OnGetAbility( data )
	local hCaster = data.caster
	local ability = data.ability
	local hPlayer = hCaster:GetPlayerID()
	local t_abilityName = ability:GetAbilityKeyValues()
	local abilityName = t_abilityName["MyAbilityName"]
	local t_abilityIndex = ability:GetAbilityKeyValues()
	local s_abilityIndex = t_abilityIndex["MyAbilityIndex"]
	local abilityIndex = tonumber(s_abilityIndex)-1
	local abilityEmpty = "ability_empty"..s_abilityIndex
	local hAbility = hCaster:GetAbilityByIndex(abilityIndex)
	if hAbility:GetAbilityName() == abilityName then
		local lv = hAbility:GetLevel()
		if lv==hAbility:GetMaxLevel() then
			Notifications:Bottom(PlayerResource:GetPlayer(hPlayer),{text="#abilityMax",duration=1,style={color="red"},continue=false})
		else
			hAbility:UpgradeAbility(true)
			--hAbility:SetLevel(lv+1)
		end
	else
		if (hCaster:GetAbilityByIndex(abilityIndex)):GetAbilityName()~=abilityEmpty then
			Notifications:Bottom(PlayerResource:GetPlayer(hPlayer),{text="#haveAbility",duration=1,style={color="red"},continue=false})
			hCaster:AddItemByName(ability:GetAbilityName())
		else
			hCaster:RemoveAbility(abilityEmpty)
			hCaster:AddAbility(abilityName)
			local hAbility = hCaster:FindAbilityByName(abilityName)
			hAbility:UpgradeAbility(true)
			--hAbility:SetLevel(1)
		end
	end
end

function OnRemoveAbility( data )
	local hCaster = data.caster
	local ability = data.ability
	local index = data.index
	local abilityEmpty = "ability_empty"..index
	local hAbility = hCaster:GetAbilityByIndex(index-1)
	local hPlayer = hCaster:GetPlayerID()
	if hAbility:GetAbilityName()~=abilityEmpty and hAbility:GetLevel()~=hAbility:GetMaxLevel() then
		local modifierTable = hCaster:FindAllModifiers()
		for k,v in pairs(modifierTable) do
			if v:GetAbility() == hAbility then
				hCaster:RemoveModifierByName(v:GetName())
			end
		end
		hCaster:RemoveAbility(hAbility:GetAbilityName())
		hCaster:AddAbility(abilityEmpty) 
	end
end

function CourierAbility_SellItemAOE(keys)
    local point = keys.target_points[1]
    local hero = (keys.caster:GetPlayerOwner()):GetAssignedHero() 
    local radius = 500
    local ItemTable = Entities:FindAllByClassnameWithin("dota_item_drop",point,radius)
    if ItemTable == nil or hero == nil  then return end
    for _,drop in pairs(ItemTable) do
        local item = drop:GetContainedItem()
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"
                                                        , PATTACH_WORLDORIGIN
                                                        , drop) 
         ParticleManager:SetParticleControl(particle,1,drop:GetOrigin())
          ParticleManager:ReleaseParticleIndex(particle)
        drop:RemoveSelf() 
        local itemSellPrice = (item:GetCost() * 0.5)
        hero:ModifyGold(itemSellPrice, false, 0) 
        hero:EmitSound("General.Sell")
    end
end