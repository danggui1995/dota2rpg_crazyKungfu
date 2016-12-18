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
	self.endTime = GameRules:GetGameTime() + 10

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.rAbility:entindex()
	}
end

BehaviorAbilityr_n.Continue = BehaviorAbilityr_n.Begin
--------------------------------------------------------------------------------------------------------