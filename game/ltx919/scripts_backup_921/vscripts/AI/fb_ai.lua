--[[
guanwu AI
]]

require( "AI/ai_core" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
	
    behaviorSystem = AICore:CreateBehaviorSystem( {BehaviorNone, BehaviorBack, BehaviorAbilityq,BehaviorAbilityw,BehaviorAbilitye,BehaviorAbilityr} ) 
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
       return behaviorSystem:Think()
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	if AICore.currentBehavior == self then return 1 end
	desire = 1
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
	desire = 0
	if AICore.currentBehavior == self then return desire end
	
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


BehaviorAbilityq = {}

function BehaviorAbilityq:Evaluate()
	local desire = 0
	local target
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end
	self.qAbility = thisEntity:GetAbilityByIndex(0)
	if self.qAbility and self.qAbility:IsFullyCastable() then
		if self.qAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 500
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 2
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
	local desire = 0
	local target
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end
	self.wAbility = thisEntity:GetAbilityByIndex(1)
	if self.wAbility and self.wAbility:IsFullyCastable() then
		if self.wAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 500
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = 3
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
--------------------------------------------------------------------------------------------------------


BehaviorAbilitye = {}

function BehaviorAbilitye:Evaluate()
	local desire = 0
	local target
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end
	self.eAbility = thisEntity:GetAbilityByIndex(2)
	if self.eAbility and self.eAbility:IsFullyCastable() then
		if self.eAbility:GetBehavior() == 2 then
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
	else
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.eAbility:entindex()
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
	if currentBehavior == self then return desire end
	self.rAbility = thisEntity:GetAbilityByIndex(3)
	if self.rAbility and self.rAbility:IsFullyCastable() then
		if self.rAbility:GetBehavior() == 2 then
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
	else
		self.order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = thisEntity:entindex(),
			AbilityIndex = self.rAbility:entindex()
		}
	end
	
end

BehaviorAbilityr.Continue = BehaviorAbilityr.Begin
--------------------------------------------------------------------------------------------------------
AICore.possibleBehaviors = {BehaviorNone, BehaviorBack, BehaviorAbilityq,BehaviorAbilityw,BehaviorAbilitye,BehaviorAbilityr}