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
	self.endTime = GameRules:GetGameTime() + 10

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.eAbility:entindex()
	}
end

BehaviorAbilityq_n.Continue = BehaviorAbilityq_n.Begin
--------------------------------------------------------------------------------------------------------