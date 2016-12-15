LinkLuaModifier( "modifier_fire_type_lua" , "scripts/vscripts/ability/modifiers/modifier_fire_type.lua" , LUA_MODIFIER_MOTION_NONE )

function OnAddFireModifier( data )
	local target = data.target
	local duration = data.duration or 3
	if not target then
		return
	end
	if target:HasModifier("modifier_fire_type_lua") then
		target:AddNewModifier(target, nil, "modifier_fire_type_lua", {Duration = duration})
		target:SetModifierStackCount( "modifier_fire_type_lua", nil, target:GetModifierStackCount("modifier_fire_type_lua",nil) + 1 )
	else
		target:AddNewModifier(target, nil, "modifier_fire_type_lua", {Duration = duration})
		target:SetModifierStackCount( "modifier_fire_type_lua", nil, 1 )
	end
end