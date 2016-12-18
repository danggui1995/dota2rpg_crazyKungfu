--[[
Earth_spirit AI
]]

require("AI/ai_core")



behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, Behavior_fang} ) 
end



function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
       
	return behaviorSystem:Think()
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	local ancient =  Entities:FindByName( nil, "ent_base" )
	
	if ancient then
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = ancient:GetOrigin()
		}
	else
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
	end
end

function BehaviorNone:Continue()
	self.endTime = GameRules:GetGameTime() + 1
end

--------------------------------------------------------------------------------------------------------

Behavior_fang = {}

function Behavior_fang:Evaluate()
	
	local target
	local desire = 0
	self.tiAbility = thisEntity:FindAbilityByName("earth_spirit_boulder_smash")
	self.gunAbility = thisEntity:FindAbilityByName("earth_spirit_rolling_boulder")
	self.laAbility = thisEntity:FindAbilityByName("earth_spirit_geomagnetic_grip")
	self.fangAbility = thisEntity:FindAbilityByName("earth_spirit_stone_caller")
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	if self.fangAbility and self.fangAbility:IsFullyCastable() and self.tiAbility:IsFullyCastable() then
		local range = 1500
		target = AICore:RandomEnemyHeroInRange( thisEntity, range )
		
	end
	
	if target then
		desire = 5
		self.target = target
	else
		desire = 1
	end

	return desire
end



function Behavior_fang:Begin()
	self.endTime = GameRules:GetGameTime() + 2
	local flag = 0
	local range1 = 200
	local js = 0
	target1 = FindUnitsInRadius( thisEntity:GetTeam(), thisEntity:GetOrigin(), nil, range1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
	if #target1~=0 then
		for i,v in ipairs(target1) do
			if v:GetUnitName() == "npc_dota_earth_spirit_stone" then
				flag = 1
			end
		end
		if self.fangAbility and self.fangAbility:IsFullyCastable() and self.gunAbility:IsFullyCastable() and self.tiAbility:IsFullyCastable() 
			and self.laAbility:IsFullyCastable() and flag== 0 then
			thisEntity:SetForwardVector(AICore:GetFaceAngle(self.target,thisEntity))
			thisEntity:CastAbilityOnPosition(AICore:ForwardLength(thisEntity,80),self.fangAbility, thisEntity:GetTeam()) 
			thisEntity:SetContextThink(DoUniqueString("aa"),
				function(  )
					thisEntity:SetForwardVector(AICore:GetFaceAngle(self.target,thisEntity))
					thisEntity:CastAbilityOnPosition(AICore:ForwardLength(thisEntity,1200),self.tiAbility, thisEntity:GetTeam()) 
				end,0.5)
			thisEntity:SetContextThink(DoUniqueString("bb"),
				function(  )
					thisEntity:SetForwardVector(AICore:GetFaceAngle(self.target,thisEntity))
					thisEntity:CastAbilityOnPosition(AICore:ForwardLength(thisEntity,1200),self.gunAbility, thisEntity:GetTeam()) 
				end,0.7)
		
			thisEntity:SetContextThink(DoUniqueString("dd"),
				function(  )
					thisEntity:SetForwardVector(AICore:GetFaceAngle(self.target,thisEntity))
					thisEntity:CastAbilityOnPosition(AICore:ForwardLength(thisEntity,1200),self.laAbility, thisEntity:GetTeam())
					js = js + 1
					if js == 5 then 
						return 0.2
					else
						return nil
					end
				end,0.9)
		elseif flag== 1 and self.fangAbility:IsFullyCastable() and self.gunAbility:IsFullyCastable() and self.tiAbility:IsFullyCastable() 
			and self.laAbility:IsFullyCastable() then
			thisEntity:SetContextThink(DoUniqueString("ee"),
				function(  )
					thisEntity:CastAbilityOnPosition(AICore:ForwardLength(thisEntity,1200),self.tiAbility, thisEntity:GetTeam()) 
				end,0.5)
			thisEntity:SetContextThink(DoUniqueString("ff"),
				function(  )
					thisEntity:CastAbilityOnPosition(AICore:ForwardLength(thisEntity,1200),self.gunAbility, thisEntity:GetTeam()) 
				end,0.7)
		
			thisEntity:SetContextThink(DoUniqueString("gg"),
				function(  )
					thisEntity:CastAbilityOnPosition(AICore:ForwardLength(thisEntity,1200),self.laAbility, thisEntity:GetTeam())
						return nil
				end,0.9)
		end
	end
	
	--[[thisEntity:SetContextThink(DoUniqueString("aa"),
			function(  )
				thisEntity:CastAbilityOnPosition(self.target:GetAbsOrigin(),self.tiAbility, thisEntity:GetTeam()) 
				return nil
			end,0.2)
	thisEntity:SetContextThink(DoUniqueString("bb"),
			function(  )
				thisEntity:CastAbilityOnPosition(self.target:GetAbsOrigin(),self.gunAbility, thisEntity:GetTeam()) 
				return nil
			end,0.2)
	
	thisEntity:SetContextThink(DoUniqueString("dd"),
			function(  )
				thisEntity:CastAbilityOnPosition(self.target:GetAbsOrigin(),self.laAbility, thisEntity:GetTeam()) 
				return nil
			end,1.3)
	--[[if self.fangAbility and self.fangAbility:IsFullyCastable() then
		thisEntity:CastAbilityOnPosition(thisEntity:GetAbsOrigin(),self.fangAbility, thisEntity:GetTeam()) 
	end
	if self.tiAbility and not self.fangAbility:IsFullyCastable() then
		thisEntity:CastAbilityOnPosition(self.target:GetAbsOrigin(),self.tiAbility, thisEntity:GetTeam()) 
	end
	if self.gunAbility and not self.tiAbility:IsFullyCastable() then
		thisEntity:CastAbilityOnPosition(self.target:GetAbsOrigin(),self.gunAbility, thisEntity:GetTeam()) 
	end
	if self.laAbility and not self.gunAbility:IsFullyCastable() then
		 thisEntity:SetContextThink(DoUniqueString("dd"),
			function(  )
				thisEntity:CastAbilityOnPosition(self.target:GetAbsOrigin(),self.laAbility, thisEntity:GetTeam()) 
				return nil
			end,1.3)
	end]]
		

end

Behavior_fang.Continue = Behavior_fang.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

	
AICore.possibleBehaviors = { BehaviorNone, Behavior_fang}
