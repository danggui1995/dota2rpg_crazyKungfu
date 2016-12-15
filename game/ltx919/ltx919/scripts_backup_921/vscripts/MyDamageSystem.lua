--[[
	written by 李天行 in csust 2016/1/10
	how to use:
	"RunScript"
	{
		"ScriptFile"		"scripts/vscripts/MyDamageSystem.lua"
		"Function"			"Damage"
		"formula"			"%damage# * ss_GetIntellect_ss + st_GetIntellect_st"
		"Type"				"DAMAGE_TYPE_MAGICAL"
		"Flags"				"DOTA_UNIT_TARGET_FLAG_INVULNERABLE | DOTA_DAMAGE_FLAG_NON_LETHAL" 
		"Target"			"TARGET"
	}
]]
local function stringSplit(str, sep)
    if type(str) ~= 'string' or type(sep) ~= 'string' then
        return nil
    end
    local res_ary = {}
    local cur = nil
    for i = 1, #str do
        local ch = string.byte(str, i)
        local hit = false
        for j = 1, #sep do
            if ch == string.byte(sep, j) then
                hit = true
                break
            end
        end
        if hit then
            if cur then
                table.insert(res_ary, cur)
            end
            cur = nil
        elseif cur then
            cur = cur .. string.char(ch)
        else
            cur = string.char(ch)
        end
    end
    if cur then
        table.insert(res_ary, cur)
    end
    return res_ary
end



function Damage( data )
	local caster = data.caster
	local targets = data.target_entities
	local formula = data.formula
	local ability = data.ability
	local damage_type = data.Type
	if not (caster and targets and ability and formula and #targets > 0) then return end
	local damage = {}
local function getvalue( formula )
	return loadstring("return " .. formula)()
end
	damage.attacker = caster
	damage.damage_type = _G[damage_type] or DAMAGE_TYPE_PURE

	local nDamageFlags = 0
	if damage.Flags and type(damage.Flags) == "string" then
	        local sDamageFlags = string.gsub(damage.Flags," ","")
	        local vDamageFlags = stringSplit(sDamageFlags,"|")
	        for _,flag in pairs(vDamageFlags) do
	                nDamageFlags = nDamageFlags + (_G[flag] or 0)
	        end
	end

	damage.damage_flags = nDamageFlags
	local formula_string = formula
	print(formula_string)
	formula_string = string.gsub(formula_string,"AbilityDamage","ability:GetAbilityDamage()")
	formula_string = string.gsub(formula_string,"s_lv","caster:GetLevel()")
	formula_string = string.gsub(formula_string,"t_lv","target:GetLevel()")
	formula_string = string.gsub(formula_string,"sp_",ability:GetLevelSpecialValueFor()
	formula_string = string.gsub(formula_string,"_sp","\", ability:GetLevel() - 1)")
	formula_string = string.gsub(formula_string,"ss_","caster:")
	formula_string = string.gsub(formula_string,"_ss","()")
	formula_string = string.gsub(formula_string,"st_","target:")
	formula_string = string.gsub(formula_string,"_st","()")
	print(formula_string)
	print(ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1))
	for _, target in pairs(targets) do
        if target:IsAlive() then
            damage.victim = target
            print(formula_string)
            damage.damage = getvalue(formula_string)
            if data.custom_type and data.custom_type == "fire" and target:HasModifier("modifier_fire_type_lua") then
                damage.damage = damage.damage * ((target:GetModifierStackCount("modifier_fire_type_lua",nil)-1) * 0.2 + 1)
            end
            print("DamageSystem: damage calculation result is:", damage.damage)
            --print("DamageSystem: damage type is:".. damage.damage_type)
            if (damage.damage ~= nil and damage.damage ~= 0) then
                    local damage_dealt = ApplyDamage(damage)
                    print("DamageSystem: Damage dealt to target ".. target:GetUnitName() .. " is "..damage_dealt)
            end
        end
	end
end