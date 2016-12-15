--------------------------------------------------------------------------------------------------------
BehaviorAbilityw_n = {}

		
function BehaviorAbilityw_n:Evaluate()
	self.wAbility = thisEntity:GetAbilityByIndex(1)
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end
	
	if self.wAbility and self.wAbility:IsFullyCastable() then
		if self.wAbility:GetBehavior() == 2 then
			return desire
		end
		local range = 100
		if AICore:IsNoTarget(self.wAbility) then
			target = AICore:GetAllEnermyInRadius( thisEntity, range )
		end
	end

	if target and #target>=1 then
		desire = 4
	end

	return desire
end

function BehaviorAbilityw_n:Begin()
	self.endTime = GameRules:GetGameTime() + 10

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.wAbility:entindex()
	}
end

BehaviorAbilityw_n.Continue = BehaviorAbilityw_n.Begin
--------------------------------------------------------------------------------------------------------