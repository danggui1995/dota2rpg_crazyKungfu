--[[
storm_spirit AI
]]

require( "AI/ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorR, BehaviorE, BehaviorG,BehaviorA } ) 
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

BehaviorR = {}

function BehaviorR:Evaluate()
	self.rAbility = thisEntity:FindAbilityByName("storm_spirit_static_remnant_boss")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.rAbility and self.rAbility:IsFullyCastable() then
		local range = 400
		target = AICore:RandomEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 4
		self.target = target
	else
		desire = 1
	end

	return desire
end

function BehaviorR:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.rAbility:entindex()
	}
end

BehaviorR.Continue = BehaviorR.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset


--------------------------------------------------------------------------------------------------------

BehaviorE = {}

function BehaviorE:Evaluate()
	self.eAbility = thisEntity:FindAbilityByName("storm_spirit_electric_vortex_boss")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.eAbility and self.eAbility:IsFullyCastable() then
		local range = 700
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 5
		self.target = target
	else
		desire = 1
	end

	return desire
end

function BehaviorE:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		TargetIndex = self.target:entindex(),
		AbilityIndex = self.eAbility:entindex()
	}
end

BehaviorE.Continue = BehaviorE.Begin


--------------------------------------------------------------------------------------------------------

BehaviorG = {}

function BehaviorG:Evaluate()
	self.gAbility = thisEntity:FindAbilityByName("storm_spirit_ball_lightning_boss")
	self.rAbility = thisEntity:FindAbilityByName("storm_spirit_static_remnant_boss")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.gAbility and self.gAbility:IsFullyCastable() then
		local range = 1400
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 3
		self.target = target
	else
		desire = 1
	end

	return desire
end

function BehaviorG:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		UnitIndex = thisEntity:entindex(),
		Position = AICore:RandomPositionInRange(self.target,150),
		AbilityIndex = self.gAbility:entindex()
	}
end

BehaviorG.Continue = BehaviorG.Begin


--------------------------------------------------------------------------------------------------------

BehaviorA = {}

function BehaviorA:Evaluate()

	local target
	local desire = 0
	if thisEntity:HasModifier("modifier_storm_spirit_overload") then
		local range = 600
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end
	if AICore.currentBehavior == self then return desire end

	if target then
		desire = 6
		self.target = target
	else
		desire = 1
	end

	return desire
end

function BehaviorA:Begin()
	self.endTime = GameRules:GetGameTime() + 0.7

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		UnitIndex = thisEntity:entindex(),
		TargetIndex = self.target:entindex()
	}
end

BehaviorA.Continue = BehaviorA.Begin

--------------------------------------------------------------------------------------------------------
AICore.possibleBehaviors = { BehaviorNone, BehaviorR, BehaviorE, BehaviorG,BehaviorA }
