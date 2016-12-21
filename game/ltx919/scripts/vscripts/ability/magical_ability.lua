require('libraries/notifications')
require('libraries/timers')

function ManaBreak( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local __level = ability:GetLevel() - 1
	local manaBurn = ability:GetLevelSpecialValueFor("mana_burn",__level)
	if not caster:IsRealHero() then
		manaBurn = manaBurn*2
	end
	local damageXs = ability:GetLevelSpecialValueFor("damage_xs", __level)
	local totalMana = caster:GetMaxMana()
	local diff = target:GetMana() - manaBurn*totalMana
	if diff>=0 then
		target:SetMana(diff)
	else
		target:SetMana(1)
	end
	local totalDamage = (totalMana-target:GetMana())*damageXs
	local damageTable = {}
	damageTable.attacker = caster
	damageTable.victim = target
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.ability = ability
	damageTable.damage_flags = DOTA_UNIT_TARGET_FLAG_NONE
	damageTable.damage = totalDamage
	ApplyDamage(damageTable)
end

function OnIceCircle( data )
	local distance = data.distance
	local vision_range = data.vision_range
	local movespeed = data.movespeed
	local radius = 280
	local hCaster = data.caster
	local ability = data.ability
	local particle_fissure = data.effect_name

	local center = hCaster:GetAbsOrigin()
	local number = data.num
	local foward = hCaster:GetForwardVector()
	local x = foward.x
	local y = foward.y
	local z = foward.z
	for i=1,number do
		local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
		local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
		local xl_new = Vector(x_new,y_new,z)

		local l_point = center+xl_new*radius
	
		local fissure_projectile1 = {
        Ability             = ability,
        EffectName          = particle_fissure,
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
    	iVisionRadius       = vision_range,
    --  iVisionTeamNumber   = caster:GetTeamNumber(),
    	}
		local pod = ProjectileManager:CreateLinearProjectile( fissure_projectile1 )
		
	end
end


function OnFanJiLuoXuan(data)
	local hCaster = data.caster
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
end

function OnAngerOfAncestor( data )
	local opt = data.opt
	local ability = data.ability
	local hCaster = data.caster
	if opt == 1 then
		ability.point = data.target_points[1]
		ability.dummy = CreateUnitByName("npc_dota_dummy_axe", ability.point, true, nil,nil,DOTA_TEAM_GOODGUYS)
		ability.dummy:StartGesture(ACT_DOTA_CAST_ABILITY_1)
		ability.damage_result=data.damage_base +
					data.damage_increase
					*hCaster:GetStrength()
		
	elseif opt == 2 then
		local foward = ability.dummy:GetForwardVector()
		local number = 6
		local radius = data.radius
		local x = foward.x
		local y = foward.y
		local z = foward.z
		for i=1,number do
			local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
			local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
			local pos_new = ability.point + Vector(x_new,y_new,z)*radius
			local pts = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack_impact.vpcf",
				PATTACH_CUSTOMORIGIN, 
							ability.dummy)
			ParticleManager:SetParticleControl(pts, 1,pos_new)
		end
		EmitSoundOn("Hero_ElderTitan.EchoStomp",ability.dummy)
		MyApplyDamage(hCaster,ability.point,radius,ability.damage_result)
		ability.dummy:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	elseif opt == 3 then
		if ability.dummy and ability.dummy:IsAlive() then
			ability.dummy:ForceKill(true)
		end
	end
end

function MyApplyDamage( hCaster,center,radius,damage )
	local targets = FindUnitsInRadius(hCaster:GetTeam(), center, nil,radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, 0, false)
	for i, v in ipairs(targets) do
		if IsValidEntity(v) and v:IsAlive() then
			local damageTable = 
			{
				victim = v,    --受到伤害的单位
	            attacker = hCaster,          --造成伤害的单位
	            damage = damage,
	            damage_type = DAMAGE_TYPE_PHYSICAL
	        }
			local num = ApplyDamage(damageTable)
		end
	end
end

function OnTaWuMangXing( data )
	local radius = data.radius
	local ability = data.ability
	ability.target = data.target
	local hCaster = data.caster
	local point = hCaster:GetAbsOrigin()
	local time = data.time
	ability.dummy = {}
	local foward = ability.target:GetForwardVector()
	local number = 5
	local radius = data.radius
	local x = foward.x
	local y = foward.y
	local z = foward.z
	for i=1,number do
		local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
		local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
		local pos_new = ability.target:GetAbsOrigin() + Vector(x_new,y_new,z)*radius
		ability.dummy[i] = CreateUnitByName("npc_dota_dummy_caster", pos_new, true, nil,nil, DOTA_TEAM_GOODGUYS)
	end
	-- 1 3 5 2 4
	-- 
	hCaster:SetAbsOrigin(ability.dummy[1]:GetAbsOrigin())
	local js = 0
	local js2 = 0
	local js3 = 0
	local js4 = 0
	local js5 = 0
	local tt = time / 0.02
	ability.pts1 = 0
	ability.pts2 = 0
	ability.pts3 = 0
	ability.pts4 = 0
	ability.pts5 = 0
	if ability.pts1==0 then
		ability.pts1 = ParticleManager:CreateParticle("particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf", 
				PATTACH_CUSTOMORIGIN, 
				hCaster)
		ParticleManager:SetParticleControl(ability.pts1,0, ability.dummy[1]:GetAbsOrigin())
	end
	
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("move_ta"),
		function (  )
			local total = ability.dummy[3]:GetAbsOrigin() - ability.dummy[1]:GetAbsOrigin()
			local avg = total / tt
			js = js + 1
			hCaster:SetAbsOrigin(hCaster:GetAbsOrigin()+avg)
			ParticleManager:SetParticleControl(ability.pts1,1, hCaster:GetAbsOrigin())
			if js<tt then
				return 0.02
			else
				if ability.pts2==0 then
					ability.pts2 = ParticleManager:CreateParticle("particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf", 
							PATTACH_CUSTOMORIGIN, 
							hCaster)
					ParticleManager:SetParticleControl(ability.pts2,0, ability.dummy[3]:GetAbsOrigin())
				end
				
				GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("move_ta1"),
				function (  )
					local total = ability.dummy[5]:GetAbsOrigin() - ability.dummy[3]:GetAbsOrigin()
					local avg = total / tt
					js2 = js2 + 1
					hCaster:SetAbsOrigin(hCaster:GetAbsOrigin()+avg)
					ParticleManager:SetParticleControl(ability.pts2,1, hCaster:GetAbsOrigin())
					if js2<tt then
						return 0.02
					else
						if ability.pts3==0 then
							ability.pts3 = ParticleManager:CreateParticle("particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf", 
									PATTACH_CUSTOMORIGIN, 
									hCaster)
							ParticleManager:SetParticleControl(ability.pts3,0, ability.dummy[5]:GetAbsOrigin())
						end
						GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("move_ta2"),
						function (  )
							local total = ability.dummy[2]:GetAbsOrigin() - ability.dummy[5]:GetAbsOrigin()
							local avg = total / tt
							js3 = js3 + 1
							hCaster:SetAbsOrigin(hCaster:GetAbsOrigin()+avg)
							ParticleManager:SetParticleControl(ability.pts3,1, hCaster:GetAbsOrigin())
							if js3<tt then
								return 0.02
							else
								if ability.pts4==0 then
									ability.pts4 = ParticleManager:CreateParticle("particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf", 
											PATTACH_CUSTOMORIGIN, 
											hCaster)
									ParticleManager:SetParticleControl(ability.pts4,0, ability.dummy[2]:GetAbsOrigin())
								end
								GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("move_ta3"),
								function (  )
									local total = ability.dummy[4]:GetAbsOrigin() - ability.dummy[2]:GetAbsOrigin()
									local avg = total / tt
									js4 = js4 + 1
									hCaster:SetAbsOrigin(hCaster:GetAbsOrigin()+avg)
									ParticleManager:SetParticleControl(ability.pts4,1, hCaster:GetAbsOrigin())
									if js4<tt then
										return 0.02
									else
										if ability.pts5==0 then
											ability.pts5 = ParticleManager:CreateParticle("particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf", 
													PATTACH_CUSTOMORIGIN, 
													hCaster)
											ParticleManager:SetParticleControl(ability.pts5,0, ability.dummy[4]:GetAbsOrigin())
										end
										GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("move_ta4"),
										function (  )
											local total = ability.dummy[1]:GetAbsOrigin() - ability.dummy[4]:GetAbsOrigin()
											local avg = total / tt
											js5 = js5 + 1
											hCaster:SetAbsOrigin(hCaster:GetAbsOrigin()+avg)
											ParticleManager:SetParticleControl(ability.pts5,1, hCaster:GetAbsOrigin())
											if js5<tt then
												return 0.02
											else
												hCaster:SetAbsOrigin(point)
												hCaster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) 
												return nil
											end
										end,0)
										return nil
									end
								end,0)
								return nil
							end
						end,0)
						return nil
					end
				end,0)
				return nil
			end
		end,0.2)
end

function OnTaRemove(data)
	local ability = data.ability
	local hCaster = data.caster
	ParticleManager:DestroyParticle(ability.pts1,true)
	ParticleManager:DestroyParticle(ability.pts2,true)
	ParticleManager:DestroyParticle(ability.pts3,true)
	ParticleManager:DestroyParticle(ability.pts4,true)
	ParticleManager:DestroyParticle(ability.pts5,true)
	local pts = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_hit_tgt.vpcf",
	 			PATTACH_CUSTOMORIGIN, 
				ability.target)
	ParticleManager:SetParticleControl(pts, 1, ability.target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pts, 3, Vector(0,0,122))
	local damageTable = 
			{
				victim = ability.target,    --受到伤害的单位
	            attacker = hCaster,          --造成伤害的单位
	            damage = ability.damage_result,
	            damage_type = DAMAGE_TYPE_PHYSICAL
	        }
	EmitSoundOn("Hero_TemplarAssassin.Meld.Attack",ability.target)
	local num = ApplyDamage(damageTable)
	for i=1,5 do
		if ability.dummy[i] and ability.dummy[i]:IsAlive() then
			ability.dummy[i]:ForceKill(true)
		end
	end
end

function OnZhaohuanHuoren( data )
	local number = data.number 
	local lv = data.lv
	local durations = data.duration
	local hCaster = data.caster
	local forward = hCaster:GetForwardVector()
	local id = hCaster:GetPlayerID()
	for i=1,number do
		local huoren = CreateUnitByName("npc_dota_invoker_forged_spirit_new_"..lv, hCaster:GetAbsOrigin()+170*forward, true, nil, nil, hCaster:GetTeam())
		huoren:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		huoren:AddNewModifier(huoren, nil,"modifier_kill", {duration = durations})
		huoren:SetControllableByPlayer(id, true)
		huoren:SetOwner(hCaster)
	end
end

function OnFireStone( data )
	local opt = data.opt
	local ability = data.ability
	local hCaster = data.caster
	if opt==1 then
		ability.point = data.target_points[1]
		hCaster:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
		local pts = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf",
		 PATTACH_CUSTOMORIGIN,hCaster)
		ParticleManager:SetParticleControl(pts,0, ability.point+Vector(0,0,666))
		ParticleManager:SetParticleControl(pts, 1, ability.point)
		ParticleManager:SetParticleControl(pts, 2, Vector(1.3, 0, 0))
	elseif opt ==2 then
		local pts1 = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_land_ring_lrg.vpcf",
		 PATTACH_CUSTOMORIGIN,hCaster)
		ParticleManager:SetParticleControl(pts1,3, ability.point)
	end

end

function OnInvokerUtl( data )
	local hCaster = data.caster
	local lv_bonus = data.lv_bonus
	local jn_bonus = data.jn_bonus
	local jn_lv = data.jn_lv
	local radius = data.radius
	local targets	= data.target_entities
	local foward = hCaster:GetForwardVector()
	local number = 12
	local x = foward.x
	local y = foward.y
	local z = foward.z
	for j=1,5 do
		for i=1,number do
			local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
			local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
			local pos_new = hCaster:GetAbsOrigin() + Vector(x_new,y_new,z)*radius
			local pts = ParticleManager:CreateParticle("particles/doom_bringer_f2p_death_fire_ltx.vpcf",
			 PATTACH_CUSTOMORIGIN, hCaster)
			ParticleManager:SetParticleControl(pts,0,pos_new)
		end
		radius = radius - 100
		EmitSoundOn("Hero_DragonKnight.BreathFire",hCaster)
	end
	local damage_result = jn_lv*hCaster:GetIntellect()*jn_bonus +lv_bonus*hCaster:GetLevel()
	for i,v in ipairs(targets) do
		if IsValidEntity(v) and v:IsAlive() then
			local damageTable = 
			{
				victim = v,    --受到伤害的单位
                attacker = hCaster,          --造成伤害的单位
                damage = damage_result,
                damage_type = DAMAGE_TYPE_MAGICAL
            }
			local num = ApplyDamage(damageTable)
		end
	end
end

function OnXianJi(	data )
	local opt = data.opt
	local caster = data.caster
	if opt == 1 then
		local sound = "Hero_EmberSpirit.FlameGuard.Loop"
		StopSoundEvent(sound, caster)
	elseif opt == 2 then
		local mana_consume = data.mana_consume
		if caster:GetMana()<mana_consume then
			local hAbility = caster:FindAbilityByName("antimage_xianji")
			hAbility:ToggleAbility()
			return
		end
		caster:ReduceMana(mana_consume)
	end
	
end

function OnVoodooHuiFu(	data )
	local opt = data.opt
	local caster = data.caster
	if opt == 1 then
		local sound = "Hero_WitchDoctor.Voodoo_Restoration.Loop"
		StopSoundEvent(sound, caster)
	elseif opt == 2 then
		local mana_consume = data.mana_consume
		if caster:GetMana()<mana_consume then
			local hAbility = caster:FindAbilityByName("witch_doctor_voodoo_restoration_new")
			hAbility:ToggleAbility()
			return
		end
		caster:ReduceMana(mana_consume)
	end
	
end


function OnSpecHuangwu( data )
	local hCaster = data.caster
	local radius = data.radius
	local attacked = data.target
	local bonus_damage = data.bonus_damage
	local ene_oth = FindUnitsInRadius(hCaster:GetTeam(), attacked:GetAbsOrigin(), nil,radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, 0, false)
	if #ene_oth==1 then
		local damageTable = 
			{
				victim = attacked,    --受到伤害的单位
	            attacker = hCaster,          --造成伤害的单位
	            damage = bonus_damage,
	            damage_type = DAMAGE_TYPE_PURE
	        }
		local num = ApplyDamage(damageTable)
		local pts = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_desolate.vpcf", 
					PATTACH_CUSTOMORIGIN,attacked	)
		ParticleManager:SetParticleControl(pts, 0, attacked:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(pts,0,hCaster:GetForwardVector(),Vector(0,0,0),Vector(0,0,0))
	end

end

function OnNaxUtl( data )
	local boshu = data.boshu
	local radius = data.radius
	local hCaster = data.caster
	local target = data.target
	local ability = data.ability
	local time = data.time
	local foward = target:GetForwardVector()
	local number = 4
	local unit_name = hCaster:GetUnitName()
	local x = foward.x
	local y = foward.y
	local z = foward.z
	local tt = time / 0.03
	local damage_result = 0
	if hCaster:IsRealHero() then
		damage_result=data.damage_base +data.damage_increase*hCaster:GetStrength()
	else
		damage_result=data.damage_base +data.damage_increase*hCaster:GetAttackDamage()
	end
	local bj = 0
	ability.dummy = {}
	local js = 0
	for i=1,number do
		local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
		local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
		local pos_new = target:GetAbsOrigin() + Vector(x_new,y_new,z)*radius
		ability.dummy[i] = CreateUnitByName(unit_name, pos_new, true, nil, nil,hCaster:GetTeamNumber())
		ability.dummy[i]:SetForwardVector(target:GetAbsOrigin()-ability.dummy[i]:GetAbsOrigin())
		ability.dummy[i]:AddAbility("dota_ability_dummy")
		local hAbility1 = ability.dummy[i]:FindAbilityByName("dota_ability_dummy")
		hAbility1:SetLevel(1)
	end
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("nax_utl"),
	function ()
		if js<tt*3 then
			for i=1,number do
				ability.dummy[i]:StartGesture(ACT_DOTA_CAST_ABILITY_4)
				local total = target:GetAbsOrigin() - ability.dummy[i]:GetAbsOrigin()
				local avg = total / tt
				ability.dummy[i]:SetAbsOrigin(ability.dummy[i]:GetAbsOrigin()+avg)
				js = js + 1
			end
			return 0.01
		else
			for i=1,number do
				ability.dummy[i]:Destroy()
			end
			local pts = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf",
			PATTACH_CUSTOMORIGIN,target)
			ParticleManager:SetParticleControl(pts,0, target:GetAbsOrigin()+Vector(0,0,400))
			ParticleManager:SetParticleControl(pts,1, target:GetAbsOrigin())
			target:EmitSound("Hero_LifeStealer.Consume")
			MyApplyDamage(hCaster,target:GetAbsOrigin(),radius,damage_result)
			return nil
		end
	end,0)
end

function OnTaiJi( data )
	local opt = data.opt
	local ability = data.ability
	if ability.hCaster == nil then
		ability.hCaster = data.caster
	end
	local pos_c = ability.hCaster:GetAbsOrigin()
	if opt == 1 then
		local damage_base = data.damage_base
		local damage_bonus = data.damage_bonus
		local damage_result = ability.hCaster:GetAgility() * damage_bonus + damage_base
		local targets = data.target_entities
		
		for i,v in ipairs(targets) do
			if v and v:IsAlive() then
				
				local damageTable = 
				{
					victim = v,    --受到伤害的单位
		            attacker = ability.hCaster,          --造成伤害的单位
		            damage = damage_result,
		            damage_type = DAMAGE_TYPE_PHYSICAL
		        }
				local num = ApplyDamage(damageTable)
			end
		end
	elseif opt == 2 then
		local distance = 3
		local target =  data.target
		if target:IsAlive() then
			local pos_v = target:GetAbsOrigin()
			local forward = pos_c - pos_v
			forward = forward:Normalized()
			local pos_new = pos_v + forward*distance
			target:SetAbsOrigin(pos_new)
			target:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) 
		end
	end
	
end

function OnSniperGe( data )
	local crit = data.crit
	local target = data.target
	local radius = 100
	local hCaster = data.caster
	local max_distance = 500
	local pos_t = target:GetAbsOrigin()
	local pos_c = hCaster:GetAbsOrigin()
	local angel = pos_t - pos_c
	local damage = hCaster:GetAttackDamage() * crit
	angel = angel:Normalized()
	--[[
	FindUnitsInLine( hCaster:GetTeamNumber(), vStart, vEnd , nil, fSize,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER  )]]
	target:EmitSound("Hero_Sniper.AssassinateDamage")
	local pts = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf",
		PATTACH_CUSTOMORIGIN,v)
	ParticleManager:SetParticleControl(pts,0, pos_t)
	ParticleManager:SetParticleControl(pts,1, pos_t+angel*600)
	for i=1,3 do
		local pos_new = angel*radius+pos_t
		local enemy = FindUnitsInRadius( hCaster:GetTeam(), pos_new, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
		for k,v in pairs(enemy) do
			if v and v~=target and v:IsAlive() then
				local damageTable = 
				{
					victim = v,    --受到伤害的单位
			        attacker = hCaster,          --造成伤害的单位
			        damage = damage,
			        damage_type = DAMAGE_TYPE_PHYSICAL
			    }
			    local num = ApplyDamage(damageTable)
			end
		end
		pos_t = pos_t + radius * 2
		radius = radius + 50
	end
end

function OnWuDuZhiZhen( data )
	local hCaster = data.caster
	local ability = data.ability
	local target = data.target
	local opt = data.opt
	if ability.dummy==nil then

		ability.dummy={}
	end
	if ability.pts==nil then
		ability.pts = {}
	end
	if opt == 1 then
		local foward = target:GetForwardVector()
		local number = 3
		local radius = 500
		local x = foward.x
		local y = foward.y
		local z = foward.z
		for i=1,number do
			local js = 0
			local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
			local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
			local pos_new = target:GetAbsOrigin() + Vector(x_new,y_new,z)*radius
			ability.dummy[i] = CreateUnitByName("npc_dota_troll_warlord_axe", pos_new, true, nil, nil,hCaster:GetTeam())
			ability.dummy[i]:SetOriginalModel("models/items/witchdoctor/wd_ward/ribbitar_ward/ribbitar_ward.vmdl")
			ability.dummy[i]:SetForwardVector(target:GetAbsOrigin()-ability.dummy[i]:GetAbsOrigin())

			ability.dummy[i]:StartGesture(ACT_DOTA_LOADOUT)

		end
		--particle start
		ability.pts[1] = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", 
				PATTACH_CUSTOMORIGIN, 
				hCaster)
		ParticleManager:SetParticleControl(ability.pts[1],0,ability.dummy[1]:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.pts[1],1,ability.dummy[2]:GetAbsOrigin())
		ability.pts[2] = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", 
				PATTACH_CUSTOMORIGIN, 
				hCaster)
		ParticleManager:SetParticleControl(ability.pts[2],0,ability.dummy[2]:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.pts[2],1,ability.dummy[3]:GetAbsOrigin())
		ability.pts[3] = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", 
				PATTACH_CUSTOMORIGIN, 
				hCaster)
		ParticleManager:SetParticleControl(ability.pts[3],0,ability.dummy[3]:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.pts[3],1,ability.dummy[1]:GetAbsOrigin())
	elseif opt == 2 then
		for i=1,3 do
			if ability.dummy[i] and ability.dummy[i]:IsAlive() then
				ability.dummy[i]:ForceKill(true) 
			end
			if ability.pts[i] then
				ParticleManager:DestroyParticle(ability.pts[i],true)
			end
		end
	elseif opt == 3 then
		for i=1,3 do
			local particle_name = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf"
			local projectile_speed = 1400
			local info = {
		        Target = target,
		        Source = ability.dummy[i],
		        Ability = ability,
		        EffectName = particle_name,
		        bDodgeable = false,
		        bProvidesVision = true,
		        iMoveSpeed = projectile_speed,
		        iVisionRadius = 0,
		        iVisionTeamNumber = hCaster:GetTeamNumber(),
		        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		    }
		    ProjectileManager:CreateTrackingProjectile( info )
		end
	end
end

function OnSpecZheshe( data )
	local hCaster = data.caster
	local radius = data.radius
	local zheshe = data.zheshe
	local totalDamage = data.totalDamage
	if data.reason and data.reason==1 then
		return 
	end
	if hCaster:IsIllusion() then
		return
	end
	hCaster:SetContextThink("dodamage",
	function()
		local targets = FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetAbsOrigin(), nil,radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, 0, false)
		if #targets == 0 then
			return
		end
		local damagePer = totalDamage / #targets
		--print(totalDamage)
		for i,v in ipairs(targets) do
			if v and v:IsAlive() then
				local damageTable = 
				{
					victim = v,
			        attacker = hCaster,
			        damage = totalDamage,
			        damage_type = DAMAGE_TYPE_PURE,
			        reason = 1
			    }
			    local num = ApplyDamage(damageTable)
			    local pts = ParticleManager:CreateParticle("particles/spectre_dispersion_ltx.vpcf", 
			   				PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
			    ParticleManager:SetParticleControl(pts, 0 , hCaster:GetAbsOrigin())
			    ParticleManager:SetParticleControl(pts, 1 , v:GetAbsOrigin())
			end
		end
	end, 0.5)
end

function OnLiXiaoJianFa( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = "modifier_jinada_datadriven"

	ability:StartCooldown(cooldown)

	caster:RemoveModifierByName(modifierName) 

	Timers:CreateTimer(cooldown, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
		end)	
end

function OnJiuYinZhenJing( data )
	local hCaster = data.caster
	local target = data.target
	local ability = data.ability
	local modifierName = "modifier_jiuyinzhenjing_debuff"
	if target:IsBuilding() then
		return
	end
	if target:HasModifier( modifierName ) then
		local current_stack = target:GetModifierStackCount( modifierName, ability )
		target:RemoveModifierByName( modifierName )
		ability:ApplyDataDrivenModifier( hCaster, target, modifierName, {} )
		target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( hCaster, target, modifierName, {} )
		target:SetModifierStackCount( modifierName, ability, 1 )
	end
end

function OnChouLan(data)
	local mana_reduce = data.mana_reduce
	local target = data.target
	local caster = data.caster
	target:ReduceMana(mana_reduce)
end

function OnCourierBack( data )
	local hCaster = data.caster
	local ent = Entities:FindByName(nil, "ent_base")
	if ent then
		local t_order = 
	    {                                       
	        UnitIndex = hCaster:entindex(), 
	        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
	        TargetIndex = nil, 
	        AbilityIndex = 0, 
	        Position = ent:GetAbsOrigin(),
	        Queue = 0 
	    }
		hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.1)
	end
end

function Blink(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local range = keys.range 
	local pos = caster:GetAbsOrigin()
	if range then
		local AbsolutePos = point - pos
		if AbsolutePos:Length2D()>range then
			local forward = AbsolutePos:Normalized()
			point = pos + forward*range
		end
	end
	FindClearSpaceForUnit(caster, point, false)	
end

function OnBaseAttacked( data )
	local hCaster = data.caster
	local ability = data.ability
	if ability:IsCooldownReady() then
		if hCaster:GetHealthPercent()<50 then
			Notifications:TopToAll({text="#zaoshougongji",duration=2,style={color="red"}})
			Notifications:TopToAll({text="#dangqianxueliang",duration=2,style={color="red"},continue=true})
			Notifications:TopToAll({text=hCaster:GetHealth().." / "..hCaster:GetMaxHealth(),duration=2,style={color="red"},continue=true})
		else
			Notifications:TopToAll({text="#zaoshougongji",duration=2,style={color="red"},continue=false})
		end
		ability:StartCooldown(4)
	end
end

function OnJiuTianXuanNv( event )
	local ability = event.event_ability
	if not ability:IsItem() then
		ability:EndCooldown()
	end
end


function PrintTable (t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= 'table' then return end
	
	done = done or {}
	done[t] = true
	indent = indent or 0
	
	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end
	
	table.sort(l)
	for k, v in ipairs(l) do
		local value = t[v]
		
		if type(value) == "table" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..":")
			PrintTable (value, indent + 1, done)
		elseif type(value) == "userdata" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
			PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		else
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		end
	end
end

function OnCreepRebornDestroyed( event )
	local hCaster = event.caster
	hCaster:SetHealth(hCaster:GetMaxHealth())
	hCaster:RemoveEffects(EF_NODRAW)

end

function OnCreepRebornCreated( event )
	local hCaster = event.caster
	hCaster:AddEffects(EF_NODRAW)
	hCaster:Purge(true, true, false, true,false)
	local particleName = event.particleName
	local duration = event.duration
	local pts = ParticleManager:CreateParticle(particleName,PATTACH_WORLDORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts,0,hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pts,2,Vector(duration,0,0))
	ParticleManager:ReleaseParticleIndex(pts)
end

function OnTeleport( event )
	local hero = event.caster
	local id = hero:GetPlayerOwnerID()
	local ent_base = Entities:FindByName(nil,"ent_base")
	local aim = ent_base:GetAbsOrigin()

	MoveUnitAndCamera(hero,id,aim)
end

function MoveUnitAndCamera(hero,id,aim)
	FindClearSpaceForUnit(hero, aim, false) 
	hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
    hero:Stop()
    --[[PlayerResource:SetCameraTarget(id, hero)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera"),
    function (  ) PlayerResource:SetCameraTarget(id, nil) end,0.1)]]
end

function ApplyMagicalDamageImplifyModifier( event )
	--PrintTable(event)
	
	local hCaster = event.caster
	local target = hCaster
	local ability = event.ability
	local bonus_percent = event.bonus_percent
	if target:HasModifier("modifier_ltx_magical_damage_bonus_percent") then
		local hModifier = target:FindModifierByName("modifier_ltx_magical_damage_bonus_percent")
	else
		target:AddNewModifier(hCaster,ability,"modifier_ltx_magical_damage_bonus_percent",{bonus_percent=bonus_percent})
	end
	
end

function OnLianJi( event )
	local hCaster = event.caster
	local target = event.target 
	local ability = event.ability
	hCaster:PerformAttack(target,false,false,true,true,false)
end

function healForCalcu(event) 

	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local attack_damage = event.attack_damage
	local per = event.per 
	local healAmount = attack_damage*per/100
	target:Heal(healAmount,ability)

end

function tZQLFT( event )
	local hCaster = event.caster

	local ability = event.ability
	local target = event.target 
	local attack_damage = event.attack_damage
	local fantan = event.fantan
	local damageTable = 
	{
		victim = target,    --受到伤害的单位
        attacker = hCaster,          --造成伤害的单位
        damage = attack_damage*fantan/100,
        damage_type = DAMAGE_TYPE_PURE
    }
	local num = ApplyDamage(damageTable)
end