require('utils/abilityUtils')
function OnFanTian36( event )
	local hCaster = event.caster 
	local ability = event.ability 
	local target = event.target 
	local modifierName = event.modifierName 
	local duration = event.duration
	local number = event.number 
	local bonus = event.bonus 
	if target:HasModifier(modifierName) then
		local hModifier = target:FindModifierByName(modifierName)
		hModifier:SetStackCount(hModifier:GetStackCount()+1)
		if hModifier:GetStackCount()>number then
			local pts = ParticleManager:CreateParticle(event.particleName,PATTACH_ABSORIGIN_FOLLOW,hCaster)
			ParticleManager:SetParticleControl(pts,3,target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pts)
			local enemies = FindUnitsInRadius( hCaster:GetTeam(), target:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
			if enemies then
				for i=1,#enemies do
					local damageTable = {}
					damageTable.attacker = hCaster
					damageTable.victim = enemies[i]
					damageTable.damage_type = ability:GetAbilityDamageType() or DAMAGE_TYPE_PHYSICAL
					damageTable.ability = ability
					damageTable.damage_flags = DOTA_UNIT_TARGET_FLAG_NONE
					damageTable.damage = hCaster:GetAttackDamage()*bonus
					ApplyDamage(damageTable)
				end
			end
			target:RemoveModifierByName(modifierName)
		end
	else
		ability:ApplyDataDrivenModifier(hCaster,target,modifierName,{duration=duration})
	end

end


function ShanDianJingHong(event)
	local hCaster = event.caster
	local ability = event.ability
	local forward = hCaster:GetForwardVector():Normalized()
	local x = forward.x
	local y = forward.y
	local z = forward.z
	local distance = 1200
	local movespeed = 1800
	local center = hCaster:GetAbsOrigin()
	for i=-2,2 do
		--x*cosA-y*sinA,  x*sinA+y*cosA
		local x_new = x*math.cos(math.pi/6*i)-y*math.sin(math.pi/6*i)
		local y_new = x*math.sin(math.pi/6*i)+y*math.cos(math.pi/6*i)
		local xl_new = Vector(x_new,y_new,z)
		local fissure_projectile1 = {
        Ability             = ability,
        EffectName          = event.projectileName,
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

function BuSiQiHuan( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target 
	if ability:IsCooldownReady() then
		target:AddNewModifier(hCaster,ability,"modifier_stunned",{duration=event.duration})
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
	end
end

function ShowSiXiangDaoParticle( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local particleName = event.particleName
	local rv = hCaster:GetRightVector()
	local uv = hCaster:GetUpVector()
	local pts =ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts,0,hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(pts,0,Vector(1,0,0),rv,uv)

	local pts2 =ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts2,0,hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(pts2,0,Vector(-1,0,0),rv,uv)

	local pts3 =ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts3,0,hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(pts3,0,Vector(5,5,0):Normalized(),rv,uv)

	local pts4 =ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts4,0,hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(pts4,0,Vector(-5,-5,0):Normalized(),rv,uv)

	local pts5 =ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts5,0,hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(pts5,0,Vector(0,1,0),rv,uv)

	local pts6 =ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts6,0,hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(pts6,0,Vector(0,-1,0),rv,uv)

	--ParticleManager:DestroyParticle(pts,false)
	ParticleManager:ReleaseParticleIndex(pts)

	--ParticleManager:DestroyParticle(pts2,false)
	ParticleManager:ReleaseParticleIndex(pts2)

	--ParticleManager:DestroyParticle(pts3,false)
	ParticleManager:ReleaseParticleIndex(pts3)

	--ParticleManager:DestroyParticle(pts4,false)
	ParticleManager:ReleaseParticleIndex(pts4)

	--ParticleManager:DestroyParticle(pts5,false)
	ParticleManager:ReleaseParticleIndex(pts5)

	--ParticleManager:DestroyParticle(pts6,false)
	ParticleManager:ReleaseParticleIndex(pts6)
end

function OnFanTan( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	if event.reason and event.reason==1 then
		local damageTable = 
		{
			victim = target,
	        attacker = hCaster,
	        damage = event.damage*event.fantan/100,
	        damage_type = DAMAGE_TYPE_PURE,
	        reason = 1
	    }
	    local num = ApplyDamage(damageTable)
	end
end

function OnXueZhanShishi( event )
	local hCaster = event.caster
	hCaster:AddNoDraw()
end

function OnXueZSSThinker( event )
	local target = event.target
	target:SetAbsOrigin(target:GetAbsOrigin()+Vector(0,0,3))

end

function OnRecordData( event )
	local target = event.target
	target.initAbsOrigin = target:GetAbsOrigin()
end

function OnXZSSDamageCalculate( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target 
	local crit_ratio = event.crit_ratio
	local damage_ratio = event.damage_ratio
	target:SetAbsOrigin(target.initAbsOrigin)
	local damage = 0
	if not hCaster:IsRealHero() then
		damage = hCaster:GetAttackDamage() / 8 * damage_ratio
	else
		damage = hCaster:GetStrength() * damage_ratio
	end
	--begin do damage
	local damageTable = 
	{
		victim = target,
        attacker = hCaster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    local num = ApplyDamage(damageTable)
end

function EndOfXZSS( event )
	local hCaster = event.caster
	hCaster:StartGesture(ACT_DOTA_ATTACK2)
	local particleName = event.particleName
	local pts = ParticleManager:CreateParticle(particleName,PATTACH_WORLDORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts,0,hCaster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pts)
	hCaster:RemoveNoDraw()
end

function OnJinZhongYue( event )
	
end