modifier_xingtiantao_debuff_debuff = class({})

--------------------------------------------------------------------------------

function modifier_xingtiantao_debuff:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_xingtiantao_debuff:OnCreated( kv )
	self.bonus_damage_pct = -30
end

--------------------------------------------------------------------------------

function modifier_xingtiantao_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_xingtiantao_debuff:GetModifierBaseDamageOutgoing_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end
	return self.bonus_damage_pct
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

