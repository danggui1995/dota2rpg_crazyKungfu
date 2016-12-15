--------------------------------------------------------------------------------------------------------

BehaviorAbilitye_t = {}

function BehaviorAbilitye_t:Evaluate()
	self.eAbility = thisEntity:GetAbilityByIndex(2)

	local desire = 0
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	
	if self.eAbility and self.eAbility:IsFullyCastable() then
		if self.eAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 700
		if AICore:IsUnitTarget(self.eAbility) then
			target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
		end
	end

	if target then
		desire = 3
	end

	return desire
end

function BehaviorAbilitye_t:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.eAbility:entindex(),
		TargetIndex = self.target:entindex()
	}
end

BehaviorAbilitye_t.Continue = BehaviorAbilitye_t.Begin
--------------------------------------------------------------------------------------------------------
BehaviorAbilitye_n = {}

		
function BehaviorAbilitye_n:Evaluate()
	self.eAbility = thisEntity:GetAbilityByIndex(2)
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	
	if self.eAbility and self.eAbility:IsFullyCastable() then
		if self.eAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 100
		if AICore:IsNoTarget(self.eAbility) then
			target = AICore:GetAllEnermyInRadius( thisEntity, range )
		end
	end

	if target and #target>=1 then
		desire = 3
	end

	return desire
end

function BehaviorAbilitye_n:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.eAbility:entindex()
	}
end

BehaviorAbilityq_n.Continue = BehaviorAbilityq_n.Begin
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

BehaviorAbilityr_t = {}

function BehaviorAbilityr_t:Evaluate()
	self.rAbility = thisEntity:GetAbilityByIndex(3)

	local desire = 0
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	
	if self.rAbility and self.rAbility:IsFullyCastable() then
		if self.rAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 700
		if AICore:IsUnitTarget(self.rAbility) then
			target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
		end
	end

	if target then
		desire = 2
	end

	return desire
end

function BehaviorAbilityr_t:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.rAbility:entindex(),
		TargetIndex = self.target:entindex()
	}
end

BehaviorAbilityr_t.Continue = BehaviorAbilityr_t.Begin
--------------------------------------------------------------------------------------------------------
BehaviorAbilityr_n = {}

		
function BehaviorAbilityr_n:Evaluate()
	self.rAbility = thisEntity:GetAbilityByIndex(3)
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	
	if self.rAbility and self.rAbility:IsFullyCastable() then
		if self.rAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 100
		if AICore:IsNoTarget(self.rAbility) then
			target = AICore:GetAllEnermyInRadius( thisEntity, range )
		end
	end

	if target and #target>=1 then
		desire = 2
	end

	return desire
end

function BehaviorAbilityr_n:Begin()
	self.endTime = GameRules:GetGameTime() + 0.6

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.rAbility:entindex()
	}
end

BehaviorAbilityr_n.Continue = BehaviorAbilityr_n.Begin
--------------------------------------------------------------------------------------------------------