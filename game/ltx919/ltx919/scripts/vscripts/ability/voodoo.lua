LinkLuaModifier("modifier_voodoo_lua", "scripts/vscripts/spelllib/modifier_voodoo_lua.lua", LUA_MODIFIER_MOTION_NONE)

--[[Author: Pizzalol
	Date: 27.09.2015.
	Checks if the target is an illusion, if true then it kills it
	otherwise it applies the hex modifier to the target]]
function voodoo_start( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local duration = keys.duration
	target:AddNewModifier(caster, ability, "modifier_voodoo_lua", {duration = duration})
end