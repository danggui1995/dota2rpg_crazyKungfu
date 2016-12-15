if modifier_xingtiantao == nil then
    modifier_xingtiantao = class({})
end

function modifier_xingtiantao:OnCreated()
	self.strength = 120
	self.agility = 30
	self.attack_reduce = -30
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_xingtiantao:GetTexture()
	return "modifier_xingtiantao"
end

function modifier_xingtiantao:IsHidden()
	return false
end

function modifier_xingtiantao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}

	return funcs
end

function modifier_xingtiantao:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_xingtiantao:GetModifierBonusStats_Agility()
	return self.agility
end


function modifier_xingtiantao:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_xingtiantao:GetModifierAura()
	return "modifier_xingtiantao_debuff"
end

--------------------------------------------------------------------------------

function modifier_xingtiantao:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_xingtiantao:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

--------------------------------------------------------------------------------

function modifier_xingtiantao:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_xingtiantao:GetAuraRadius()
	return 600
end
