if modifier_qixingbaodao == nil then
    modifier_qixingbaodao = class({})
end

function modifier_qixingbaodao:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_qixingbaodao:GetTexture()
	return "qixingbaodao"
end

function modifier_qixingbaodao:IsHidden()
	return false
end

function modifier_qixingbaodao:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSORB_SPELL
	}

	return funcs
end



function modifier_qixingbaodao:GetAbsorbSpell(keys)
	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() then
		--your cool effect here.
		hAbility:StartCooldown(20)
		return 1
	end
	return 0
end
