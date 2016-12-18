function task_songshui1_com(trigger)
    local unit = trigger.activator
    local nt=unit:GetPlayerID()
    local hPlayer = PlayerResource:GetPlayer(nt)
    if unit:IsRealHero() and unit:HasItemInInventory("item_empty_bottle") then                 
        for i=0,5 do
        	local hItem = unit:GetItemInSlot(i)
            if hItem~=nil then
            	if (hItem:GetName())=="item_empty_bottle" then
            		unit:RemoveItem(hItem)
            		unit:AddItemByName("item_full_bottle")
            		local pts = ParticleManager:CreateParticle(
            				"particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash_water9b.vpcf",
            				PATTACH_CUSTOMORIGIN_FOLLOW,
            				unit
            			)
            		ParticleManager:SetParticleControl(pts, 0, unit:GetOrigin())
            		unit:SetContextThink("deletep", 
    			    	function(  )
    			    		ParticleManager:DestroyParticle(pts,false)
    			    	end
    			    , 0.5)
    			    EmitSoundOn("Bottle.Cork", unit)
            		break
            	end
            end
        end
    end
end


function task_songshui2_com(trigger )
    local unit = trigger.activator

    local nt=unit:GetPlayerID()
    local hPlayer = PlayerResource:GetPlayer(nt)
    if unit:IsRealHero()  and (unit:HasItemInInventory("item_empty_bottle") or unit:HasItemInInventory("item_full_bottle")) then
        for i=0,5 do
            local hItem = unit:GetItemInSlot(i)
            if hItem~=nil then
                if (hItem:GetName())=="item_empty_bottle" or (hItem:GetName())=="item_full_bottle" then
                    unit:RemoveItem(hItem)
                    unit:AddItemByName("item_spec_bottle")
                    local pts = ParticleManager:CreateParticle(
                            "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash_water9b.vpcf",
                            PATTACH_CUSTOMORIGIN_FOLLOW,
                            unit
                        )
                    ParticleManager:SetParticleControl(pts, 0, unit:GetOrigin())
                    unit:SetContextThink("deletep", 
                        function(  )
                            ParticleManager:DestroyParticle(pts,false)
                        end
                    , 0.5)
                    EmitSoundOn("Bottle.Cork", unit)
                    break
                end
            end
        end
    end
end


function OnEnterFeiDao( trigger )
    local hero = trigger.activator
    local id = hero:GetPlayerOwnerID()
    local __state = GameRules.othersT["other8"]["state"]
    local __arrive = GameRules.othersT["other8"]["arrive"]
    if bit.band(__state,2^id)~=0 and bit.band(__arrive,2^id)==0 then
        GameRules.othersT["other8"]["arrive"] = bit.bor(__arrive,2^tonumber(id))
        mytask_system:OnUIRefresh(id,GameRules.othersT["other8"])
    end
end
