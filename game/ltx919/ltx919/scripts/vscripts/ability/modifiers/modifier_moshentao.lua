if modifier_moshentao == nil then
    modifier_moshentao = class({})
end

function modifier_moshentao:OnCreated()
	self.strength = 100
	self.agility = 100
	self.intellect = 100
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_moshentao:GetTexture()
	return "modifier_moshentao"
end

function modifier_moshentao:CheckState()
	local state = {
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end


function modifier_moshentao:IsHidden()
	return false
end

function modifier_moshentao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}

	return funcs
end

function modifier_moshentao:GetModifierBonusStats_Intellect()
	return self.intellect
end

function modifier_moshentao:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_moshentao:GetModifierBonusStats_Agility()
	return self.agility
end
