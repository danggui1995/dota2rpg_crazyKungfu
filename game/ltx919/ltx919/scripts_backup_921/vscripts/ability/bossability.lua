

function UrsaE( data )
	local effect_name = data.effect_name
	local radius = data.radius
	local hCaster = data.caster
	local x_offset,y_offset = CircleAndRotate(radius)
	for i=1,5 do
		local pts = ParticleManager:CreateParticle(effect_name,PATTACH_WORLDORIGIN,hCaster) 
		ParticleManager:SetParticleControl(pts, 0, hCaster:GetAbsOrigin() + Vector( x_offset[i], y_offset[i], 0.0))	
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("deletpts"), 
	    	function(  )
	    		ParticleManager:DestroyParticle(pts,true)
	    		return nil
	    	end
	    , 1)
	end 
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