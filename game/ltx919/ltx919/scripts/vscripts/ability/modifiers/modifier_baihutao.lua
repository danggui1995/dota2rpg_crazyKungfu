if modifier_baihutao == nil then
    modifier_baihutao = class({})
end

function modifier_baihutao:OnCreated()
	self.cleave = 0.4
	self.agility = 70
	self.intellect = 30
	self.health = 2000
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_baihutao:GetTexture()
	return "modifier_baihutao"
end

function modifier_baihutao:IsHidden()
	return false
end

function modifier_baihutao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_baihutao:GetModifierBonusStats_Intellect()
	return self.intellect
end

function modifier_baihutao:GetModifierHealthBonus()
	return self.strength
end

function modifier_baihutao:GetModifierBonusStats_Agility()
	return self.agility
end

function modifier_baihutao:OnAttackLanded(params )
	local target = params.target 
	local caster = self:GetParent()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), 
		caster:GetOrigin(),caster,300,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
	local attack = caster:GetAttackDamage()*self.cleave
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil and not enemy:IsInvulnerable() then

				local damage = {
					victim = enemy,
					attacker = caster,
					damage = attack
					damage_type = DAMAGE_TYPE_PHYSICAL
				}

				ApplyDamage( damage )
			end
		end
	end
end