if modifier_zhenyafu_lua == nil then
    modifier_zhenyafu_lua = class({})
end

function modifier_zhenyafu_lua:IsDebuff()
    return 1
end

function modifier_zhenyafu_lua:GetEffectName()
    return "particles/heroes/luodu/ability_luodu_01.vpcf"
end

function modifier_zhenyafu_lua:GetEffectAttachType()
     return "follow_origin"
end

function modifier_zhenyafu_lua:GetTexture()
    return "dacidabeizhang"
end

function modifier_zhenyafu_lua:GetDuration()
    return 5
end

function modifier_zhenyafu_lua:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true
    }

    return state
end