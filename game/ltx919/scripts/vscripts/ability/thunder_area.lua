function ShowParticle( keys )
	-- body
	local targetPos = keys.target
	local ability = keys.ability
	local duration = keys.duration
	ability.nIceIndex = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_razor/razor_rain_storm.vpcf", 
		PATTACH_POINT, 
		targetPos)
	EmitSoundOn("Hero_Razor.Storm.Cast",keys.caster)
end

function RandomPositionInRange(	entities,range )
	local ent_pos = entities:GetAbsOrigin()
	local rd_x = RandomInt(1, range)
	local rd_y = RandomInt(1,math.sqrt(range*range - rd_x*rd_x))
	local rd_bool1 = RandomInt(1,2)
	local rd_bool2 = RandomInt(1,2)
	local x = ent_pos.x
	local y = ent_pos.y
	local z = ent_pos.z
	if rd_bool1 == 1 then
		if rd_bool2 == 1 then
			x = rd_x + x
			y = rd_y + y
		else
			x = rd_x + x
			y = y - rd_y
		end
	else
		if rd_bool2 == 1 then
			x = x - rd_x
			y = rd_y + y
		else
			x = x - rd_x
			y = y - rd_y
		end
	end
	return Vector(x,y,z)
end


function thunder_damage(keys)
	local ability_temp = keys.ability
	local hCaster = keys.caster
	local targetPos = keys.target
	local range = keys.range
	local xy = RandomPositionInRange(targetPos,range)

	if hCaster:GetContext("thunder_area_context")==1 then	
		local pts = ParticleManager:CreateParticle(
						"particles/sven_warcry_cast_arc_lightning_ltx.vpcf", 
						PATTACH_POINT, 
						targetPos)
		ParticleManager:SetParticleControl(pts, 0, xy)
		EmitSoundOnLocationWithCaster(xy,"Hero_Zuus.LightningBolt",hCaster)
		local targets = FindUnitsInRadius(hCaster:GetTeam(), xy, nil,200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, 0, false)
		local damage_result=keys.damage_base +
					keys.damage_increase
					*keys.caster:GetIntellect()
		for i, v in ipairs(targets) do
			if v and IsValidEntity(v) and v:IsAlive() then
				
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
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("temp1"),
						function()
							ParticleManager:DestroyParticle(pts,false)	
						end
					, 0.8)
	else
		ParticleManager:DestroyParticle(ability_temp.nIceIndex,false)	
	end

end

function StateChange_1( keys )
	-- body
	keys.caster:SetContextNum("thunder_area_context",1,0)
end


function StateChange_0( keys )
	-- body
	keys.caster:SetContextNum("thunder_area_context",0,0)
end

function EndDummys( keys )
	-- body
	local ability = keys.ability
	StateChange_0(keys)
	ParticleManager:DestroyParticle(ability.nIceIndex,false)
end