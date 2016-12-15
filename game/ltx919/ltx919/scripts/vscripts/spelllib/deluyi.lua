--[[
	Author: Noya
	Date: 15.01.2015.
	Spawns a unit with different levels of the unit_name passed
	Each level needs a _level unit inside npc_units or npc_units_custom.txt
]]

equipTable = equipTable or {}

function SpiritBearSpawn( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = caster:GetAbsOrigin() + RandomVector(100)

	-- Set the unit name, concatenated with the level number
	local unit_name = event.unit_name
	unit_name = unit_name..level

	if caster.bear and and IsValidEntity(caster.bear) and caster.bear:IsAlive() then
		FindClearSpaceForUnit(caster.bear, origin, true)
		caster.bear:SetHealth(caster.bear:GetMaxHealth())
		-- Spawn particle
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.bear)	
		
	else
		-- Create the unit and make it controllable
		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:SetControllableByPlayer(player, true)
		caster.bear:SetOwner(caster)
		for i,v in ipairs(equipTable) do
			caster.bear:AddItem(v)
		end
		-- Apply the backslash on death modifier
		if ability ~= nil then
			ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_spirit_bear", nil)
		end

		-- Learn its abilities: return lvl 2, entangle lvl 3, demolish lvl 4. By Index
		LearnBearAbilities( caster.bear, 1 )
	end

end

--[[
	Author: Noya
	Date: 15.01.2015.
	When the skill is leveled up, try to find the casters bear and replace it by a new one on the same place
]]
function SpiritBearLevel( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local unit_name = "npc_dota_lone_druid_bear"


	if caster.bear and caster.bear:IsAlive() then 
		-- Remove the old bear in its position
		local origin = caster.bear:GetAbsOrigin()
		caster.bear:RemoveSelf()

		-- Create the unit and make it controllable
		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:SetControllableByPlayer(player, true)
		caster.bear:SetOwner(caster)
		for i,v in ipairs(equipTable) do
			caster.bear:AddItem(v)
		end
		ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_spirit_bear", nil)
	end
end

function SpiritBearDeath( event )
	local caster = event.caster
	local killed = event.UNIT
	local killer = event.attacker
	local ability = event.ability
	local damage = killed:GetMaxHealth()
	while (equipTable~=nil)
	do
		table.Remove(equipTable)
	end
	for i=0,5 do
		local hItem = caster.bear:GetItemInSlot(i)
		if hItem then
			table.insert(equipTable,hItem)
		end
	end
	ApplyDamage({ victim = caster, attacker = killer, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end