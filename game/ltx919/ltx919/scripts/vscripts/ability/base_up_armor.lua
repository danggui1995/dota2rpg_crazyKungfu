if base_up_armor == nil then
	base_up_armor = class({})
end

function OnBaseUpArmor(keys)
	-- body
	-- 获取施法者
	

	local ent =  Entities:FindByName(nil, "ent_base") 
	
	--local nPlayerId = hCaster:GetPlayerID()
	
	-- 获取技能目标列表
	--local thTarget = keys.target_entities

	--if not thTarget then print('damage no target') return end

	-- 获取主属性值
	--local primary_value = hCaster:GetPrimaryStatValue() 

	-- 获取技能等级
	--local ability_level = keys.ability:GetLevel() 

	-- 获取英雄等级
	--local hero_level = hCaster:GetLevel()

	-- 获取敌方等级
	--local target_level = thTarget[1]:GetLevel()

	local tmp_armor = ent:GetPhysicalArmorValue() 
	local armor_add = 10
	EmitSoundOn("Hero_Lich.FrostArmor",	ent )

	ent:SetPhysicalArmorBaseValue(armor_add+tmp_armor)
	local nIceIndex = ParticleManager:CreateParticle(
		"particles/omniknight_purification_ltx.vpcf", 
		PATTACH_CUSTOMORIGIN, 
		ent)
    ParticleManager:SetParticleControl(nIceIndex, 0, ent:GetOrigin())
    ParticleManager:SetParticleControl(nIceIndex, 1, Vector(300,300,300))
    
	 --[[选定各个目标单位
	for _,v in pairs(thTarget) do
		local damage_table = {
			victim = v,
			attacker = hCaster,
			damage = damage_to_deal,
			damage_type = DAMAGE_TYPE_PURE, 
	    	damage_flags = 0
		}
		ApplyDamage(damage_table)
	end
	
	local hIceEffect = CreateUnitByName(
	        "npc_CFroged_unit_CrystalMaiden_iceEffect"
		    ,thTarget[1]:GetOrigin()
		    ,false
		    ,hCaster
		    ,hCaster
	     	,hCaster:GetTeam()
    	)
    	local nIceIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_shards.vpcf", PATTACH_CUSTOMORIGIN, hIceEffect)
    		
    	ParticleManager:SetParticleControl(nIceIndex, 0, thTarget[1]:GetOrigin())
		ParticleManager:SetParticleControl(nIceIndex, 1, thTarget[1]:GetOrigin())
		
      	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString('Release_Effect'),
    	function ()
	        hIceEffect:Destroy()
			print('[CrystalMaiden01]Release Effect!')
	    	return nil
    	end,3)--]]
end

function OnBaseUpHealth( keys )
	local hCaster = EntIndexToHScript(keys.caster_entindex)
	local maxHealth = hCaster:GetMaxHealth()
	local curHealth = hCaster:GetHealth()
	local addHealth = 1000
	hCaster:SetMaxHealth(maxHealth + addHealth)
	hCaster:SetHealth(curHealth + addHealth) 
	EmitSoundOn("Hero_Chen.HandOfGodHealHero", keys.caster )
	local nIceIndex = ParticleManager:CreateParticle(
		"particles/omniknight_purification_ltx.vpcf", 
		PATTACH_CUSTOMORIGIN, 
		hCaster)
    ParticleManager:SetParticleControl(nIceIndex, 0, hCaster:GetOrigin())
    ParticleManager:SetParticleControl(nIceIndex, 1, Vector(300,300,300))
end

function OnRefresh( keys )
	local hCaster = EntIndexToHScript(keys.caster_entindex)
	keys.ability:EndCooldown()
	local pre_gold = hCaster:GetGold()
	hCaster:ModifyGold(2000,true,1)
end