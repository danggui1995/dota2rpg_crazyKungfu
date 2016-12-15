function EquipOrb( event )
	print("EquipOrb")

	local caster = event.caster
	if caster:IsHero() then
		if not caster.original_attack then
			caster.original_attack = 	(caster)
		end
		SetAttacksEnabled(caster, "ground, air")
	end
end

function GetAttacksEnabled( unit )
    local unitName = unit:GetUnitName()
    local attacks_enabled

    if unit:IsHero() then
        attacks_enabled = GameRules.HeroKV[unitName]["AttacksEnabled"]
    elseif GameRules.UnitKV[unitName] then
        attacks_enabled = GameRules.UnitKV[unitName]["AttacksEnabled"]
    end

    return attacks_enabled or "ground"
end

function SetAttacksEnabled( unit, attack_string )
    local unitName = unit:GetUnitName()

    if unit:IsHero() then
        GameRules.HeroKV[unitName]["AttacksEnabled"] = attack_string
    elseif GameRules.UnitKV[unitName] then
        GameRules.UnitKV[unitName]["AttacksEnabled"] = attack_string
    end
end

function UnequipOrb( event )
	print("UnequipOrb")

	local caster = event.caster
	if caster:IsHero() then
		print("Set Attacks Enabled to ",caster.original_attack)
		SetAttacksEnabled(caster, caster.original_attack)

		if caster.original_attack_type then
			caster:SetAttackCapability(caster.original_attack_type)
		end
	end
end

function OrbAirCheck( event )
	local attacker = event.attacker
	local target = event.target
	local target_type = GetMovementCapability(target)
	if not attacker.original_attack_type then
		attacker.original_attack_type = attacker:GetAttackCapability()
	end
	if target_type == "air" then
		attacker:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	else
		attacker:SetAttackCapability(attacker.original_attack_type)
	end
end