function GetWearables( event )
	--[[local hero = event.caster
	--hero:AddNoDraw() -- Doesn't work on classname dota_item_wearable
	hero.wearableNames = {} -- In here we'll store the wearable names to revert the change
	hero.hiddenWearables = {} -- Keep every wearable handle in a table, as its way better to iterate than in the MovePeer system
	
	local model = hero:FirstMoveChild()
	local n = 1
	while model ~= nil do
		if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
			local modelName = model:GetModelName()
			if string.find(modelName, "invisiblebox") == nil then
				-- Add the original model name to revert later
				table.insert(hero.wearableNames,modelName)
				print("Hidden "..modelName.."")
				--model:SetModel("models/development/invisiblebox.vmdl")
				table.insert(hero.hiddenWearables,model)
			end
		end
		n = n + 1
		model = model:NextMovePeer()
		if model ~= nil then
			print("Next Peer:" .. model:GetModelName())
		end
		if n == 5 then
			return nil 
		end
	end]]
end

function CircleAndRotate( radius_new )
	-- body
	local v1 = math.sin(3.14159/12) * radius_new
	local v2 = math.cos(3.14159/12) * radius_new
	local v3 = math.sin(0.15*3.14159) * radius_new
	local v4 = math.cos(0.15*3.14159) * radius_new
	local x_offset = { -v2, 0, v2, -v4, v4}
	local y_offset = { v1, radius_new, v1, -v3, -v3}
	return x_offset,y_offset
end

function OnBladeFury(event)
	
	print("in OnBladeFury function")
	local ability	= event.ability
 
	ability.spirits_startTime = GameRules:GetGameTime()
	local hCaster = event.caster
	hCaster:AddAbility("juggernaut_blade_fury_dummy")
	local hAbility = hCaster:FindAbilityByName("juggernaut_blade_fury_dummy") 
	local hAbility2 = hCaster:FindAbilityByName("juggernaut_blade_fury_new")
	local LAbility = hAbility2:GetLevel()
	hAbility:SetLevel(LAbility)
	hCaster:CastAbilityImmediately(hAbility, hCaster:GetTeam())

	local radius_new = event.default_radius
	local x_offset,y_offset = CircleAndRotate(radius_new)
	ability.dummy_jugg = {}

	for i=1,5 do
		
		ability.dummy_jugg[i] = CreateUnitByName("npc_dota_dummy_caster", hCaster:GetOrigin() + Vector( x_offset[i], y_offset[i], 0.0), false, hCaster, hCaster, hCaster:GetTeam()) --[[Returns:handle
		Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
		]]
		local caster_model = hCaster:GetModelName()
		ability.dummy_jugg[i]:SetModel(caster_model)
		ability.dummy_jugg[i]:AddAbility("juggernaut_blade_fury_dummy")
		local hAbility3 = ability.dummy_jugg[i]:FindAbilityByName("juggernaut_blade_fury_dummy") 
		hAbility3:SetLevel(LAbility)
		ability.dummy_jugg[i]:CastAbilityNoTarget(hAbility3,hCaster:GetTeam() )

		
		--ShowWearables
		--print("Showing Wearables on ".. ability.dummy_jugg[i]:GetModelName())
		-- Iterate on both tables to set each item back to their original modelName
		--[[for i,v in ipairs(hCaster.hiddenWearables) do
			for index,modelName in ipairs(hCaster.wearableNames) do
				if i==index then
					print("Changed "..v:GetModelName().. " back to "..modelName)
					v:SetModel(modelName)
				end
			end
		end

]]
	end
	--local  xx = CreateUnitByName("npc_dota_creep_fk1", hCaster:GetOrigin()+Vector(100,100,0), false, nil, nil, DOTA_TEAM_BADGUYS)

end

function ThinkFury( event )
	
	local caster	= event.caster
	local ability	= event.ability

	local numSpiritsMax	= event.num_dummys

	local casterOrigin	= caster:GetAbsOrigin()
	local currentRadius = event.radius_default
	local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime

	
	--------------------------------------------------------------------------------
	-- Update the spirits' positions
	--
	local currentRotationAngle	= elapsedTime * event.spirit_turn_rate
	local rotationAngleOffset	= 360 / event.num_dummys
	local numSpiritsAlive = 0
	for i=1,5 do
		--[[local nIceIndex = ParticleManager:CreateParticle(
		"particles/econ/items/zeus/lightning_weapon_fx/zues_immortal_lightning_weapon.vpcf", 
		PATTACH_CUSTOMORIGIN, 
		ability.dummy_jugg[i])
		--ParticleManager:DestroyParticle(nIceIndex,false)

	    --ParticleManager:SetParticleControl(nIceIndex, 0, ent:GetOrigin())
	    --ParticleManager:SetParticleControl(nIceIndex, 1, Vector(300,300,300))
		]]
		local rotationAngle = currentRotationAngle - rotationAngleOffset * ( i - 1 )
		local relPos = Vector( 0, currentRadius, 0 )
		relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )

		local absPos = GetGroundPosition( relPos + casterOrigin, ability.dummy_jugg[i] )

		ability.dummy_jugg[i]:SetAbsOrigin( absPos )

		-- Update particle
		--ParticleManager:SetParticleControl( v.spirit_pfx, 1, Vector( currentRadius, 0, 0 ) )
	end


	--[[if ability.spirits_numSpirits == numSpiritsMax and numSpiritsAlive == 0 then
		-- All spirits have been exploded.
		caster:RemoveModifierByName( event.caster_modifier )
		return
	end]]

end


function EndDummys( keys )
	-- body
	for i=1,5 do
		keys.ability.dummy_jugg[i]:ForceKill( true )
	end
	local hCaster = keys.caster
	local hAbility = hCaster:FindAbilityByName("juggernaut_blade_fury_dummy")
	if hAbility~=nil then
		hCaster:RemoveAbility("juggernaut_blade_fury_dummy")
	end
end