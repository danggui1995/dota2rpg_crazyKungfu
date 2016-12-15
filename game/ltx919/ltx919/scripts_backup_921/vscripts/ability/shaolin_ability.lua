function OnQinLongShou( data )
	local hCaster = data.caster
	local hTarget = data.target
	local ability = data.ability
	local pos_t = hTarget:GetAbsOrigin()
	local pos_c = hCaster:GetAbsOrigin()
	local forward = (pos_c - pos_t)
	local forward_nor = forward:Normalized()
	local speed = data.speed
	local tick = 0.02
	if forward:Length2D()<100 then
		if hTarget:HasModifier("modifier_qinlongshou_zhua_debuff") then
			hTarget:RemoveModifierByName("modifier_qinlongshou_zhua_debuff")
			return
		end
	end
	local s_distance = speed * tick
	hTarget:SetAbsOrigin(pos_t + s_distance * forward_nor)
	hTarget:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) 
end
	--[[local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)]]
function OnMingXinZhou( data )
	local hCaster = data.caster
	local radius = data.radius
	local ability = data.ability
	local targets = FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetAbsOrigin(), nil,radius,
					DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, 0, false)
	for _,v in ipairs(targets) do
		if v:GetTeam() == hCaster:GetTeam() then
			v:Purge( false, true, false, true, false)
			ability:ApplyDataDrivenModifier(v, v, "modifier_mingxinzhou_buff",{})
		else
			v:Purge( true, false, false, false, false)
		end
	end
end

function OnDaCiDaBeiZhang( event )
	local caster = event.caster
	local point = event.target_points[1]
	local ability = event.ability
	local radius = event.radius
	local ori_pos = caster:GetAbsOrigin()
	local taget_pos = point + Vector(0,0,400)
	local xs = event.damage_xs
	local totalDamage = caster:GetStrength() * xs
	caster:SetAbsOrigin(taget_pos)
	local p1 = "particles/units/heroes/hero_beastmaster/beastmaster_call_boar.vpcf"
	caster.p1 = ParticleManager:CreateParticle(p1, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(caster.p1, 0, caster:GetAbsOrigin())
	caster:SetContextThink("ffff", 
	function()
		local particleName = "particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf"
		caster.teleportParticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(caster.teleportParticle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(caster.teleportParticle, 1, point)
		local targets = FindUnitsInRadius(caster:GetTeam(), point, nil,radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, 0, false)
		for i,v in ipairs(targets) do
			local damageTable = {}
			damageTable.attacker = caster
			damageTable.victim = v
			damageTable.damage_type = ability:GetAbilityDamageType()
			damageTable.ability = ability
			damageTable.damage_flags = DOTA_UNIT_TARGET_FLAG_NONE
			damageTable.damage = totalDamage
			ApplyDamage(damageTable)
			ability:ApplyDataDrivenModifier(caster, v,"modifier_dacidabeishou_debuff",{})
		end
		EmitSoundOn("Hero_Beastmaster.Primal_Roar", caster)
		caster:SetAbsOrigin(ori_pos)
		caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) 
		local p2 = "particles/units/heroes/hero_beastmaster/beastmaster_call_boar.vpcf"
		caster.p2 = ParticleManager:CreateParticle(p2, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(caster.p2, 0, caster:GetAbsOrigin())
		return nil
	end, 0.5)
end