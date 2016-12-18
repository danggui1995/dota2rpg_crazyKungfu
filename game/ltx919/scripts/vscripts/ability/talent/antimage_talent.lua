require('libraries/animations')
function OnStart( data )
	--print("come in start")
	local hCaster = data.caster
	local ability = data.ability
	hCaster:AddNoDraw()
	local center = hCaster:GetAbsOrigin()
	local foward = hCaster:GetForwardVector()
	local x = foward.x
	local y = foward.y
	local z = foward.z
	local distance = ability:GetLevelSpecialValueFor("distance", (ability:GetLevel() - 1))
	local movespeed = ability:GetLevelSpecialValueFor("movespeed", (ability:GetLevel() - 1))
	local xl_new = {}
	local index = 1
	for i=-1,1 do
		--x*cosA-y*sinA,  x*sinA+y*cosA
		local x_new = x*math.cos(math.pi/6*i)-y*math.sin(math.pi/6*i)
		local y_new = x*math.sin(math.pi/6*i)+y*math.cos(math.pi/6*i)
		xl_new[index] = Vector(x_new,y_new,z)
		index = index + 1
	end
end

function OnEnd( data )
	--print("come in end")
	local hCaster = data.caster 
	local ability = data.ability
	hCaster:RemoveNoDraw()
end

function HideWearables( hero,ability )
	hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( hero )
	for i,v in pairs(hero.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
	end
end