function DuoChongGongJi( keys )
 
        local caster = keys.caster
        local target = keys.target
--只对远程有效
        if caster:IsRangedAttacker() and caster:IsRealHero() then
                --获取攻击范围

                local radius = caster:GetAttackRange() +100
                local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
                local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_MECHANICAL+DOTA_UNIT_TARGET_BUILDING
                local flags = DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
                --获取周围的单位
                local group = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,radius,teams,types,flags,FIND_CLOSEST,true)
                --获取箭的数量
                local attack_count = keys.attack_count or 0
                --获取箭的特效
                local unitname = caster:GetUnitName()
                local attack_effect = GameRules.dandao[unitname]
                local attack_unit = {}
        
        --筛选离英雄最近的敌人
                for i,unit in pairs(group) do
                        if (#attack_unit)==attack_count then
                                break
                        end
 
                        if unit~=target then
                                if unit:IsAlive() then
                                        table.insert(attack_unit,unit)
                                end
                        end
                end
 
                for i,unit in pairs(attack_unit) do
                        local info =
                        {
                                Target = unit,
                                Source = caster,
                                Ability = keys.ability,
                                EffectName = attack_effect,
                                bDodgeable = false,
                                iMoveSpeed = 1800,
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
    --获取攻击伤害
    local attack_damage_lose = keys.attack_damage_lose or 0
    local attack_damage = caster:GetAttackDamage() * ((100-attack_damage_lose)/100)
    local damageTable = {victim=target,
    attacker=caster,
    damage_type=DAMAGE_TYPE_PHYSICAL,
    damage=attack_damage}
    ApplyDamage(damageTable)
end

function AddAbility(    event )
        local attack_count = event.attack_count
        local equiper = event.caster
        if equiper:IsRangedAttacker() and equiper:IsRealHero() then
            GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("add"),
                        function ( )
                                local hAbility2 = equiper:FindAbilityByName("ability_duochongjian") 
                                if hAbility2~=nil then
                                        if equiper:HasModifier("modifier_duo_chong_gong_ji_right") then
                                                equiper:RemoveModifierByName("modifier_duo_chong_gong_ji_right")
                                        end
                                        hAbility2:SetLevel(attack_count)
                                       
                                else 
                                        if equiper:HasModifier("modifier_duo_chong_gong_ji_right") then
                                                equiper:RemoveModifierByName("modifier_duo_chong_gong_ji_right")
                                        end
                                        equiper:AddAbility("ability_duochongjian")
                                        local hAbility = equiper:FindAbilityByName("ability_duochongjian")
                                        hAbility:SetLevel(attack_count)
                                end
                                return nil 
                        end,11)   
        end       
end

function RemoveAbility( event )
        local equiper = event.caster
        local hAbility = equiper:FindAbilityByName("ability_duochongjian")
        if hAbility~=nil then
                equiper:RemoveAbility("ability_duochongjian")
                if equiper:HasModifier("modifier_duo_chong_gong_ji_right") then
                        equiper:RemoveModifierByName("modifier_duo_chong_gong_ji_right")
                end
        end
end