if modifier_zhenhuntao == nil then
    modifier_zhenhuntao = class({})
end

function modifier_zhenhuntao:OnCreated()
	self.duration = 10
	self.strength = 30
	self.agility = 30
	self.intellect = 90
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_zhenhuntao:GetTexture()
	return "modifier_zhenhuntao"
end

function modifier_zhenhuntao:IsHidden()
	return false
end

function modifier_zhenhuntao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_zhenhuntao:GetModifierBonusStats_Intellect()
	return self.intellect
end

function modifier_zhenhuntao:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_zhenhuntao:GetModifierBonusStats_Agility()
	return self.agility
end

function modifier_zhenhuntao:OnAttackLanded(params )
	local target = params.target 
	target:AddNewModifier(self:GetParent(),nil,"modifier_silence",{duration = self.duration})
end