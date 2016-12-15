function HideCaster( event )
	local hCaster = event.caster
	hCaster:AddNoDraw()
end

function ShowCaster( event )
	local hCaster = event.caster
	hCaster:RemoveNoDraw()
end

--[[
	usage:
	 data={
		distance,
		vision_range,
		movespeed,
		radius,
		ability,
		effectName,
		number
	 }
]]

function aroundProjectile(data)
	local distance = data.distance or 300
	local vision_range = data.vision_range or 200
	local movespeed = data.speed or 1000
	local radius = data.radius or 100
	local hCaster = data.caster
	local ability = data.ability
	local effectName = data.effectName
	local center = hCaster:GetAbsOrigin()
	local number = data.number or 3
	local foward = hCaster:GetForwardVector()
	local x = foward.x
	local y = foward.y
	local z = foward.z

	for i=1,number do
		local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
		local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
		local xl_new = Vector(x_new,y_new,z)
		local temp_pro = {}
		temp_pro.ability = ability
		temp_pro.effectName = effectName
		temp_pro.center = center
		temp_pro.distance = distance
		temp_pro.source = hCaster
		temp_pro.team = DOTA_UNIT_TARGET_TEAM_ENEMY
		temp_pro.targettype = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		temp_pro.velocity = movespeed*xl_new
		temp_pro.vision_range = vision_range
		temp_pro.radius1 = radius
		temp_pro.radius2 = radius
		OnLinePro(temp_pro)
	end
end

--[[
	usage:
	 data={
		caster,
		number
	 }
]]

function getAngle__( data )
	local hCaster = data.caster
	local foward = hCaster:GetForwardVector()
	local x = foward.x
	local y = foward.y
	local z = foward.z
	local temp_pro = {}
	local number = data.number or 3
	for i=1,number do
		local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
		local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
		local xl_new = Vector(x_new,y_new,z):Normalized()
		--local l_point = center+xl_new*radius
		table.insert(temp_pro, xl_new)
	end

	return temp_pro

end


--[[
	usage:
	 data={
		ability,
		effectName,
		center,
		distance,
		radius1,
		radius2,
		source,
		team,
		targettype,
		velocity,
		vision_range
	 }
]]

function OnLinePro( data )
	local fissure_projectile1 = {
	Ability             = data.ability,
	EffectName          = data.effectName,
	vSpawnOrigin        = data.center,
	fDistance           = data.distance,
	fStartRadius        = data.radius1 or 100,
	fEndRadius          = data.radius2 or 100,
	Source              = data.source,
	bHasFrontalCone     = false,
	bReplaceExisting    = false,
	iUnitTargetTeam     = data.team or DOTA_UNIT_TARGET_TEAM_ENEMY,
	--  iUnitTargetFlags    = ,
	iUnitTargetType     = data.targettype or DOTA_UNIT_TARGET_ALL,
	--  fExpireTime         = ,
	bDeleteOnHit        = false,
	vVelocity           = data.velocity,
	bProvidesVision     = true,
	iVisionRadius       = data.vision_range or 200,
	--  iVisionTeamNumber   = caster:GetTeamNumber(),
	}
	ProjectileManager:CreateLinearProjectile( fissure_projectile1 )
end

--[[
	usage:
	 data={
		ability,
		effectName,
		source,
		speed,
		target,
		team,
		attach
	 }
]]

function OnTrackPro( data )

	local info = {
        Target = data.target,
        Source = data.source,
        Ability = data.ability,
        EffectName = data.effectName,
        bDodgeable = false,
        bProvidesVision = true,
        iMoveSpeed = data.speed,
        iVisionRadius = 0,
        iVisionTeamNumber = data.team,
        iSourceAttachment = data.attach or DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    }
    ProjectileManager:CreateTrackingProjectile( info )
end

--[[
	usage:
	 data={
		unitname,
		owner,
		pos,
		team,
		duration,
		move
	 }

	不能召唤英雄
]]


function OnZhaoHuan( data )
	local unitname = data.unitname
	local owner = data.owner
	local pos = data.pos
	local team = data.team
	local duration = data.duration
	local move = data.move
	local _temp = owner
	while (not owner:IsRealHero())
	do
		owner = owner:GetOwnerEntity()
	end
	local tUnit = CreateUnitByName( unitname, pos, false, owner, owner, team )
	if move then
		tUnit:SetMoveCapability(move)
	end
	tUnit._owner = _temp
	tUnit:SetOwner(owner)
	tUnit:SetControllableByPlayer(owner:GetPlayerOwnerID(), true)
	tUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	if duration then
		tUnit:AddNewModifier(nil, nil, "modifier_kill", {duration=duration})
	end
	return tUnit
end

function getAncient( owner )
	while (not owner:IsRealHero())
	do
		owner = owner:GetOwnerEntity()
	end
	return owner
end

--[[
	usage:
	 data={
		unitname,
		owner,
		pos,
		team,
		duration,
		move,
		image
	 }

	用于召唤英雄
]]


function onImage( data )
	local unitname = data.unitname
	local owner = data.owner
	local pos = data.pos
	local team = data.team
	local duration = data.duration
	local move = data.move
	local _temp = owner
	while (not owner:IsRealHero())
	do
		owner = owner:GetOwnerEntity()
	end
	--这里注意：onwer必须填nil 否则会导致游戏崩溃
	local tUnit = CreateUnitByName( unitname, pos, false, owner, nil, team )
	tUnit:SetMoveCapability(move)
	tUnit._owner = _temp
	tUnit:SetOwner(owner)
	tUnit:SetControllableByPlayer(owner:GetPlayerOwnerID(), true)
	tUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	if duration~=-1 then
		tUnit:SetContextThink("deleteself",
		function()
			if not tUnit.run then
				if owner.dummy then
					for i=1,#owner.dummy do
						if owner.dummy[i]==tUnit then
							table.remove(owner.dummy, i)
						end
					end
				end
				tUnit:RemoveSelf()
			end
			
		end,duration)
	end

	tUnit:SetAbilityPoints(0)
	for abilitySlot=0,4 do
		local ability = owner:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = tUnit:FindAbilityByName(abilityName)
			illusionAbility:SetLevel(abilityLevel)
		end
	end

	if data.image then
		tUnit:MakeIllusion()
	end
	return tUnit
end

function getMoveCapability( unit )
	local movement = DOTA_UNIT_CAP_MOVE_NONE
	if unit:HasFlyMovementCapability() then
		movement = DOTA_UNIT_CAP_MOVE_FLY
	elseif unit:HasGroundMovementCapability() then
		movement = DOTA_UNIT_CAP_MOVE_GROUND
	end
	return movement
end