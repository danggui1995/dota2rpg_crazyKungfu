if modifier_xuantietao_debuff == nil then
    modifier_xuantietao_debuff = class({})
end

function modifier_xuantietao_debuff:OnCreated()
	self.armor = -75
end

function modifier_xuantietao_debuff:GetTexture()
	return "modifier_xuantietao_debuff"
end

function modifier_xuantietao_debuff:IsHidden()
	return false
end

function modifier_xuantietao_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_xuantietao_debuff:GetModifierPhysicalArmorBonus()
	return self.armor
end