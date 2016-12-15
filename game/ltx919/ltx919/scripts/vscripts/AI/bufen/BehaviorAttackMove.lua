--------------------------------------------------------------------------------------------------------

BehaviorAttackMove = {}

function BehaviorAttackMove:Evaluate()
	return 1
end

function BehaviorAttackMove:Begin()
	self.endTime = GameRules:GetGameTime() + 6
	local _ent = Entities:FindByName(nil,"ent_base")
	local _pos = _ent:GetAbsOrigin()
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE ,
		Position = _pos
	}
end

function BehaviorAttackMove:Continue()
	self.endTime = GameRules:GetGameTime() + 6
end

--------------------------------------------------------------------------------------------------------