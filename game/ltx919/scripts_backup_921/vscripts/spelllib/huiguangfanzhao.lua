--[[
	Author: Noya
	Date: 9.1.2015.
	Checks if the caster HP dropped below the threshold
]]
function BorrowedTimeActivate( event )
	local caster = event.caster
	local ability = event.ability
	local cooldown = ability:GetCooldown( ability:GetLevel() )
	local dur = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
	
	if caster:GetHealth() < 0.1*caster:GetMaxHealth() and ability:GetCooldownTimeRemaining() == 0 then
		BorrowedTimePurge( event )
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_borrowed_time_new", { duration = dur })
		ability:StartCooldown( cooldown )
		caster:EmitSound("Hero_Abaddon.BorrowedTime")
	end
end

--[[
	Author: Noya
	Date: 9.1.2015.
	Heals for twice the damage taken
]]
function BorrowedTimeHeal( event )
	local damage = event.DamageTaken
	local caster = event.caster
	local ability = event.ability
	caster:Heal(damage*2, caster)
end

function BorrowedTimePurge( event )
	local caster = event.caster
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
end