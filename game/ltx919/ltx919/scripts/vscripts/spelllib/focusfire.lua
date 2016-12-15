function focusfire_register( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local modifierAttackSpeed = "modifier_focusfire_attackspeed_buff_datadriven"
	local modifierDamageDebuff = "modifier_focusfire_damage_debuff_datadriven"
	
	-- Set target
	caster.focusfire_target = keys.target
	
	-- Apply buff
	ability:ApplyDataDrivenModifier( caster, caster, modifierAttackSpeed, {} )
	ability:ApplyDataDrivenModifier( caster, caster, modifierDamageDebuff, {} )
	
	-- Order to attack immediately
	local order =
	{
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = keys.target:entindex()
	}
	ExecuteOrderFromTable( order )
end

--[[
	Author: kritth
	Date: 5.1.2015.
	Add/Remove damage debuff modifier when attack start 
]]
function focusfire_on_attack_landed( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierToRemove = "modifier_focusfire_attackspeed_buff_datadriven"
	
	-- Check if it hit the specified target
	if target ~= caster.focusfire_target then
		caster:RemoveModifierByName( modifierToRemove )
	else
		ability:ApplyDataDrivenModifier( caster, caster, modifierToRemove, {} )
	end
end

function powershot_start_traverse( keys )
	-- Variables
	local hCaster = keys.caster
	local ability = keys.ability
	local startAttackSound = "Ability.PowershotPull"
	local startTraverseSound = "Ability.Powershot"
	local projectileName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"

	StartSoundEvent( startTraverseSound, hCaster )
	
	-- Create projectile
	local center = hCaster:GetAbsOrigin()
	local foward = hCaster:GetForwardVector()
	local x = foward.x
	local y = foward.y
	local z = foward.z
	local distance = keys.distance
	local movespeed = keys.movespeed
	for i=-1,1 do
		--x*cosA-y*sinA,  x*sinA+y*cosA
		local x_new = x*math.cos(math.pi/6*i)-y*math.sin(math.pi/6*i)
		local y_new = x*math.sin(math.pi/6*i)+y*math.cos(math.pi/6*i)
		local xl_new = Vector(x_new,y_new,z)
		local fissure_projectile1 = {
        Ability             = ability,
        EffectName          = projectileName,
        vSpawnOrigin        = center,
        fDistance           = distance,
        fStartRadius        = 100,
        fEndRadius          = 100,
        Source              = hCaster,
        bHasFrontalCone     = false,
        bReplaceExisting    = false,
        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
    --  iUnitTargetFlags    = ,
        iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    --  fExpireTime         = ,
        bDeleteOnHit        = false,
        vVelocity           = movespeed*xl_new,
        bProvidesVision     = true,
    	iVisionRadius       = 500,
    --  iVisionTeamNumber   = caster:GetTeamNumber(),
    	}
		local pod = ProjectileManager:CreateLinearProjectile( fissure_projectile1 )
		
	end
end