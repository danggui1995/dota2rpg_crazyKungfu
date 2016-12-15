--[[
guanwu AI
]]

require( "AI/ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
	
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorAttackMove,BehaviorAttackTransform, BehaviorAbilityq,BehaviorAbilityw,BehaviorAbilitye,BehaviorAbilityr} ) 
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
		desire = 3
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
		desire = 4
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
	local desire = 0
	local target
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	self.qAbility = thisEntity:GetAbilityByIndex(0)
	if self.qAbility and self.qAbility:IsFullyCastable() then
		if AICore:IsPassive(self.qAbility) then
			return desire
		end
		local range = 600
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 5
		self.target = target
	end

	return desire
end

function BehaviorAbilityq:Begin()
	self.endTime = GameRules:GetGameTime() + 4
	if AICore:IsUnitTarget(self.qAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.qAbility:entindex(),
			TargetIndex = self.target:entindex()
		}
	elseif AICore:IsNoTarget(self.qAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.qAbility:entindex()
		}
	elseif AICore:IsPoint(self.qAbility) then
		self.order =
		{
			UnitIndex = thisEntity:entindex(), 
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.qAbility:entindex(),
			Position = self.target:GetAbsOrigin()
		}
	end
	
end

BehaviorAbilityq.Continue = BehaviorAbilityq.Begin
--------------------------------------------------------------------------------------------------------


BehaviorAbilityw = {}

function BehaviorAbilityw:Evaluate()
	local desire = 0
	local target
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	self.wAbility = thisEntity:GetAbilityByIndex(1)
	if self.wAbility and self.wAbility:IsFullyCastable() then
		if AICore:IsPassive(self.wAbility) then
			return desire
		end
		local range = 600
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 6
		self.target = target
	end

	return desire
end

function BehaviorAbilityw:Begin()
	self.endTime = GameRules:GetGameTime() + 4
	if AICore:IsUnitTarget(self.wAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.wAbility:entindex(),
			TargetIndex = self.target:entindex()
		}
	elseif AICore:IsNoTarget(self.wAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.wAbility:entindex()
		}
	elseif AICore:IsPoint(self.wAbility) then
		self.order =
		{
			UnitIndex = thisEntity:entindex(), 
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.wAbility:entindex(),
			Position = self.target:GetAbsOrigin()
		}
	end
	
end

BehaviorAbilityw.Continue = BehaviorAbilityw.Begin
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------


BehaviorAbilitye = {}

function BehaviorAbilitye:Evaluate()
	local desire = 0
	local target
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	self.eAbility = thisEntity:GetAbilityByIndex(2)
	if self.eAbility and self.eAbility:IsFullyCastable() then
		if AICore:IsPassive(self.eAbility) then
			return desire
		end
		local range = 600
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 7
		self.target = target
	end

	return desire
end

function BehaviorAbilitye:Begin()
	self.endTime = GameRules:GetGameTime() + 5
	if AICore:IsUnitTarget(self.eAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.eAbility:entindex(),
			TargetIndex = self.target:entindex()
		}
	elseif AICore:IsNoTarget(self.eAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.eAbility:entindex()
		}
	elseif AICore:IsPoint(self.eAbility) then
		self.order =
		{
			UnitIndex = thisEntity:entindex(), 
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.eAbility:entindex(),
			Position = self.target:GetAbsOrigin()
		}
	end
	
end

BehaviorAbilitye.Continue = BehaviorAbilitye.Begin
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------


BehaviorAbilityr = {}

function BehaviorAbilityr:Evaluate()
	local desire = 0
	local target
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	self.rAbility = thisEntity:GetAbilityByIndex(3)
	if self.rAbility and self.rAbility:IsFullyCastable() then
		if AICore:IsPassive(self.rAbility) then
			return desire
		end
		local range = 600
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
		
	end

	if target then
		desire = 8
		self.target = target
	end

	return desire
end

function BehaviorAbilityr:Begin()
	self.endTime = GameRules:GetGameTime() + 5
	if AICore:IsUnitTarget(self.rAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.rAbility:entindex(),
			TargetIndex = self.target:entindex()
		}
	elseif AICore:IsNoTarget(self.rAbility) then
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.rAbility:entindex()
		}
	elseif AICore:IsPoint(self.rAbility) then
		self.order =
		{
			UnitIndex = thisEntity:entindex(), 
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.rAbility:entindex(),
			Position = self.target:GetAbsOrigin()
		}
	end
	
end

BehaviorAbilityr.Continue = BehaviorAbilityr.Begin
--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorAttackMove, BehaviorAttackTransform,BehaviorAbilityq,BehaviorAbilityw,BehaviorAbilitye,BehaviorAbilityr}