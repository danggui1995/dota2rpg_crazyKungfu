
function OnLeitingStart( data )
	local ability = data.ability
	local hCaster = data.caster 
	local target = data.target
	local damage_xs = ability:GetLevelSpecialValueFor("chain_damage_xs", ability:GetLevel() - 1)
	local damage = damage_xs * hCaster:GetAgility()
	local radius = ability:GetLevelSpecialValueFor("chain_radius", ability:GetLevel() - 1)
	local delay = ability:GetLevelSpecialValueFor("chain_delay", ability:GetLevel() - 1)
	local victimTable = {}
	local nums = ability:GetLevelSpecialValueFor("chain_strikes", ability:GetLevel() - 1)
	local cooldown = ability:GetLevelSpecialValueFor("chain_cooldown", ability:GetLevel() - 1)
	if ability:IsCooldownReady() then
		local effectName = data.effectName
		table.insert(victimTable,hCaster)
		table.insert(victimTable,target)
		EmitSoundOn("Item.Maelstrom.Chain_Lightning", target)
		local damageTable = {
			victim = target,
            attacker = hCaster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(damageTable)
		local pts = ParticleManager:CreateParticle(effectName, 
				PATTACH_CUSTOMORIGIN,hCaster)
		ParticleManager:SetParticleControl(pts, 0, victimTable[#victimTable-1]:GetAbsOrigin())
		ParticleManager:SetParticleControl(pts, 1, victimTable[#victimTable]:GetAbsOrigin())
		ability:StartCooldown(cooldown)
		local t_pos = target:GetAbsOrigin()
		if ability then
			ability:SetContextThink("qqq", 
			function()
				OnDgLeiting(effectName,ability,hCaster,t_pos,radius,delay,damage,nums-1,victimTable)
				return nil
			end,delay)
		end
	end
end

function OnDgLeiting( effectName,ability,hCaster,t_pos,radius,delay,damage,nums,victimTable )
	local targets = FindUnitsInRadius(hCaster:GetTeam(), t_pos, nil,radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, FIND_CLOSEST, false)
	if #targets == 0 then
		return
	end
	for i=1,#targets do
		if targets[i] and not MyContains(victimTable,targets[i]) then
			target = targets[i]
			table.insert(victimTable,target)
			EmitSoundOn("Item.Maelstrom.Chain_Lightning.Jump", target)
			local pts = ParticleManager:CreateParticle(effectName, 
				PATTACH_CUSTOMORIGIN,hCaster)
			ParticleManager:SetParticleControl(pts, 0, victimTable[#victimTable-1]:GetAbsOrigin())
			ParticleManager:SetParticleControl(pts, 1, victimTable[#victimTable]:GetAbsOrigin())
			local damageTable = {
				victim = target,
	            attacker = hCaster,
	            damage = damage,
	            damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(damageTable)
			nums = nums - 1
			local t_pos = target:GetAbsOrigin()
			break
		end
	end
	if nums == 0 then
		return 
	end
	if ability then
		ability:SetContextThink("qqq"..nums, 
		function()
			OnDgLeiting(effectName,ability,hCaster,t_pos,radius,delay,damage,nums,victimTable)
			return nil
		end,delay)
	end
end

function MyContains( myTable,myValue )
	for i,v in ipairs(myTable) do
		if v == myValue then
			return true
		end
	end
	return false
end