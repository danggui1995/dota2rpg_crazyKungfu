--[[
	Author: Noya, Pizzalol
	Date: 04.03.2015.
	After taking damage, checks the mana of the caster and prevents as many damage as possible.
	Note: This is post-reduction, because there's currently no easy way to get pre-mitigation damage.
]]
function ManaShield( event )
	local caster = event.caster
	local ability = event.ability
	local damage_per_mana = ability:GetLevelSpecialValueFor("damage_per_mana", ability:GetLevel() - 1 )

	local damage = event.Damage

	local caster_mana = caster:GetMana()
	local mana_needed = damage / damage_per_mana

	-- Check if the not reduced damage kills the caster
	local oldHealth = caster.OldHealth

	-- If it doesnt then do the HP calculation
	if oldHealth >= 1 then
		print("Damage taken "..damage.." | Mana needed: "..mana_needed.." | Current Mana: "..caster_mana)

		-- If the caster has enough mana, fully heal for the damage done
		if mana_needed <= caster_mana then
			caster:SpendMana(mana_needed, ability)
			caster:SetHealth(oldHealth)
			
			-- Impact particle based on damage absorbed
			local particleName = "particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf"
			local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, Vector(mana_needed,0,0))
		else
			local newHealth = oldHealth - damage
			mana_needed = caster_mana
			caster:SpendMana(mana_needed, ability)
			caster:SetHealth(newHealth)
		end
	end	
end

-- Keeps track of the targets health
function ManaShieldHealth( event )
	local caster = event.caster

	caster.OldHealth = caster:GetHealth()
end


--[[Author: Pizzalol
	Date: 07.03.2015.
	Initialize the Stone Gaze unit table]]
function StoneGazeStart( keys )
	local caster = keys.caster

	caster.stone_gaze_table = {}
end

--[[Author: Pizzalol
	Date: 07.03.2015.
	Checks if the caster has the Stone Gaze modifier
	If the caster doesnt have the modifier then remove the debuff modifier from the target]]
function StoneGazeSlow( keys )
	local caster = keys.caster
	local target = keys.target
	
	local modifier_caster = keys.modifier_caster
	local modifier_target = keys.modifier_target

	if not caster:HasModifier(modifier_caster) then
		target:RemoveModifierByNameAndCaster(modifier_target, caster)
	end
end

--[[Author: Pizzalol, math by BMD
	Date: 07.03.2015.
	Checks if the target is currently facing the caster
	then it checks if the target faced the caster before
	if the target did face the caster before then apply the counter modifier
	otherwise add the target as a new target]]
function StoneGaze( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Modifiers
	local modifier_slow = keys.modifier_slow
	local modifier_facing = keys.modifier_facing

	-- Ability variables
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local vision_cone = ability:GetLevelSpecialValueFor("vision_cone", ability_level)

	-- Locations
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()	

	-- Angle calculation
	local direction = (caster_location - target_location):Normalized()
	local forward_vector = target:GetForwardVector()
	local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)
	--print("Angle: " .. angle)

	-- Facing check
	if angle <= vision_cone/2 then
		local check = false
		-- Check if its a target from before
		for _,v in ipairs(caster.stone_gaze_table) do
			if v == target then
				check = true
			end
		end

		-- If its a target from before then apply the counter modifier for 2 frames
		if check then
			ability:ApplyDataDrivenModifier(caster, target, modifier_facing, {Duration = 0.06})
		else
			-- If its a new target then add it to the table
			table.insert(caster.stone_gaze_table, target)
			-- Set the facing time to 0
			target.stone_gaze_look = 0
			-- Set the petrification variable to false
			target.stone_gaze_stoned = false

			-- Apply the slow and counter modifiers
			ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {Duration = duration})
			ability:ApplyDataDrivenModifier(caster, target, modifier_facing, {Duration = 0.06})
		end
	end
end

--[[Author: Pizzalol
	Date: 07.03.2015.
	Checks for how long the target faced the caster
	If it was for longer than the minimum required facing time then
	apply the petrification debuff if the target was not petrified before]]
function StoneGazeFacing( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local face_duration = ability:GetLevelSpecialValueFor("face_duration", ability_level)
	local stone_duration = ability:GetLevelSpecialValueFor("stone_duration", ability_level)
	local modifier_stone = keys.modifier_stone

	target.stone_gaze_look = target.stone_gaze_look + 0.03

	-- If the target was facing the caster for more than the required time and wasnt petrified before
	-- then petrify it
	if target.stone_gaze_look >= face_duration and not target.stone_gaze_stoned then
		ability:ApplyDataDrivenModifier(caster, target, modifier_stone, {Duration = stone_duration})
		target.stone_gaze_stoned = true
	end
end