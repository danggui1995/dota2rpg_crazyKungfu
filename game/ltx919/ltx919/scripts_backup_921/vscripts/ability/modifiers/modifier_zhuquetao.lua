if modifier_zhuquetao == nil then
    modifier_zhuquetao = class({})
end

function modifier_zhuquetao:OnCreated()
	self.intellect = 120
	self.strength = 25
	self.agility = 25
	self.duration = 2
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_zhuquetao:GetTexture()
	return "modifier_zhuquetao"
end

function modifier_zhuquetao:IsHidden()
	return false
end

function modifier_zhuquetao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_zhuquetao:GetModifierBonusStats_Intellect()
	return self.intellect
end

function modifier_zhuquetao:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_zhuquetao:GetModifierBonusStats_Agility()
	return self.agility
end

function modifier_zhuquetao:OnAttackLanded(params )
	if IsServer() then
		local rd = RandomInt(1,100)
		if rd<80 then
			return 0
		end
		local parent = self:GetParent()
		if params.attacker == parent and ( not parent:IsIllusion() ) then
			if parent:PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= parent:GetTeamNumber() then
				target:AddNewModifier(parent, self:GetAbility(), "modifier_voodoo_lua", {duration = self.duration})
			end
		end
	end
	
	return 0
end