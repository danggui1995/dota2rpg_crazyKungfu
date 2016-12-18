--[[
	Handles the AutoCast Logic
	Author: Noya
	Date: 18.01.2015.
	Auto-Cast can interrupt current orders and forget the next queued command. Following queued commands are not forgotten
	Cannot occur while channeling a spell.
]]

require('libraries/timers')
function FrostArmorAutocast( event )
	local caster = event.caster
	local target = event.target -- victim of the attack
	local ability = event.ability

	-- Name of the modifier to avoid casting the spell on targets that were already buffed
	local modifier = "modifier_frost_armor"

	-- Get if the ability is on autocast mode and cast the ability on the attacked target if it doesn't have the modifier
	if ability:GetAutoCastState() then
		if not IsChanneling( caster ) then
			if not target:HasModifier(modifier) then
				caster:CastAbilityOnTarget(target, ability, caster:GetPlayerOwnerID())
			end
		end	
	end	
end

-- Auxiliar function that goes through every ability and item, checking for any ability being channelled
function IsChanneling ( hero )
	
	for abilitySlot=0,15 do
		local ability = hero:GetAbilityByIndex(abilitySlot)
		if ability ~= nil and ability:IsChanneling() then 
			return true
		end
	end

	for itemSlot=0,5 do
		local item = hero:GetItemInSlot(itemSlot)
		if item ~= nil and item:IsChanneling() then
			return true
		end
	end

	return false
end

--[[
	Author: Noya
	Date: 18.1.2015.
	Plays the lich_frost_armor particle and destroys it later
]]
function FrostArmorParticle( event )
	local target = event.target
	local location = target:GetAbsOrigin()
	local particleName = "particles/units/heroes/hero_lich/lich_frost_armor.vpcf"

	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function()
		target.FrostArmorParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.FrostArmorParticle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.FrostArmorParticle, 1, Vector(1,0,0))

		ParticleManager:SetParticleControlEnt(target.FrostArmorParticle, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
	end)
end

-- Destroys the particle when the modifier is destroyed
function EndFrostArmorParticle( event )
	local target = event.target
	ParticleManager:DestroyParticle(target.FrostArmorParticle,false)
end

--[[
	Author: Noya
	Date: 19.01.2015.
	Bounces a chain frost
	Bug: Currently fails to have 2 different chains bouncing at the same time, because the counter is on the ability instead of the cast.
]]
function ChainFrost( event )

	-- The chain frost is cast from the latest hit target to the first nearby enemy that isn't the same target
	local caster = event.caster
	local unit = event.target
	local targets = event.target_entities
	local ability = event.ability

	local jumps = ability:GetLevelSpecialValueFor( "jumps", ability:GetLevel() - 1 )
	local jump_range = ability:GetLevelSpecialValueFor( "jump_range", ability:GetLevel() - 1 )
	local jump_interval = ability:GetLevelSpecialValueFor( "jump_interval", ability:GetLevel() - 1 )

	local projectile_speed = ability:GetLevelSpecialValueFor( "projectile_speed", ability:GetLevel() - 1 )

	local particle_name = "particles/lich_chain_frost_ltx.vpcf"

	-- Initialize the chain counter, on 1 because the first cast
	if not ability.jump_counter then
		ability.jump_counter = 1
	end

	-- If there's still bounces to expend, find a new target
	if ability.jump_counter <= jumps then

		-- Go through the target_enties table, checking for the first one that isn't the same as the target
		local target_to_jump = nil
		for _,target in pairs(targets) do
			if target ~= unit and not target_to_jump then
				target_to_jump = target
			end
		end

		if target_to_jump then

			print("Bounce number "..ability.jump_counter)
			-- Create the next projectile
			local info = {
				Target = target_to_jump,
				Source = unit,
				Ability = ability,
				EffectName = particle_name,
				bDodgeable = false,
				bProvidesVision = true,
				iMoveSpeed = projectile_speed,
		        iVisionRadius = 100,
		        iVisionTeamNumber = caster:GetTeamNumber(), -- Vision still belongs to the one that casted the ability
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}
			ProjectileManager:CreateTrackingProjectile( info )

			-- Add one to the jump counter for this bounce
			ability.jump_counter = ability.jump_counter + 1
		else
			print("Can't find a target, End Chain")
			ability.jump_counter = nil
		end	
	else
		print("No more bounces left, End Chain")
		ability.jump_counter = nil
	end
end