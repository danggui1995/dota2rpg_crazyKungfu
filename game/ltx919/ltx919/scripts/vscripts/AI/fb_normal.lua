require( "AI/ai_core" )

behaviorSystem = {}

function Spawn( entityKeyValues )
	
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
	
    behaviorSystem = AICore:CreateBehaviorSystem( {BehaviorNone, BehaviorBack} ) 
end

function AIThink()
       return behaviorSystem:Think()
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	if AICore.currentBehavior == self then return 1 end
	desire = 0
	if Spawn_pos == nil then 
		Spawn_pos = thisEntity:GetAbsOrigin()
	end

	return desire
end

function BehaviorNone:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_NONE
	}
end

function BehaviorNone:Continue()
	self.endTime = GameRules:GetGameTime() + 5
end

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
BehaviorBack = {}

function BehaviorBack:Evaluate()
	if AICore.currentBehavior == self then return 6 end
	desire = 0
	if not Spawn_pos then
		return desire
	end
	if (thisEntity:GetAbsOrigin() - Spawn_pos):Length2D()>700 then
		desire = 6
	end

	return desire
end

function BehaviorBack:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION ,
		Position = Spawn_pos
	}
end

function BehaviorBack:Continue()
	self.endTime = GameRules:GetGameTime() + 1
end

--------------------------------------------------------------------------------------------------------
AICore.possibleBehaviors = {BehaviorNone, BehaviorBack}