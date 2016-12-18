--------------------------------------------------------------------------------------------------------
BehaviorBack = {}

function BehaviorBack:Evaluate(thisEntity)
	if AICore.currentBehavior == self then return 6 end
	desire = 0
	if not Spawn_pos then
		return desire
	end
	if (thisEntity:GetAbsOrigin() - Spawn_pos):Length2D()>700 then
		desire = 6
	end

	return desire
end

function BehaviorBack:Begin(thisEntity)
	self.endTime = GameRules:GetGameTime() + 1
	
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION ,
		Position = Spawn_pos
	}
end

function BehaviorBack:Continue()
	self.endTime = GameRules:GetGameTime() + 1
end

--------------------------------------------------------------------------------------------------------