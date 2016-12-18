function DuoChongGongJi( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if caster:IsRangedAttacker() and caster:IsRealHero() then
        local radius = caster:GetAttackRange() +100
        local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BUILDING
        local flags = DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
        local group = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,radius,teams,types,flags,FIND_CLOSEST,true)
        local attack_count = keys.attack_count or 0
        local attack_unit = {}
        local projectileSpeed = caster:GetProjectileSpeed()
        local unitname = caster:GetUnitName()
        for i,unit in pairs(group) do
            if (#attack_unit)==attack_count-1 then
                break
            end
            if unit~=target then
                if unit:IsAlive() then
                    table.insert(attack_unit,unit)
                end
            end
        end
        local attack_effect = keys.particleName or GameRules.dandao[unitname]
        for i,unit in pairs(attack_unit) do
            local info =
            {
                Target = unit,
                Source = caster,
                Ability = ability,
                EffectName = attack_effect,
                bDodgeable = false,
                iMoveSpeed = projectileSpeed,
                bProvidesVision = false,
                iVisionRadius = 0,
                iVisionTeamNumber = caster:GetTeamNumber(),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
            }
            projectile = ProjectileManager:CreateTrackingProjectile(info)
        end
    end
end

function DuoChongGongJiDamage( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local attack_damage_lose = keys.attack_damage_lose or 0
    local attack_damage = caster:GetAttackDamage() * ((100-attack_damage_lose)/100)
     --caster:GetAverageTrueAttackDamage(target) 
    local damageTable = 
    {
        victim=target,
        attacker=caster,
        damage_type=DAMAGE_TYPE_PHYSICAL,
        damage=attack_damage
    }
    local damage = ApplyDamage(damageTable) 
end
--[[
修复了丈八蛇矛的BUG
修复了多重箭的bug(V锅，MDZZ)
修复了一些描述
换了一个模型
]]