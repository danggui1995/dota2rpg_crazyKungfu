function OnYi( data )
	local hCaster = data.caster
	local _rd = RandomInt(101, 125)
	local itemName = "item_ability_".._rd
	hCaster:AddItemByName(itemName)
end

function OnUpdateAbility( data )
	local __index = data.index
	local hCaster = data.caster
	local hAbility = hCaster:GetAbilityByIndex(__index-1)
	if hAbility then
		if hAbility:GetLevel() == hAbility:GetMaxLevel() then
			return
		end
		hAbility:SetLevel(hAbility:GetLevel()+1)
	end
end