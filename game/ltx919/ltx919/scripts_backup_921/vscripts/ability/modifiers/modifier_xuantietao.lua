if modifier_xuantietao == nil then
    modifier_xuantietao = class({})
end

function modifier_xuantietao:OnCreated()
	self.armor = -75
	self.strength = 15
	self.agility = 60
	self.intellect = 15
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_xuantietao:GetTexture()
	return "modifier_xuantietao"
end

function modifier_xuantietao:IsHidden()
	return false
end

function modifier_xuantietao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_xuantietao:GetModifierBonusStats_Intellect()
	return self.intellect
end

function modifier_xuantietao:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_xuantietao:GetModifierBonusStats_Agility()
	return self.agility
end

function modifier_xuantietao:OnAttackLanded(params )
	local target = params.target 
	if not target:HasModifier("modifier_xuantietao_debuff") then
		target:AddNewModifier(self:GetParent(),nil,"modifier_xuantietao_debuff",{})
	end
end