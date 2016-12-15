if modifier_houyitao == nil then
    modifier_houyitao = class({})
end

function modifier_houyitao:OnCreated()
	self.strength = 30
	self.agility = 30
	self.attack = 90
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_houyitao:GetTexture()
	return "modifier_houyitao"
end

function modifier_houyitao:IsHidden()
	return false
end

function modifier_houyitao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}

	return funcs
end

function modifier_houyitao:GetModifierPreAttack_BonusDamage()
	return self.attack
end

function modifier_houyitao:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_houyitao:GetModifierBonusStats_Agility()
	return self.agility
end
