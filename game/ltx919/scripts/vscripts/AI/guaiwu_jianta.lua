--[[
guanwu AI
]]

require( "AI/ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorC} ) 
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
       return behaviorSystem:Think()
end


--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	if AICore.currentBehavior == self then return 1 end
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

BehaviorC = {}

function BehaviorC:Evaluate()
	self.vAbility = thisEntity:FindAbilityByName("guai_14_jianta")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.vAbility and self.vAbility:IsFullyCastable() then
		local range = 100
		target = AICore:GetAllEnermyInRadius( thisEntity, range )
	end

	if target and #target>=1 then
		desire = 3
	else
		desire = 1
	end

	return desire
end

function BehaviorC:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.vAbility:entindex()
	}
end

BehaviorC.Continue = BehaviorC.Begin
--------------------------------------------------------------------------------------------------------
AICore.possibleBehaviors = { BehaviorNone,   BehaviorC}