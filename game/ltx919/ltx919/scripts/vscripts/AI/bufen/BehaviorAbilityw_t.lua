--------------------------------------------------------------------------------------------------------

BehaviorAbilityw_t = {}

function BehaviorAbilityw_t:Evaluate()
	self.wAbility = thisEntity:GetAbilityByIndex(1)

	local desire = 0
	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	
	if self.wAbility and self.wAbility:IsFullyCastable() then
		if self.wAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 700
		if AICore:IsUnitTarget(self.wAbility) then
			self.target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
		end
	end

	if self.target then
		desire = 4
	end

	return desire
end

function BehaviorAbilityw_t:Begin()
	self.endTime = GameRules:GetGameTime() + 10

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.wAbility:entindex(),
		TargetIndex = self.target:entindex()
	}
end

BehaviorAbilityw_t.Continue = BehaviorAbilityw_t.Begin
--------------------------------------------------------------------------------------------------------