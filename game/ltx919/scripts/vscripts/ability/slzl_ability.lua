function OnJsw4( data )
	local hCaster = data.caster
	local ability = data.ability
	local targets = data.target_entities
	local str_reduce = -data.str_reduce
	local hp_reduce = -data.hp_reduce
	if hCaster:HasModifier("modifier_shengsijue_caster_hero") then
		hCaster:RemoveModifierByName("modifier_shengsijue_caster_hero")
	end
	if hCaster:HasModifier("modifier_shengsijue_caster_basic") then
		hCaster:RemoveModifierByName("modifier_shengsijue_caster_basic")
	end
	if hCaster:IsRealHero() then
		ability:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_shengsijue_caster_hero",{})
		ability:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_shengsijue_caster_basic",{})
		for k,v in pairs(targets) do
			local pts = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf",
			 PATTACH_CUSTOMORIGIN, hCaster)
			ParticleManager:SetParticleControl(pts,0,v:GetAbsOrigin())
			ParticleManager:SetParticleControl(pts,1,hCaster:GetAbsOrigin())
			if v:IsRealHero() then
				local str = v:GetStrength()
				if v:HasModifier("modifier_shengsijue_debuff_hero") then
					v:RemoveModifierByName("modifier_shengsijue_debuff_hero")
				end
				ability:ApplyDataDrivenModifier(hCaster, v, "modifier_shengsijue_debuff_hero",{})
				if str<str_reduce then
					str_reduce = str-1
				end
				local ss_count = hCaster:GetModifierStackCount("modifier_shengsijue_caster_hero", hCaster)
				hCaster:SetModifierStackCount( "modifier_shengsijue_caster_hero", ability, ss_count+math.floor(str_reduce/10) )
			else
				local health = v:GetMaxHealth()
				local hpNum = health*(100-hp_reduce)/100
				v.hpNum = health-hpNum
				if v:HasModifier("modifier_shengsijue_debuff_basic") then
					v:RemoveModifierByName("modifier_shengsijue_debuff_basic")
				end
				v:SetMaxHealth(hpNum)
				v:SetBaseMaxHealth(hpNum)
				ability:ApplyDataDrivenModifier(hCaster, v, "modifier_shengsijue_debuff_basic",{})
				local ss_count = hCaster:GetModifierStackCount("modifier_shengsijue_caster_basic", hCaster)
				hCaster:SetModifierStackCount( "modifier_shengsijue_caster_basic", ability, ss_count+math.floor(v.hpNum/100) )
			end
		end
	else
		ability:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_shengsijue_caster_basic",{})
		local sss= 0
		for k,v in pairs(targets) do
			local pts = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf",
			 PATTACH_CUSTOMORIGIN, hCaster)
			ParticleManager:SetParticleControl(pts,0,v:GetAbsOrigin())
			ParticleManager:SetParticleControl(pts,1,hCaster:GetAbsOrigin())
			if v:IsRealHero() then
				local str = v:GetStrength()
				if v:HasModifier("modifier_shengsijue_debuff_hero") then
					v:RemoveModifierByName("modifier_shengsijue_debuff_hero")
				end
				ability:ApplyDataDrivenModifier(hCaster, v, "modifier_shengsijue_debuff_hero",{})
				if str<str_reduce then
					str_reduce = str-1
				end
				sss = sss + str_reduce*15
			else
				local health = v:GetMaxHealth()
				local hpNum = health*(100-hp_reduce)/100
				v.hpNum = health - hpNum
				if v:HasModifier("modifier_shengsijue_debuff_basic") then
					v:RemoveModifierByName("modifier_shengsijue_debuff_basic")
				end
				ability:ApplyDataDrivenModifier(hCaster, v, "modifier_shengsijue_debuff_basic",{})
				sss = sss + v.hpNum
				v:SetBaseMaxHealth( hpNum)
				v:SetMaxHealth(hpNum)
			end
		end
		hCaster.hpNum = sss
		hCaster:SetBaseMaxHealth(sss+hCaster:GetBaseMaxHealth())
		hCaster:SetMaxHealth(sss+hCaster:GetMaxHealth())
		hCaster:SetHealth(hCaster:GetHealth()+sss)
	end
end

function OnJsw4End( data )
	local hCaster = data.caster
	local ability = data.ability
	local target = data.target
	if hCaster.hpNum then
		hCaster:SetBaseMaxHealth(hCaster:GetBaseMaxHealth()-hCaster.hpNum)
		hCaster:SetMaxHealth(hCaster:GetMaxHealth()-hCaster.hpNum)
	end
	if target.hpNum then
		target:SetBaseMaxHealth(target:GetBaseMaxHealth()+target.hpNum)
		target:SetMaxHealth(target:GetMaxHealth()+target.hpNum)
		target:SetHealth(target:GetHealth()+target.hpNum)
	end
end