

--[[Author: Pizzalol
	Date: 18.03.2015.
	Initialize the axes]]
function WhirlingAxesMelee( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local foward = caster:GetForwardVector()
	local x = foward.x
	local y = foward.y
	local z = foward.z
	local number = 6
	for i=1,number do
		local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
		local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
		local xl_new = Vector(x_new,y_new,z)
		local l_point = caster_location+xl_new*100
		local fissure_projectile1 = {
        Ability             = ability,
        EffectName          = "particles/beastmaster_wildaxe_copy_ltx.vpcf",
        vSpawnOrigin        = caster_location,
        fDistance           = 600,
        fStartRadius        = 100,
        fEndRadius          = 100,
        Source              = caster,
        bHasFrontalCone     = false,
        bReplaceExisting    = false,
        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
    --  iUnitTargetFlags    = ,
        iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    --  fExpireTime         = ,
        bDeleteOnHit        = false,
        vVelocity           = 800*xl_new,
        bProvidesVision     = true,
    	iVisionRadius       = 400,
    --  iVisionTeamNumber   = caster:GetTeamNumber(),
    	}
		local pod = ProjectileManager:CreateLinearProjectile( fissure_projectile1 )
	end
	local start_radius = ability:GetLevelSpecialValueFor("start_radius", ability_level)
	caster.whirling_axes_melee_hit_table = {} 
	
	-- Visuals
	local axe_projectile = keys.axe_projectile
	local axe_modifier = keys.axe_modifier

	-- Starting position calculation
	local angle_east = QAngle(0,-90,0)
	local angle_west = QAngle(0,90,0)

	local forward_vector = caster:GetForwardVector()
	local front_position = caster_location + forward_vector * start_radius

	local position_east = RotatePosition(caster_location, angle_east, front_position) 
	local position_west = RotatePosition(caster_location, angle_west, front_position)

	-- East axe
	if caster.whirling_axes_east and IsValidEntity(caster.whirling_axes_east) then
		caster.whirling_axes_east:RemoveSelf()
	end

	-- Create the axe
	caster.whirling_axes_east = CreateUnitByName("npc_dota_troll_warlord_axe", position_east, false, caster, caster, caster:GetTeam() )
	ability:ApplyDataDrivenModifier(caster, caster.whirling_axes_east, axe_modifier, {})

	-- Set the particle
	local particle_east = ParticleManager:CreateParticle(axe_projectile, PATTACH_ABSORIGIN_FOLLOW, caster.whirling_axes_east)
	ParticleManager:SetParticleControlEnt(particle_east, 1, caster.whirling_axes_east, PATTACH_POINT_FOLLOW, "attach_hitloc", caster.whirling_axes_east:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_east, 4, Vector(5,0,0))

	-- Save the relevant data for movement calculation
	caster.whirling_axes_east.axe_radius = start_radius
	caster.whirling_axes_east.start_time = GameRules:GetGameTime()
	caster.whirling_axes_east.side = 0

	-- West axe
	if caster.whirling_axes_west and IsValidEntity(caster.whirling_axes_west) then
		caster.whirling_axes_west:RemoveSelf()
	end

	-- Create the axe
	caster.whirling_axes_west = CreateUnitByName("npc_dota_troll_warlord_axe", position_west, false, caster, caster, caster:GetTeam() )
	ability:ApplyDataDrivenModifier(caster, caster.whirling_axes_west, axe_modifier, {})
	
	-- Set the particle
	local particle_west = ParticleManager:CreateParticle(axe_projectile, PATTACH_ABSORIGIN_FOLLOW, caster.whirling_axes_west)
	ParticleManager:SetParticleControlEnt(particle_west, 1, caster.whirling_axes_west, PATTACH_POINT_FOLLOW, "attach_hitloc", caster.whirling_axes_west:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_west, 4, Vector(5,0,0))

	-- Save the relevant data for movement calculation
	caster.whirling_axes_west.axe_radius = start_radius
	caster.whirling_axes_west.start_time = GameRules:GetGameTime()
	caster.whirling_axes_west.side = 1
end

--[[Author: Pizzalol, Ractidous
	Date: 18.03.2015.
	Moves the axes around the caster]]
function WhirlingAxesMeleeThink( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local elapsed_time = GameRules:GetGameTime() - target.start_time

	-- If the caster is not alive then remove the axes
	if not caster:IsAlive() then
		target:RemoveSelf()
		return
	end

	-- Ability variables
	local axe_movement_speed = ability:GetLevelSpecialValueFor("axe_movement_speed", ability_level) 
	local max_range = ability:GetLevelSpecialValueFor("max_range", ability_level) 
	local whirl_duration = ability:GetLevelSpecialValueFor("whirl_duration", ability_level) 
	local axe_turn_rate = ability:GetLevelSpecialValueFor("axe_turn_rate", ability_level)
	local hit_radius = ability:GetLevelSpecialValueFor("hit_radius", ability_level)
	local think_interval = ability:GetLevelSpecialValueFor("think_interval", ability_level)

	-- Calculate the radius and limit it to the max range
	local currentRadius	= target.axe_radius 
	local deltaRadius = axe_movement_speed / whirl_duration/2 * think_interval -- This is how fast the axe grows outwards
	currentRadius = currentRadius + deltaRadius
	currentRadius = math.min( currentRadius, (max_range - hit_radius)) -- Limit it to the max range

	-- Save the radius for the next think interval
	target.axe_radius = currentRadius

	-- Check which axe is it and then rotate it accordingly
	local rotation_angle
	if target.side == 1 then
		rotation_angle = elapsed_time * axe_turn_rate -- 360 is the turnrate
	else
		rotation_angle = elapsed_time * axe_turn_rate + 180 -- Add 180 to rotate it 180 degrees so both axes dont appear at 1 point
	end

	-- Rotate the current position
	local relPos = Vector( 0, currentRadius, 0 )
	relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotation_angle, 0 ), relPos )

	-- Set the position around the target it is supposed to spin around
	local absPos = GetGroundPosition( relPos + caster_location, target )
	target:SetAbsOrigin( absPos )

	-- Check if its time to kill the axes
	if elapsed_time >= whirl_duration then
		target:RemoveSelf()
	end
end

--[[Author: Pizzalol
	Date: 18.03.2015.
	Checks if the target has been hit before and then does logic according to that]]
function WhirlingAxesMeleeHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	local sound = keys.sound

	-- Ability variables
	local blind_duration = ability:GetLevelSpecialValueFor("blind_duration", ability_level)
	local damage = keys.damage_xs * caster:GetStrength()

	-- Check if the target has been hit before
	local hit_check = false

	for _,unit in ipairs(caster.whirling_axes_melee_hit_table) do
		if unit == target then
			hit_check = true
			break
		end
	end

	-- If the target hasnt been hit before then insert it into the hit table to keep track of it
	if not hit_check then
		table.insert(caster.whirling_axes_melee_hit_table, target)

		-- Apply the blind modifier and play the sound
		ability:ApplyDataDrivenModifier(caster, target, modifier, {Duration = blind_duration})
		EmitSoundOn(sound, target)

		-- Initialize the damage table and deal damage to the target
		local damage_table = {}
		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.ability = ability
		damage_table.damage_type = ability:GetAbilityDamageType() 
		damage_table.damage = damage

		ApplyDamage(damage_table)
	end
end


--[[Author: Pizzalol
	Date: 11.03.2015.
	Increases attack speed if attacking the same target over and over]]
function Fervor( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Check if we have an old target
	if caster.fervor_target then
		-- Check if that old target is the same as the attacked target
		if caster.fervor_target == target then
			-- Check if the caster has the attack speed modifier
			if caster:HasModifier(modifier) then
				-- Get the current stacks
				local stack_count = caster:GetModifierStackCount(modifier, ability)

				-- Check if the current stacks are lower than the maximum allowed
				if stack_count < max_stacks then
					-- Increase the count if they are
					caster:SetModifierStackCount(modifier, ability, stack_count + 1)
				end
			else
				-- Apply the attack speed modifier and set the starting stack number
				ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
				caster:SetModifierStackCount(modifier, ability, 1)
			end
		else
			-- If its not the same target then set it as the new target and remove the modifier
			caster:RemoveModifierByName(modifier)
			caster.fervor_target = target
		end
	else
		caster.fervor_target = target
	end
end