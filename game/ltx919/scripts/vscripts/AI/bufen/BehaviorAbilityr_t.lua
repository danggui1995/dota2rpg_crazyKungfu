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
			self.target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
		end
	end

	if self.target then
		desire = 2
	end

	return desire
end

function BehaviorAbilityr_t:Begin()
	self.endTime = GameRules:GetGameTime() + 10

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