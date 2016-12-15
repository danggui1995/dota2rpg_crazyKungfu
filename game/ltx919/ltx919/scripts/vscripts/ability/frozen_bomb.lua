function ShowParticle( keys )
	-- body
	local targetPos = keys.target
	local ability = keys.ability
	ability.target = targetPos
	ability.nIceIndex = ParticleManager:CreateParticle(
		"particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf", 
		PATTACH_POINT, 
		targetPos)
	EmitSoundOn("hero_Crystal.freezingField.wind",targetPos)
end

function EndDummys( keys )
	local ability = keys.ability
	StopSoundOn("hero_Crystal.freezingField.wind",keys.target)
	ParticleManager:DestroyParticle(ability.nIceIndex,false)
end

function OnInterrupt( data )
	local ability = data.ability
	local hCaster = data.hCaster
	if not ability.target then
		return
	end
	local modifierName = ability.target:FindModifierByName("modifier_frozen")
	if modifierName then
		ability.target:RemoveModifierByName("modifier_frozen")
	end
end