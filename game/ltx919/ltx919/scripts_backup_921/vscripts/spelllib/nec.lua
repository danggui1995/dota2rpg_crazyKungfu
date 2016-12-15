--[[Author: Pizzalol
	Date: 11.07.2015.
	Deals damage based on the max HP of the target]]
function HeartstopperAura( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local target_max_hp = target:GetMaxHealth() / 100
	local aura_damage = ability:GetLevelSpecialValueFor("aura_damage", (ability:GetLevel() - 1))
	local aura_damage_interval = ability:GetLevelSpecialValueFor("aura_damage_interval", (ability:GetLevel() - 1))

	--[[ Shows the debuff on the target's modifier bar only if Necrophos is visible
	local visibility_modifier = keys.visibility_modifier
	if target:CanEntityBeSeenByMyTeam(caster) then
		ability:ApplyDataDrivenModifier(caster, target, visibility_modifier, {})
	else
		target:RemoveModifierByName(visibility_modifier)
	end]]

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = DAMAGE_TYPE_PURE
	damage_table.ability = ability
	damage_table.damage = target_max_hp * -aura_damage * aura_damage_interval
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS -- Doesnt trigger abilities and items that get disabled by damage

	ApplyDamage(damage_table)
end

--[[Author: Pizzalol
	Date: 06.01.2015.
	Deals damage depending on missing hp
	If the target dies then it increases the respawn time]]
function ReapersScythe( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local target_missing_hp = target:GetMaxHealth() - target:GetHealth()
	local damage_per_health = ability:GetLevelSpecialValueFor("damage_per_health", (ability:GetLevel() - 1))

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = target_missing_hp * damage_per_health

	ApplyDamage(damage_table)

end