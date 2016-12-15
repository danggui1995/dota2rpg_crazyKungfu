if modifier_ltx_magical_damage_bonus_percent == nil then
    modifier_ltx_magical_damage_bonus_percent = class({})
end

function modifier_ltx_magical_damage_bonus_percent:OnCreated(kv)
	self.bonus_percent = kv.bonus_percent or 100
end


function modifier_ltx_magical_damage_bonus_percent:IsHidden()
	return true
end