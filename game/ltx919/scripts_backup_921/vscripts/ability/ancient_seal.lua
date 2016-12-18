require('libraries/timers')

function Begin( keys )
	local target = keys.target
	local time = keys.default_time
	local radius = keys.default_radius
	local hCaster = keys.caster
	local ability = keys.ability
	local x_offset,y_offset = CircleAndRotate(radius)
	ability.dummy_oracle = {}
	for i=1,5 do
		ability.dummy_oracle[i] = CreateUnitByName("npc_dota_dummy_oracle", target:GetAbsOrigin() + Vector( x_offset[i], y_offset[i], 0.0), false, hCaster, hCaster, hCaster:GetTeam())
	    local origin_sour = ability.dummy_oracle[i]:GetOrigin()
		local origin_dest = target:GetOrigin()
		ability.dummy_oracle[i]:SetForwardVector(SetFaceAngle(origin_dest,origin_sour))
		if target then
			if not target:IsAlive() then
				ability.dummy_oracle[i]:ForceKill(true)
			end
		end
		
	end
end

function RepeatAnim( data)
	local ability = data.ability
	local target = data.target
	for i=1,5 do
		ability.dummy_oracle[i]:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	end
	local nIceIndex = ParticleManager:CreateParticle(
	"particles/heroes/lixinning/ability_lixinning04_explosion_inside_a.vpcf", 
	PATTACH_CUSTOMORIGIN, 
	target)
	ParticleManager:SetParticleControl(nIceIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(nIceIndex, 1, target:GetOrigin())
	Timers:CreateTimer(0.6,
	function(  )
		ParticleManager:DestroyParticle(nIceIndex,false)
		return nil
	end)
	EmitSoundOn("Hero_Phoenix.IcarusDive.Cast",target)
end

function CircleAndRotate( radius_new )
	local v1 = math.sin(3.14159/10) * radius_new
	local v2 = math.cos(3.14159/10) * radius_new
	local v3 = math.sin(0.2*3.14159) * radius_new
	local v4 = math.cos(0.2*3.14159) * radius_new
	local x_offset = { -v2, 0, v2, -v4, v4}
	local y_offset = { v1, radius_new, v1, -v3, -v3}
	return x_offset,y_offset
end

function SetFaceAngle( origin_dest,origin_sour )
	local x = origin_dest.x - origin_sour.x
	local y = origin_dest.y - origin_sour.y
	local z = origin_dest.z - origin_sour.z
	return Vector(x,y,z)
end

function EndDummys( keys )
	local ability = keys.ability
	for i=1,5 do
		if ability.dummy_oracle[i] then
			if ability.dummy_oracle[i]:IsAlive() then
				ability.dummy_oracle[i]:ForceKill(true)
			end
		end
	end
end