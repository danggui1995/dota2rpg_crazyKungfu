
function HunterInTheNight( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier

	if not GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	else
		if caster:HasModifier(modifier) then caster:RemoveModifierByName(modifier) end
	end
end

function Void( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier_day = keys.modifier_day
	local modifier_night = keys.modifier_night
	local duration_day = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	if GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_day, {duration = duration})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_night, {duration = duration})
	end
end