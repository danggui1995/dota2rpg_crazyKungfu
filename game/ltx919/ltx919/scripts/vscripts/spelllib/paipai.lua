--[[
	CHANGELIST
	09.01.2015 - Standized the variables
]]

--[[
	Author: kritth
	Date: 7.1.2015.
	Increasing stack after each hit
]]

require('libraries/timers')
function fury_swipes_attack( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_fury_swipes_target_datadriven"
	local damageType = ability:GetAbilityDamageType()
	local exceptionName = "put_your_exception_unit_here"
	
	-- Necessary value from KV
	local duration = ability:GetLevelSpecialValueFor( "bonus_reset_time", ability:GetLevel() - 1 )
	local damage_per_stack = ability:GetLevelSpecialValueFor( "damage_per_stack", ability:GetLevel() - 1 )
	if target:GetName() == exceptionName then	-- Put exception here
		duration = ability:GetLevelSpecialValueFor( "bonus_reset_time_roshan", ability:GetLevel() - 1 )
	end
	
	-- Check if unit already have stack
	if target:HasModifier( modifierName ) then
		local current_stack = target:GetModifierStackCount( modifierName, ability )
		
		-- Deal damage
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = damage_per_stack * current_stack,
			damage_type = damageType
		}
		ApplyDamage( damage_table )
		
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, 1 )
	end
end

--[[
	Author: kritth
	Date: 7.1.2015.
	Init: Create stack and buff
]]
function overpower_init( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_overpower_buff_datadriven"
	local duration = ability:GetLevelSpecialValueFor( "duration_tooltip", ability:GetLevel() - 1 )
	local max_stack = ability:GetLevelSpecialValueFor( "max_attacks", ability:GetLevel() - 1 )
	
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, { } )
	caster:SetModifierStackCount( modifierName, ability, max_stack )
end

--[[
	Author: kritth
	Date: 7.1.2015.
	Main: Decrease stack upon attack
]]
function overpower_decrease_stack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_overpower_buff_datadriven"
	local current_stack = caster:GetModifierStackCount( modifierName, ability )
	
	if current_stack > 1 then
		caster:SetModifierStackCount( modifierName, ability, current_stack - 1 )
	else
		caster:RemoveModifierByName( modifierName )
	end
end

--[[
	CHANGELIST
	09.01.2015 - Standized the variables
]]

--[[
	Author: kritth
	Date: 7.1.2015.
	Create a timer to periodically add/remove damage base on health
]]
function enrage_init( keys )
	-- Local variables
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_enrage_buff_datadriven"
	local percent = ability:GetLevelSpecialValueFor( "life_damage_bonus_percent", ability:GetLevel() - 1)
	
	-- Necessary data to pass into the timer iteration
	local prefix = "modifier_enrage_damage_mod_"
	local bitTable = { 512, 256, 128, 64, 32, 16, 8, 4, 2, 1 }

	
	-- Remove existing damage
	keys.caster.enrage_damage = 0
	
	-- Create Timer
	Timers:CreateTimer(
		function()
			-- Variables for each loop
			local damage = caster:GetMaxHealth() * ( percent / 100.0 )
			
			-- Check if user needs additional modifiers
			if caster.enrage_damage ~= damage then
				-- Remove all damage modifiers
				local modCount = caster:GetModifierCount()
				for i = 0, modCount do
					for u = 1, #bitTable do
						local val = bitTable[u]
						if caster:GetModifierNameByIndex(i) == prefix .. val then
							caster:RemoveModifierByName( prefix .. val )
						end
					end
				end
				
				-- Add damage modifiers
				local damage_tmp = damage
				for i = 1, #bitTable do
					local val = bitTable[i]
					local count = math.floor( damage_tmp / val )
					if count >= 1 then
						ability:ApplyDataDrivenModifier( caster, caster, prefix .. val, {} )
						damage_tmp = damage_tmp - val
					end
				end
			end
			
			-- Updates
			caster.enrage_damage = damage
			
			-- Check if it is time to remove the buff
			if caster:HasModifier( modifierName ) == false then
				-- Remove all damage modifiers
				local modCount = caster:GetModifierCount()
				for i = 0, modCount do
					for u = 1, #bitTable do
						local val = bitTable[u]
						if caster:GetModifierNameByIndex(i) == prefix .. val then
							caster:RemoveModifierByName( prefix .. val )
						end
					end
				end
				return nil
			else
				return 0.1
			end
		end
	)
end