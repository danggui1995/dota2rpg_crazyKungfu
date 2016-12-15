--[[
ursa AI
]]

require( "AI/ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorE, BehaviorV, BehaviorR} ) 
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

BehaviorE = {}

function BehaviorE:Evaluate()
	self.eAbility = thisEntity:FindAbilityByName("boss3_e")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.eAbility and self.eAbility:IsFullyCastable() then
		if #AICore:GetAllEnermyInRadius(thisEntity,350)>2 then
			desire = 4
		end
	end
	return desire
end

function BehaviorE:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.eAbility:entindex()
	}
end

BehaviorE.Continue = BehaviorE.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset


--------------------------------------------------------------------------------------------------------

BehaviorV = {}

function BehaviorV:Evaluate()
	self.vAbility = thisEntity:FindAbilityByName("boss3_v")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.vAbility and self.vAbility:IsFullyCastable() then
		local range = 300
		target = AICore:RandomEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 3
		self.target = target
	else
		desire = 1
	end

	return desire
end

function BehaviorV:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.vAbility:entindex()
	}
end

BehaviorV.Continue = BehaviorV.Begin


--------------------------------------------------------------------------------------------------------

BehaviorR = {}

function BehaviorR:Evaluate()
	self.rAbility = thisEntity:FindAbilityByName("ursa_enrage")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.rAbility and self.rAbility:IsFullyCastable() then
		local health = thisEntity:GetHealthPercent()
		if health<=40 then
			desire = 5 
		end
	end
	return desire
end

function BehaviorR:Begin()
	self.endTime = GameRules:GetGameTime() + 1

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.rAbility:entindex()
	}
end

BehaviorR.Continue = BehaviorR.Begin


-------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------
AICore.possibleBehaviors = { BehaviorNone, BehaviorE, BehaviorV, BehaviorR }