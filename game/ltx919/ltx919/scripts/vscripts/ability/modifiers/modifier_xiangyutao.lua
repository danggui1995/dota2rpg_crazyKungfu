if modifier_xiangyutao == nil then
    modifier_xiangyutao = class({})
end

function modifier_xiangyutao:OnCreated()
	self.attack = 150
	self.strength = 95
	self.agility = 120
	self.miss = 50
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_xiangyutao:GetTexture()
	return "modifier_xiangyutao"
end

function modifier_xiangyutao:IsHidden()
	return false
end

function modifier_xiangyutao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}

	return funcs
end

function modifier_xiangyutao:GetModifierPreAttack()
	return self.attack
end

function modifier_xiangyutao:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_xiangyutao:GetModifierBonusStats_Agility()
	return self.agility
end

function modifier_xiangyutao:GetModifierMiss_Percentage(params )
	return self.miss
end