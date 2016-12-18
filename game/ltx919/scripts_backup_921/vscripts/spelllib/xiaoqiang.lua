--[[
	Author: kritth
	Date: 10.01.2015.
	Init the table
]]
function spiked_carapace_init( keys )
	keys.caster.carapaced_units = {}
end

--[[
	Author: kritth
	Date: 10.01.2015.
	Reflect damage
]]
function spiked_carapace_reflect( keys )
	-- Variables
	local caster = keys.caster
	local attacker = keys.attacker
	local damageTaken = keys.DamageTaken
	
	-- Check if it's not already been hit
	if not caster.carapaced_units[ attacker:entindex() ] and not attacker:IsMagicImmune() then
		if attacker:GetHealth()>damageTaken then
			attacker:SetHealth( attacker:GetHealth() - damageTaken )
		else
			attacker:SetHealth( 1 )
		end
		keys.ability:ApplyDataDrivenModifier( caster, attacker, "modifier_spiked_carapaced_stun_datadriven", { } )
		caster:SetHealth( caster:GetHealth() + damageTaken )
		caster.carapaced_units[ attacker:entindex() ] = attacker
	end
end

--[[
	Author: kritth
	Date: 11.01.2015.
	If attack item, shouldn't be dispell, else remove modifier
]]
function vendetta_attack( keys )
	if not keys.target:IsUnselectable() or keys.target:IsUnselectable() then		-- This is to fail check if it is item. If it is item, error is expected
		-- Variables
		local caster = keys.caster
		local target = keys.target
		local ability = keys.ability
		local modifierName = "modifier_vendetta_buff_datadriven"
		local abilityDamage = ability:GetLevelSpecialValueFor( "bonus_damage", ability:GetLevel() - 1 )
		local abilityDamageType = ability:GetAbilityDamageType()
	
		-- Deal damage and show VFX
		local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( fxIndex, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( fxIndex, 1, target:GetAbsOrigin() )
		
		StartSoundEvent( "Hero_NyxAssassin.Vendetta.Crit", target )
		
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = abilityDamage,
			damage_type = abilityDamageType
		}
		ApplyDamage( damageTable )
		
		keys.caster:RemoveModifierByName( modifierName )
	end
end