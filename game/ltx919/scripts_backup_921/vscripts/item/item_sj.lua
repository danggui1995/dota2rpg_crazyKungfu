require('libraries/notifications')
local function stringSplit(str, sep)
    if type(str) ~= 'string' or type(sep) ~= 'string' then
        return nil
    end
    local res_ary = {}
    local cur = nil
    for i = 1, #str do
        local ch = string.byte(str, i)
        local hit = false
        for j = 1, #sep do
            if ch == string.byte(sep, j) then
                hit = true
                break
            end
        end
        if hit then
            if cur then
                table.insert(res_ary, cur)
            end
            cur = nil
        elseif cur then
            cur = cur .. string.char(ch)
        else
            cur = string.char(ch)
        end
    end
    if cur then
        table.insert(res_ary, cur)
    end
    return res_ary
end


function OnIncrease( data )
	local hItem = data.ability
	local hCaster = data.caster
	local sj_num = hItem:GetSpecialValueFor("sj_num")
	--print(sj_num)
	local itemName = hItem:GetAbilityName()
	local itemLevel = string.sub(itemName,string.len(itemName),string.len(itemName))
	--print(itemLevel)
	if not sj_num then
		return 
	end
	if hItem.curIndex < sj_num then
		hItem.curIndex = hItem.curIndex + 1
		local id = hCaster:GetPlayerOwnerID()
		--print(hItem.curIndex)
		--print(sj_num)
		Notifications:MidLeft(id,{text="\n",duration=3,style={color="#580643",["font-size"]="20px"}})
		Notifications:MidLeft(id,{text="【",duration=3,style={color="#580643",["font-size"]="20px"},continue=true})
		Notifications:MidLeft(id,{text="DOTA_Tooltip_ability_"..itemName,duration=3,style={color="#580643",["font-size"]="20px"},continue=true})
		Notifications:MidLeft(id,{text=" 】 "..hItem.curIndex.." / "..sj_num,duration=3,style={color="#580643",["font-size"]="20px"},continue=true})
	else
		hItem.curIndex = nil
		hCaster:RemoveItem(hItem)
		local newName = string.sub(itemName,1,string.len(itemName)-1)
		local hNew = CreateItem(newName..(itemLevel+1),nil,nil)
		hCaster:AddItem(hNew)	
		local nIceIndex = ParticleManager:CreateParticle(
		"particles/items2_fx/refresher.vpcf", 
		PATTACH_CUSTOMORIGIN, 
		hCaster)
	    ParticleManager:SetParticleControl(nIceIndex, 0, hCaster:GetAbsOrigin())
	end
end