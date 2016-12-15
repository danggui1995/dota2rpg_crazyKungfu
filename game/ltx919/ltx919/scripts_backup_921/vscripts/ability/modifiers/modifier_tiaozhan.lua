require('libraries/notifications')
if modifier_tiaozhan_lua == nil then
    modifier_tiaozhan_lua = class({})
end

function modifier_tiaozhan_lua:IsHidden()
	return true
end

function modifier_tiaozhan_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_tiaozhan_lua:AllowIllusionDuplicate()
	return false
end

function modifier_tiaozhan_lua:OnCreated( kv )
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_tiaozhan_lua:OnIntervalThink()
	if IsServer() then
		local caster = self:GetParent()
		for k,v in pairs(GameRules.tiaozhan_t) do
			if v["yx"] and v["jx"] and v["jx"]:IsAlive() and v["yx"]:IsAlive() and (v["yx"]:GetAbsOrigin()-v["jx"]:GetAbsOrigin()):Length2D() > 4000 then
				local jl = v["jl"]
				--print("come in fuck")
				v["yx"]:RemoveModifierByName(self:GetName())
				v["jx"]:ForceKill(false)
				GameRules.tiaozhan[jl] = 1
				table.remove(GameRules.tiaozhan_t,k)
				return
			end
			if v["yx"] and v["jx"] and v["jx"]:IsAlive() and not v["yx"]:IsAlive() and v["yx"]==caster then
				v["jx"]:ForceKill(false)
				--print("come in fuck 2")
				local hero = v["yx"]
				hero:RemoveModifierByName(self:GetName())
				GameRules.tiaozhan[v["jl"]] = 1
				table.remove(GameRules.tiaozhan_t,k)
				return
			end
			if v["yx"] and v["yx"]==caster and (not v["jx"] or not v["jx"]:IsAlive()) then
				local jl = v["jl"]
				local hero = v["yx"]
				local hPlayer = hero:GetPlayerOwner()
				--print(jl)
				if jl==1 then
					--print("come in 1")
					local __rd = RandomInt(1,2)
					if __rd == 1 then
						hero:SetBaseStrength(hero:GetBaseStrength()+20)
						hero:SetBaseIntellect(hero:GetBaseIntellect()+20)
						hero:SetBaseAgility(hero:GetBaseAgility()+20)
						Notifications:Top(hPlayer,{text="#gotall",duration=2,style={color="red"},continue=false})
						Notifications:Top(hPlayer,{text=20,duration=2,style={color="red"},continue=true})
					elseif __rd == 2 then
						local itemSellPrice = RandomInt(4000,5000)
        				hero:ModifyGold(itemSellPrice, false, 0) 
        				Notifications:Top(hPlayer,{text="#gotgold",duration=2,style={color="red"},continue=false})
						Notifications:Top(hPlayer,{text=itemSellPrice,duration=2,style={color="red"},continue=true})
					end
					hero:RemoveModifierByName(self:GetName())
				elseif jl==2 then
					--print("come in 2")
					local __rd = RandomInt(1,2)
					if __rd == 1 then
						hero:SetBaseStrength(hero:GetBaseStrength()+100)
						hero:SetBaseIntellect(hero:GetBaseIntellect()+100)
						hero:SetBaseAgility(hero:GetBaseAgility()+100)
						Notifications:Top(hPlayer,{text="#gotall",duration=2,style={color="red"},continue=false})
						Notifications:Top(hPlayer,{text=100,duration=2,style={color="red"},continue=true})
					elseif __rd == 2 then
						local itemSellPrice = RandomInt(13000,14000)
        				hero:ModifyGold(itemSellPrice, false, 0) 
        				Notifications:Top(hPlayer,{text="#gotgold",duration=2,style={color="red"},continue=false})
						Notifications:Top(hPlayer,{text=itemSellPrice,duration=2,style={color="red"},continue=true})
					end
					hero:RemoveModifierByName(self:GetName())
				elseif jl==3 then
					local __str = hero:GetBaseStrength()
					local __agi = hero:GetBaseAgility()
					local __int = hero:GetBaseIntellect()
					local _ability = {}
					local _level = {}
					for i=0,5 do
						local __ability = hero:GetAbilityByIndex(i)
						if __ability then
							--print(i)
							_ability[i+1] = __ability:GetAbilityName()
							_level[i+1] = __ability:GetLevel()
						end
					end
					local id = hero:GetPlayerOwnerID()
					local __gold = PlayerResource:GetGold(id)
					PlayerResource:ReplaceHeroWith(id, hero:GetUnitName(),__gold,0)
					if hero then
						hero:RemoveSelf()
					end
					hero = PlayerResource:GetSelectedHeroEntity(id)
					for i=0,4 do
						if _ability[i+1] then 
							hero:RemoveAbility("ability_empty"..i+1)
							hero:AddAbility(_ability[i+1])
							local illusionAbility = hero:FindAbilityByName(_ability[i+1])
							illusionAbility:SetLevel(_level[i+1])
						end
					end
					hero:SetAbilityPoints(0)
					hero:SetBaseStrength(__str)
					hero:SetBaseAgility(__agi)
					hero:SetBaseIntellect(__int)
					local player = PlayerResource:GetPlayer(id)
					GameRules.nlys[id+1] = GameRules.nlys[id+1] + 1
					GameRules.sss[id+1]:SetOwner(hero)
					CustomGameEventManager:Send_ServerToPlayer(player,"__refresh_nlys",{nlys = GameRules.nlys[id+1]})
				end
				local __ent_base = Entities:FindByName(nil,"ent_base")
				local __pos = __ent_base:GetAbsOrigin()
				local id = hero:GetPlayerOwnerID()
				FindClearSpaceForUnit(hero, __pos, false) 
				hero:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
				hero:Stop()
				PlayerResource:SetCameraTarget(id, hero)
				GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera"),
				    function (  ) PlayerResource:SetCameraTarget(id, nil) end,0.5)
				GameRules.tiaozhan[jl] = 1	
				table.remove(GameRules.tiaozhan_t,k)
			end
		end
		return 0.5
	end
end

function modifier_tiaozhan_lua:IsPurgable()
	return false
end

function modifier_tiaozhan_lua:DeclareFunctions()
	local funcs = {
	}
	return funcs
end
