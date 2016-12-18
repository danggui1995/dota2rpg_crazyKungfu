if modifier_xunshoujingtong_lua == nil then
    modifier_xunshoujingtong_lua = class({})
end


function modifier_xunshoujingtong_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function modifier_xunshoujingtong_lua:OnCreated()
	--[[local bonus = self:GetAbility():GetSpecialValueFor( "bonus" )
	self.hCaster = self:GetCaster()
	self.hp = math.floor(self.hCaster:GetHealth()*bonus/100)
	self.armor = math.floor(self.hCaster:GetPhysicalArmorValue()*bonus/100)
	self.damage = math.floor(self.hCaster:GetAttackDamage()*bonus/100)]]
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, false )
		--self:StartIntervalThink(5) 
	end
end

function modifier_xunshoujingtong_lua:IsPurgable()
	return false
end

function modifier_xunshoujingtong_lua:OnIntervalThink()
	--[[local bonus = self:GetAbility():GetSpecialValueFor( "bonus" )
	self.hCaster = self.hCaster or self:GetCaster()
	self.hp = math.floor(self.hCaster:GetHealth()*bonus/100)
	self.armor = math.floor(self.hCaster:GetPhysicalArmorValue()*bonus/100)
	self.damage = math.floor(self.hCaster:GetAttackDamage()*bonus/100)]]
end

function modifier_xunshoujingtong_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}

	return funcs
end

function modifier_xunshoujingtong_lua:GetModifierPreAttack_BonusDamage( params )
	if IsServer() then
		return math.floor(self:GetAbility():GetSpecialValueFor( "bonus" ) * self:GetCaster():GetAverageTrueAttackDamage())
	end
end

function modifier_xunshoujingtong_lua:GetModifierPhysicalArmorBonus( params )
	if IsServer() then
		return math.floor(self:GetCaster():GetPhysicalArmorBaseValue()*self:GetAbility():GetSpecialValueFor( "bonus" )/100)
	end
end

function modifier_xunshoujingtong_lua:GetModifierExtraHealthBonus( params )
	if IsServer() then
		return math.floor(self:GetAbility():GetSpecialValueFor( "bonus" )/100*(self:GetCaster():GetHealth()))
	end
end

