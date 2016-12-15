--[[
	CHANGELIST:
	09.01.2015 - Standized variables
]]

--[[
	Author: kritth
	Date: 8.1.2015.
	Initialize linked list for multiple instances of damage
]]

require('libraries/timers')
function arcane_bolt_init( keys )
	local caster = keys.caster
	local intelligence = keys.caster:GetIntellect()
	if caster.arcane_bolt_list_head == nil then
		caster.arcane_bolt_list_tail = {}
		caster.arcane_bolt_list_head = { next = caster.arcane_bolt_list_tail, value = intelligence }
	else
		local tmp = {}
		caster.arcane_bolt_list_tail.next = tmp
		caster.arcane_bolt_list_tail.value = intelligence
		caster.arcane_bolt_list_tail = tmp
	end
end

--[[
	Author: kritth
	Date: 09.01.2015
	Calculating the damage for arcane bolt
]]
function arcane_bolt_hit( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor( "bolt_vision", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )
	local base_damage = ability:GetLevelSpecialValueFor( "bolt_damage", ability:GetLevel() - 1 )
	local multiplier = ability:GetLevelSpecialValueFor( "int_multiplier", ability:GetLevel() - 1 )
	local intelligence = math.max( 0, caster.arcane_bolt_list_head.value )
	local damageType = ability:GetAbilityDamageType() -- DAMAGE_TYPE_MAGICAL
	
	-- Update linked head node
	if caster.arcane_bolt_list_head ~= caster.arcane_bolt_list_tail then
		caster.arcane_bolt_list_head = caster.arcane_bolt_list_head.next
	else
		caster.arcane_bolt_list_head = nil
	end
	
	-- Deal damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = base_damage + intelligence * multiplier,
		damage_type = damageType,
	}
	ApplyDamage( damageTable )
	
	-- Provide visibility
	ability:CreateVisibilityNode( target:GetAbsOrigin(), radius, duration )
end

--[[
	CHANGELIST:
	09.01.2015 - Standardized variables
]]

--[[
	Author: kritth
	Date: 09.01.2015.
	Deal constant interval damage shared in the radius
]]
function mystic_flare_start( keys )
	-- Variables
	local ability = keys.ability
	local caster = keys.caster
	local current_instance = 0
	local dummyModifierName = "modifier_mystic_flare_dummy_vfx_datadriven"
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local interval = ability:GetLevelSpecialValueFor( "damage_interval", ability:GetLevel() - 1 )
	local max_instances = math.floor( duration / interval )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local target = keys.target_points[1]
	local total_damage = 0
	if caster:IsRealHero() then
		total_damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 ) * caster:GetIntellect()
	else
		total_damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 ) * caster:GetAttackDamage()
	end
	local soundTarget = "Hero_SkywrathMage.MysticFlare.Target"
	local dummy = CreateUnitByName( "npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
	local damage_per_interval = total_damage / max_instances
	Timers:CreateTimer( function()
			local units = FindUnitsInRadius(
				caster:GetTeamNumber(), target, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false
			)
			if #units > 0 then
				local damage_per_hero = damage_per_interval / #units
				for k, v in pairs( units ) do
					-- Apply damage
					local damageTable = {
						victim = v,
						attacker = caster,
						damage = damage_per_hero,
						damage_type = DAMAGE_TYPE_MAGICAL
					}
					ApplyDamage( damageTable )
					
					-- Fire sound
					StartSoundEvent( soundTarget, v )
				end
			end
			
			current_instance = current_instance + 1
			
			-- Check if maximum instances reached
			if current_instance >= max_instances then
				dummy:Destroy()
				return nil
			else
				return interval
			end
		end
	)
end