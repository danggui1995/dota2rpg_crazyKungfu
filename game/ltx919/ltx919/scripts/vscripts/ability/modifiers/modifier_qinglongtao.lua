if modifier_qinglongtao == nil then
    modifier_qinglongtao = class({})
end

function modifier_qinglongtao:OnCreated()
	self.armor = 45
	self.strength = 120
	self.agility = 60
	self.fantan = 0.2
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_qinglongtao:GetTexture()
	return "modifier_qinglongtao"
end

function modifier_qinglongtao:IsHidden()
	return false
end

function modifier_qinglongtao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_qinglongtao:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_qinglongtao:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_qinglongtao:GetModifierBonusStats_Agility()
	return self.agility
end

function modifier_qinglongtao:OnTakeDamage(params )
	if IsServer() then
		local parent = self:GetParent()
		local damage = params.attack_damage
		local attacker = params.attacker --attacker????
		if parent ~= attacker then
			if parent:PassivesDisabled() then
				return 0
			end
			if attacker ~= nil and attacker:GetTeamNumber() ~= attacker:GetTeamNumber() then
				parent:SetContextThink("ApplyDamage",
				function()
					ApplyDamage({ victim = attacker, attacker = parent, damage = attack_damage*self.fantan, damage_type = DAMAGE_TYPE_MAGICAL })
				end,0.1)
			end
		end
	end
	
	return 0
end