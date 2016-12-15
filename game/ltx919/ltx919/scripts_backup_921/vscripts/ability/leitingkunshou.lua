function CastSpirits( event )
	local caster	= event.caster
	local target = event.target
	local ability	= event.ability
	ability.spirits_startTime = GameRules:GetGameTime()
	ability.radius = event.default_radius
	local foward = target:GetForwardVector()
	ability.dummy = {}
	ability.particle = {}
	local x = foward.x
	local y = foward.y
	local z = foward.z
	local number = 24
	for i=1,number do
		local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
		local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
		local pos_new = target:GetAbsOrigin() + Vector(x_new,y_new,z)*ability.radius
		ability.dummy[i] = CreateUnitByName("npc_dota_dummy_caster", pos_new, true, nil,nil, DOTA_TEAM_GOODGUYS)
		--ability:ApplyDataDrivenModifier( caster, ability.dummy[i], event.spirit_modifier, {} )
		ability.particle[i] = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest/razor_static_link_beam_blade.vpcf", 
							PATTACH_CUSTOMORIGIN, 
							ability.dummy[i])
		ParticleManager:SetParticleControl(ability.particle[i],0, ability.dummy[i]:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.particle[i],1, ability.dummy[i]:GetAbsOrigin()+Vector(0,0,350))
	end
end

function ThinkSpirits( event )
	local caster	= event.caster
	local ability	= event.ability
	local target = event.target
	local casterOrigin	= target:GetAbsOrigin()
	local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime	
	local currentRadius	= ability.radius
	local currentRotationAngle	= elapsedTime * event.spirit_turn_rate
	local rotationAngleOffset	= 360 / 24
	local numSpiritsAlive = 0
	for i=1,24 do
		local sss = ability.dummy[i]
		local rotationAngle = currentRotationAngle - rotationAngleOffset * ( i - 1 )
		local relPos = Vector( 0, currentRadius, 0 )
		relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )
		local absPos = GetGroundPosition( relPos + casterOrigin, v )
		sss:SetAbsOrigin( absPos )
		ParticleManager:SetParticleControl(ability.particle[i],0, ability.dummy[i]:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.particle[i],1, ability.dummy[i%12+1]:GetAbsOrigin()+Vector(0,0,350))
	end
end

function OnDestroySpirit( event )
	local spirit	= event.target
	local ability	= event.ability
	StopSoundEvent( "Ability.static.loop", spirit )
	if spirit and spirit:IsAlive() then
		local pts = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", 
							PATTACH_CUSTOMORIGIN, 
							spirit)
		ParticleManager:SetParticleControl(pts,0, spirit:GetAbsOrigin()+Vector(0,0,400))
		ParticleManager:SetParticleControl(pts,2, spirit:GetAbsOrigin())
	end
	for i=1,24 do
		
		ability.dummy[i]:ForceKill(true)
		ability.dummy[i] = nil
		ParticleManager:DestroyParticle(ability.particle[i], false)
		ability.particle[i] = nil 

	end
end

function StopSound( event )
	
end