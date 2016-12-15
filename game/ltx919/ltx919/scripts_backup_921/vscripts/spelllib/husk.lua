LinkLuaModifier( "modifier_huskar_berserkers_blood_lua" , "scripts/vscripts/spelllib/modifiers/modifier_berserkers_blood.lua" , LUA_MODIFIER_MOTION_NONE )

--[[
    Author: Bude
    Date: 30.09.2015
    Simply applies the lua modifier
--]]
function ApplyLuaModifier1( keys )
    local caster = keys.caster
    local ability = keys.ability
    local modifiername = keys.ModifierName

    caster:AddNewModifier(caster, ability, modifiername, {})
end

LinkLuaModifier( "modifier_huskar_inner_vitality_lua" , "scripts/vscripts/spelllib/modifiers/modifier_inner_vitality.lua" , LUA_MODIFIER_MOTION_NONE )

--[[
    Author: Bude
    Date: 29.09.2015
    Simply applies the lua modifier
--]]

function ApplyLuaModifier( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local modifiername = keys.ModifierName
    local duration = ability:GetDuration()

    target:AddNewModifier(caster, ability, modifiername, {Duration = duration})
end