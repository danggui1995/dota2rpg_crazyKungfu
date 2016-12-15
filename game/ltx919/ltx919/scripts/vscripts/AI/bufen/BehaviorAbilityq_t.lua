--------------------------------------------------------------------------------------------------------



BehaviorAbilityq_t = {}

function BehaviorAbilityq_t:Evaluate()
	self.qAbility = thisEntity:GetAbilityByIndex(0)

	local desire = 0
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	
	if self.qAbility and self.qAbility:IsFullyCastable() then
		if self.qAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 700
		if AICore:IsUnitTarget(self.qAbility) then
			self.target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
		end
	end

	if self.target then
		desire = 5
	end

	return desire
end

function BehaviorAbilityq_t:Begin()
	self.endTime = GameRules:GetGameTime() + 10

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.qAbility:entindex(),
		TargetIndex = self.target:entindex()
	}
end

BehaviorAbilityq_t.Continue = BehaviorAbilityq_t.Begin
--------------------------------------------------------------------------------------------------------