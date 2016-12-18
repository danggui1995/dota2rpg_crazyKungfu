--[[require('libraries/timers')

function Begin( keys )
	-- body
	local hCaster = keys.caster
	local ability = keys.ability
	ability.old_ori = hCaster:GetOrigin()
end

function SpawnCanYin( keys )
	-- body
	local ability = keys.ability
	local hCaster = keys.caster
	local unit_name = hCaster:GetUnitName()
	ability.new_ori = hCaster:GetOrigin()
	if ability.new_ori~=ability.old_ori then
		local pts = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_cape_cascade/windrunner_windrun_cascade.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControl(pts, 0 , hCaster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pts, 1 , v:GetAbsOrigin())
		local dummy = CreateUnitByName(unit_name ,ability.old_ori, true, hCaster, nil, hCaster:GetTeamNumber() )
		dummy:SetPlayerID(hCaster:GetPlayerID())
		--dummy:SetControllableByPlayer(hCaster:GetPlayerID(), true)
		--dummy:AddNewModifier(hCaster, ability, "modifier_illusion", { duration = 0.7 })
		--dummy:MakeIllusion()
		dummy:AddAbility("dota_ability_dummy")
		local hAbility11 = dummy:FindAbilityByName("dota_ability_dummy")
		hAbility11:SetLevel(1)
		dummy:SetForwardVector(hCaster:GetForwardVector())
		dummy:StartGesture(ACT_DOTA_RUN)
		Timers:CreateTimer(0.6,
			function(  )
				if dummy then
					if dummy:IsAlive() then
						dummy:Destroy()
					end
				end
				return nil
			end)
	end
	ability.old_ori = hCaster:GetOrigin()
end

function EndDummys( keys )
	local ability = keys.ability
	if ability.dummy~=nil then
		if ability.dummy:IsAlive() then
			ability.dummy:Destroy()
		end
	end
end]]