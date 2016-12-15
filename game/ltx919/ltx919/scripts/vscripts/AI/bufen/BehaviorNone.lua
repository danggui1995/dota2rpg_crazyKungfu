--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate(thisEntity)
	if AICore.currentBehavior == self then return 1 end
	desire = 0
	if Spawn_pos == nil then 
		Spawn_pos = thisEntity:GetAbsOrigin()
	end

	return desire
end

function BehaviorNone:Begin(thisEntity)
	self.endTime = GameRules:GetGameTime() + 1
	
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_NONE
	}
end

function BehaviorNone:Continue()
	self.endTime = GameRules:GetGameTime() + 5
end

--------------------------------------------------------------------------------------------------------