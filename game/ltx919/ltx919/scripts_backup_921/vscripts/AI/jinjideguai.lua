--[[
guanwu AI
]]

require( "AI/ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
	
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorAttackMove,BehaviorAttackTransform, BehaviorAbilityq,BehaviorAbilityw} ) 
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
       return behaviorSystem:Think()
end

--------------------------------------------------------------------------------------------------------

BehaviorAttackMove = {}

function BehaviorAttackMove:Evaluate()
	local desire = 0
	local targetHero = AICore:GetNearstUnit(thisEntity,800)
	if not targetHero then
		desire = 7
	end
	return desire
end

function BehaviorAttackMove:Begin()
	self.endTime = GameRules:GetGameTime() + 4
	local _ent = Entities:FindByName(nil,"ent_base")
	local _pos = _ent:GetAbsOrigin()
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE ,
		Position = _pos
	}
end

function BehaviorAttackMove:Continue()
	self.endTime = GameRules:GetGameTime() + 4
end

--------------------------------------------------------------------------------------------------------

BehaviorAttackTransform = {}

function BehaviorAttackTransform:Evaluate()
	local targetHero = AICore:GetNearstUnit(thisEntity,800)
	local desire = 0
	if targetHero~=nil then
		self.target = targetHero
		desire = 5
	end
	return desire
end

function BehaviorAttackTransform:Begin()
	self.endTime = GameRules:GetGameTime() + 1

	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET ,
		TargetIndex = self.target:entindex()
	}
end
BehaviorAttackTransform.Continue = BehaviorAttackTransform.Begin

--------------------------------------------------------------------------------------------------------


BehaviorAbilityq = {}

function BehaviorAbilityq:Evaluate()
	
	local target
	local desire = 0
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	self.qAbility = thisEntity:GetAbilityByIndex(0)
	if self.qAbility and self.qAbility:IsFullyCastable() then
		if self.qAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 500
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
		
	end

	if target then
		desire = 4
		self.target = target
	end

	return desire
end

function BehaviorAbilityq:Begin()
	self.endTime = GameRules:GetGameTime() + 2
	if AICore:IsUnitTarget(self.qAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.qAbility:entindex(),
			TargetIndex = self.target:entindex()
		}
	else
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.qAbility:entindex()
		}
	end
	
end

BehaviorAbilityq.Continue = BehaviorAbilityq.Begin
--------------------------------------------------------------------------------------------------------


BehaviorAbilityw = {}

function BehaviorAbilityw:Evaluate()
	
	local target
	local desire = 0
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	self.wAbility = thisEntity:GetAbilityByIndex(1)
	if self.wAbility and self.wAbility:IsFullyCastable() then
		if self.wAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 500
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 5
		self.target = target
	end

	return desire
end

function BehaviorAbilityw:Begin()
	self.endTime = GameRules:GetGameTime() + 3
	if AICore:IsUnitTarget(self.wAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.wAbility:entindex(),
			TargetIndex = self.target:entindex()
		}
	else
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.wAbility:entindex()
		}
	end
	
end

BehaviorAbilityw.Continue = BehaviorAbilityw.Begin
--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorAttackMove, BehaviorAttackTransform,BehaviorAbilityq,BehaviorAbilityw}