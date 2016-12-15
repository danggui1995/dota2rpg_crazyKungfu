LinkLuaModifier( "modifier_zhenyafu_lua" , "scripts/vscripts/item/modifiers/modifier_zhenyafu_lua.lua" , LUA_MODIFIER_MOTION_NONE )


function OnZhenYaFu( data )
	local hCaster = data.caster 
	local ability = data.ability
	local radius = data.radius
	local damage = data.damage
	local point = data.target_points[1]
	if hCaster.pts then
		hCaster:SetContextThink("qqq",
			function(  )
				ParticleManager:DestroyParticle(hCaster.pts,true)
				return nil
			end,
		0.5) 
	end
	hCaster.pts = ParticleManager:CreateParticle("particles/zhenyafu_ltx.vpcf", 
		PATTACH_CUSTOMORIGIN,hCaster)
	ParticleManager:SetParticleControl(hCaster.pts, 0, point+Vector(0,0,555))
	ParticleManager:SetParticleControl(hCaster.pts, 1, point)

	hCaster:SetContextThink("sss", 
	function (  )
		ParticleManager:DestroyParticle(hCaster.pts,true)
		local targets = FindUnitsInRadius(hCaster:GetTeam(), point, nil,radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, 0, false)
		local pts2 = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_whirling_death_spin.vpcf", 
		PATTACH_CUSTOMORIGIN,hCaster)
		ParticleManager:SetParticleControl(pts2, 0, point)
		for i,v in ipairs(targets) do
			local damageTable = {
				victim = v,    --受到伤害的单位
	            attacker = hCaster,          --造成伤害的单位
	            damage = damage,
	            damage_type = DAMAGE_TYPE_PURE
				}
			local damageValue = ApplyDamage(damageTable)
			v:AddNewModifier(hCaster, nil, "modifier_zhenyafu_lua",{Duration = 5})
		end
		return nil
	end,0.5)
end