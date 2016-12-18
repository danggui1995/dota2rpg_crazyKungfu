--[[ ============================================================================================================
	Author: Rook
	Date: February 2, 2015
	Called when a Battle Fury is acquired.  Grants the cleave modifier if the caster is a melee hero.
================================================================================================================= ]]
function modifier_item_bfury_datadriven_on_created(keys)
	if not keys.caster:IsRangedAttacker() then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_bfury_datadriven_cleave", {duration = -1})
	end
end


--[[ ============================================================================================================
	Author: Rook
	Date: February 2, 2015
	Called when a Battle Fury is removed from the caster's inventory.  Removes a cleave modifier if they are a melee hero.
================================================================================================================= ]]
function modifier_item_bfury_datadriven_on_destroy(keys)
	if not keys.caster:IsRangedAttacker() then
		keys.caster:RemoveModifierByName("modifier_item_bfury_datadriven_cleave")
	end
end