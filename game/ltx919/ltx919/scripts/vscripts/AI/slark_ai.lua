--[[
slark AI
]]

require( "AI/ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorE, BehaviorC, BehaviorD} ) 
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

BehaviorE = {}

function BehaviorE:Evaluate()
	self.eAbility = thisEntity:FindAbilityByName("boss5_2")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.eAbility and self.eAbility:IsFullyCastable() then
		if #(AICore:GetUnitInShanXingArea(thisEntity,100,200 ))~=0 then
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

BehaviorC = {}

function BehaviorC:Evaluate()
	self.vAbility = thisEntity:FindAbilityByName("boss5_1")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.vAbility and self.vAbility:IsFullyCastable() then
		local range = 300
		target = AICore:GetAllEnermyInRadius( thisEntity, range )
	end

	if target and #target>=2 then
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

BehaviorD = {}

function BehaviorD:Evaluate()
	self.rAbility = thisEntity:FindAbilityByName("slark_shadow_dance")
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

function BehaviorD:Begin()
	self.endTime = GameRules:GetGameTime() + 1

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.rAbility:entindex()
	}
end

BehaviorD.Continue = BehaviorD.Begin


-------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------
AICore.possibleBehaviors = { BehaviorNone, BehaviorE,  BehaviorC, BehaviorD}