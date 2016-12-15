--------------------------------------------------------------------------------------------------------

BehaviorAttackTransform = {}

function BehaviorAttackTransform:Evaluate()
	local targetHero = AICore:WeakestEnemyHeroInRange(thisEntity,800)
	local desire = 0
	if targetHero~=nil then
		self.target = targetHero
		desire = 3
	end
	return desire
end

function BehaviorAttackTransform:Begin()
	self.endTime = GameRules:GetGameTime() + 2

	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET ,
		TargetIndex = self.target:entindex()
	}
end
BehaviorAttackTransform.Continue = BehaviorAttackTransform.Begin

--------------------------------------------------------------------------------------------------------