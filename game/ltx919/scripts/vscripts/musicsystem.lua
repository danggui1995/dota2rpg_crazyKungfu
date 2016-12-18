music_table={
	{"ent_base","bgm.jifengzhuan",126.0,true},
	{"ent_base","bgm.mingshen",161.0,true},
	{"ent_base","bgm.tagexing",97.0,true},
	{"ent_base","bgm.qingkong",201.0,true},
	{"ent_base","bgm.yujianjianghu",105.0,true},
	{"ent_base","bgm.jianguanbaihong",178.0,true}
}
GameRules.bgm_index = RandomInt(1, 6)

function InitBackGroundMusic()
	local v = music_table[GameRules.bgm_index]
	local ent = Entities:FindByName(nil, v[1])
	if ent ~= nil then
		ent:SetContextThink(v[1],
			function ()
				v = music_table[GameRules.bgm_index]
				EmitSoundOn(v[2],ent)
				if v[4] then
					if GameRules.bgm_index == #music_table then
						GameRules.bgm_index = 1
					else
						GameRules.bgm_index = (GameRules.bgm_index + 1)
					end
					return v[3]
				else
					return nil
				end
			end, 
		0.1)
	end
end

function EmitSoundBackGroundMusic(strMusic)
	for k,v in ipairs(music_table) do
		if v[1] == strMusic then
			local ent = Entities:FindByName(nil, v[1])
			if ent ~= nil then
				ent:SetContextThink(v[1],
					function ()
						ent:EmitSoundParams(v[2],0,30,0)
						--EmitSoundOn(v[2],ent)
						v[4] = true
						return v[3]
					end, 
				0.1)
			end
		end
	end
end

function StopSoundBackGroundMusic(strMusic)
	for k,v in ipairs(music_table) do
		if v[1] == strMusic then
			local ent = Entities:FindByName(nil, v[1])
			if ent ~= nil then
				ent:SetContextThink(v[1],
					function ()
						StopSoundOn(v[2],ent)
						v[4] = false
						return nil
					end, 
				0.1)
			end
		end
	end
end