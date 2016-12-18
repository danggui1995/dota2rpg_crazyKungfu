if modifier_fire_type_lua == nil then
    modifier_fire_type_lua = class({})
end

function modifier_fire_type_lua:OnCreated()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_fire_type_lua:GetTexture()
	return "modifier_fire"
end

function modifier_fire_type_lua:IsDebuff()
	return true
end

function modifier_fire_type_lua:IsPurgable()
	return true
end

function modifier_fire_type_lua:DeclareFunctions()
	local funcs = {
	}

	return funcs
end