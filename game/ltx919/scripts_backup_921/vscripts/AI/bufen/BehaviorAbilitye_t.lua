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
			self.target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
		end
	end

	if self.target then
		desire = 3
	end

	return desire
end

function BehaviorAbilitye_t:Begin()
	self.endTime = GameRules:GetGameTime() + 10

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