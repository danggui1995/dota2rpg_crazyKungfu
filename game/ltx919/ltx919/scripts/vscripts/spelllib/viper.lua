
function Nethertoxin( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target:IsBuilding() then
		return
	end
	local HPLoss = target:GetMaxHealth() - target:GetHealth()
	local xs = data.damage
	local total_damage = xs * HPLoss
	local damage_table = 
	{
		victim = target,
		attacker = caster,
		damage = total_damage,
		damage_type = DAMAGE_TYPE_PHYSICAL
	}
	ApplyDamage( damage_table )
end