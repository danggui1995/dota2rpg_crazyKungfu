--------------------------------------------------------------------------------------------------------
BehaviorAbilityq_n = {}

		
function BehaviorAbilityq_n:Evaluate()
	self.qAbility = thisEntity:GetAbilityByIndex(0)
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	
	if self.qAbility and self.qAbility:IsFullyCastable() then
		if self.qAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 200
		if AICore:IsNoTarget(self.qAbility) then
			target = AICore:GetAllEnermyInRadius( thisEntity, range )
		end
	end

	if target and #target>=1 then
		desire = 5
	end

	return desire
end

function BehaviorAbilityq_n:Begin()
	self.endTime = GameRules:GetGameTime() + 10

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.qAbility:entindex()
	}
end

BehaviorAbilityq_n.Continue = BehaviorAbilityq_n.Begin
--------------------------------------------------------------------------------------------------------