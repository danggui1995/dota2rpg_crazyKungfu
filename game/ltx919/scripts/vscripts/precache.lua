function PrecacheEveryThingFromKV( context )
    local kv_files = 
    {
	    "scripts/npc/npc_units_custom.txt",
	    "scripts/npc/npc_abilities_custom.txt",
	    "scripts/npc/npc_heroes_custom.txt",
	    "scripts/npc/npc_items_custom.txt"
	}
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
            PrecacheEverythingFromTable( context, kvs)
        end
    end
    local sp = 
	{
		--abaddon  英雄饰品预载入
		"models/items/abaddon/alliance_abba_back/alliance_abba_back.vmdl",
		"models/items/abaddon/head_drake_evercold/head_drake_evercold.vmdl",
		"models/heroes/doom/doom_sword.vmdl",
		"models/heroes/abaddon/mount.vmdl",
		--blood seeker
		"models/items/blood_seeker/belt_savagebeast.vmdl",
		"models/items/blood_seeker/head_savagebeast.vmdl",
		"models/items/blood_seeker/necklace_of_scarlet_claws/necklace_of_scarlet_claws.vmdl",
		"models/items/blood_seeker/weapon_savagebeast.vmdl",
		"models/items/blood_seeker/offhand_savagebeast.vmdl",
		"models/items/blood_seeker/blood_covenant_back/blood_covenant_back.vmdl",
		"models/items/blood_seeker/blood_covenant_arms/blood_covenant_arms.vmdl",

		--omniknight
		"models/items/omniknight/winged_shoulders/winged_shoulders.vmdl",
		"models/items/omniknight/winged_helmet/winged_helmet.vmdl",
		"models/items/omniknight/winged_gauntlet3/winged_gauntlet3.vmdl",
		"models/items/omniknight/winged_cape2/winged_cape2.vmdl",
		"models/items/axe/gross/gross.vmdl",
		"models/heroes/omniknight/head.vmdl",

		"models/items/meepo/riftshadow_roamer_pan/riftshadow_roamer_pan.vmdl",

		"models/heroes/bounty_hunter/bounty_hunter_backpack.vmdl",
		"models/heroes/bounty_hunter/bounty_hunter_pads.vmdl",
		"models/heroes/doom/doom_sword.vmdl",

		"models/items/silencer/whispertribunal__weapon/whispertribunal__weapon.vmdl",
		"models/items/silencer/whispertribunal_arms/whispertribunal_arms.vmdl",
		"models/items/silencer/whispertribunal_belt/whispertribunal_belt.vmdl",
		"models/items/silencer/whispertribunal_head/whispertribunal_head.vmdl",
		"models/items/silencer/whispertribunal_shield/whispertribunal_shield.vmdl",
		"models/items/silencer/whispertribunal_shoulder/whispertribunal_shoulder.vmdl",

		"models/items/tuskarr/frostiron_raider_fist/frostiron_raider_fist.vmdl",
		"models/items/tuskarr/frost_touched_cleaver/frost_touched_cleaver.vmdl",

		"models/heroes/rattletrap/rattletrap_head.vmdl",
		"models/items/rattletrap/artisan_of_havoc_hook/artisan_of_havoc_hook.vmdl",
		"models/heroes/rattletrap/rattletrap_weapon.vmdl",

		"models/items/dragon_knight/crimson_wyvern_shield/crimson_wyvern_shield.vmdl",
		"models/items/dragon_knight/wyvern_bracers/Wyvern_Bracers.vmdl",
		"models/items/dragon_knight/wyvern_shoulder/wyvern_shoulder.vmdl",
		"models/items/dragon_knight/wyvern_sword3/Wyvern_Sword3.vmdl",
		"models/items/dragon_knight/wyvern_skirt3ba/Wyvern_Skirt3ba.vmdl",
		"models/items/dragon_knight/blazingsuperiority_head/blazingsuperiority_head.vmdl",
		"models/items/dragon_knight/blazingsuperiority_back/blazingsuperiority_back.vmdl",

		"models/items/siren/outcast_dagger/outcast_dagger.vmdl",
		"models/items/siren/outcast_spear/outcast_spear.vmdl",
		"models/heroes/siren/siren_hair.vmdl",

		"models/heroes/drow/drow_weapon.vmdl",
		"models/heroes/drow/drow_legs.vmdl",
		"models/heroes/drow/drow_haircowl.vmdl",
		"models/heroes/drow/drow_cape.vmdl",

		"models/items/earthshaker/redguardian_head/redguardian_head.vmdl",
		"models/items/earthshaker/helm_of_impasse/helm_of_impasse.vmdl",
		"models/items/earthshaker/redguardian_belt/redguardian_belt.vmdl",
		"models/items/lion/hell_arm/hell_arm.vmdl",

		"models/heroes/bristleback/bristleback_back.vmdl",
		"models/items/bristleback/heavy_barbed_head/heavy_barbed_head.vmdl",
		"models/items/bristleback/ef_mace_glow/ef_mace_glow.vmdl",

		"models/heroes/sand_king/sand_king_head.vmdl",
		"models/items/sand_king/anuxi_cerci_tail/anuxi_cerci_tail.vmdl",
		"models/heroes/sand_king/sand_king_legs.vmdl",
		"models/heroes/sand_king/sand_king_arms.vmdl",

		"models/heroes/earth_spirit/earth_spirit_head.vmdl",
		"models/items/earth_spirit/vanquishing_demons_arms/vanquishing_demons_arms.vmdl",
		"models/items/earth_spirit/vanquishing_demons_belt/vanquishing_demons_belt.vmdl",
		"models/items/earth_spirit/vanquishing_demons_neck/vanquishing_demons_neck.vmdl",
		"models/items/earth_spirit/dragon_soul/dragon_soul.vmdl",

		"models/heroes/treant_protector/head.vmdl",
		"models/heroes/treant_protector/foliage.vmdl",
		"models/heroes/treant_protector/hands.vmdl",
		"models/heroes/treant_protector/legs.vmdl",
		"models/heroes/juggernaut/juggernaut.vmdl",
		"models/heroes/medusa/medusa_bow.vmdl",
		"models/heroes/medusa/medusa_tail.vmdl",
		"models/heroes/medusa/medusa_torso.vmdl",
		"models/heroes/medusa/medusa_veil.vmdl",

		"models/items/juggernaut/fire_of_the_exiled_ronin/fire_of_the_exiled_ronin.vmdl",
		"models/items/juggernaut/esl_dashing_bladelord_head/esl_dashing_bladelord_head.vmdl",
		"models/items/juggernaut/dc_legsupdate5/dc_legsupdate5.vmdl",
		
		"models/items/ursa/swift_claw_ursa_arms/ursa_swift_claw.vmdl",
		"models/heroes/earthshaker/totem.vmdl",
		"models/items/ursa/ursa_cryo_back/ursa_cryo_back.vmdl",
		"models/items/juggernaut/dc_legsupdate5/dc_legsupdate5.vmdl",

		"models/items/ursa/hat_alpine.vmdl",
		"models/items/ursa/pants_alpine.vmdl",
		"models/items/ursa/gloves_alpine.vmdl",

		"models/heroes/elder_titan/elder_titan_hair.vmdl",
		"models/heroes/shadow_demon/shadow_demon_chain.vmdl",
		"models/heroes/nightstalker/nightstalker_wings_night.vmdl",

		"models/items/slark/golden_barb_of_skadi/golden_barb_of_skadi.vmdl",
		"models/heroes/slark/hood.vmdl",
		"models/items/wraith_king/regalia_of_the_bonelord_cape.vmdl",
		"models/items/nightstalker/black_nihility/black_nihility_back.vmdl",
		"models/heroes/lion/lion_demonarm.vmdl",

		"models/heroes/elder_titan/ancestral_spirit.vmdl",

		--mo1
		"models/items/bounty_hunter/hunternoname_head/hunternoname_head.vmdl",
		"models/heroes/doom/wings.vmdl",
		"models/items/rattletrap/ironclock_weapon/ironclock_weapon.vmdl",

		--qiangdao
		"models/heroes/spirit_breaker/spirit_breaker_weapon.vmdl",
		"models/items/clinkz/bone_fletcher_head_helmet/bone_fletcher_head_helmet.vmdl",

		--sanzun
		"models/items/ember_spirit/blazearmor_belt/blazearmor_belt.vmdl",
		"models/items/ember_spirit/blazearmor_head/blazearmor_head.vmdl",
		"models/items/ember_spirit/mentor_high_plains_head/mentor_high_plains_head.vmdl",
		"models/items/ember_spirit/rapier_burning_god_weapon/rapier_burning_god_weapon.vmdl",
		"models/items/ember_spirit/mentor_high_plains_shoulder/mentor_high_plains_shoulder.vmdl",

		"models/heroes/batrider/batrider_head.vmdl",
		"models/items/batrider/flamestiched_suitings_cape/flamestiched_suitings_cape.vmdl",
		"models/items/batrider/primal_firewing_mount/primal_firewing_mount.vmdl",

		"models/heroes/lone_druid/body.vmdl",
		"models/items/huskar/sacred_bones_offhand_weapon/sacred_bones_offhand_weapon.vmdl",
		"models/items/huskar/searing_dominator/searing_dominator.vmdl",
		"models/items/huskar/burning_spear/burning_spear.vmdl",

		"models/heroes/nightstalker/nightstalker_tail_night.vmdl",
		"models/heroes/nightstalker/nightstalker_wings_night.vmdl",

		"models/items/rattletrap/ironclock_head/ironclock_head.vmdl",
		"models/items/rattletrap/clockmaster_weapon/clockmaster_weapon.vmdl",

		"models/heroes/oracle/armor.vmdl",
		"models/items/huskar/armor_of_reckless_vigor_head/armor_of_reckless_vigor_head.vmdl",
		"models/items/lion/stone_hand/stone_hand.vmdl",
		"models/items/tiny/scarletquarry_offhand/scarletquarry_offhand.vmdl",
		"models/items/tiny/scarletquarry_offhand_t2/scarletquarry_offhand_t2.vmdl",
		"models/items/tiny/scarletquarry_offhand_t3/scarletquarry_offhand_t3.vmdl",
		"models/items/tiny/scarletquarry_offhand_t4/scarletquarry_offhand_t4.vmdl",

		"models/items/beastmaster/fotw_head/fotw_head.vmdl",

		"models/heroes/omniknight/head.vmdl",
		"models/items/omniknight/stalwart_weapon/stalwart_weapon.vmdl",

		"models/items/doom/free2play_weapon_hyhy/free2play_weapon_hyhy.vmdl",
		"models/items/lifestealer/redrage_head/redrage_head.vmdl",

		"models/items/juggernaut/dc_legsupdate5/dc_legsupdate5.vmdl",
		"models/items/juggernaut/bladesrunner_back/bladesrunner_back.vmdl",
		"models/items/juggernaut/dc_headupdate/dc_headupdate.vmdl",
		"models/items/juggernaut/dc_backupdate4/dc_backupdate4.vmdl",
		"models/items/juggernaut/fire_of_the_exiled_ronin/fire_of_the_exiled_ronin.vmdl",

		"models/items/clinkz/bone_fletcher_gloves/bone_fletcher_gloves.vmdl",
		"models/items/clinkz/bone_fletcher_head_helmet/bone_fletcher_head_helmet.vmdl",
		"models/items/clinkz/wep/wep.vmdl",

		"models/items/doom/theimmortalblade/theimmortalblade.vmdl",
		"models/items/doom/ancient_beast_belt/ancient_beast_belt.vmdl",
		"models/items/doom/ancient_beast_shoulders/ancient_beast_shoulders.vmdl",
		"models/items/doom/ancient_beast_head/ancient_beast_head.vmdl",

		"models/heroes/shadow_fiend/head_arcana.vmdl",
		"models/items/shadow_fiend/arms_deso/arms_deso.vmdl",
		"models/heroes/shadow_fiend/shadow_fiend_shoulders.vmdl",

		"models/items/doom/fallen_sword/fallen_sword.vmdl",
		"models/heroes/oracle/armor.vmdl",
		"models/heroes/dazzle/dazzle_shoulder.vmdl",

		"models/heroes/invoker/invoker_head.vmdl",
		"models/items/invoker/arsenal_magus_exort_mask/arsenal_magus_exort_mask.vmdl",
		"models/items/invoker/dark_sorcerer_belt/dark_sorcerer_belt.vmdl",

		"models/items/tidehunter/claddish_cudgel/claddish_cudgel.vmdl",
		"models/items/tidehunter/tidehunter_mine.vmdl",

		"models/items/antimage/god_eater_arms/god_eater_arms.vmdl",
		"models/items/antimage/god_eater_armor/god_eater_armor.vmdl",
		"models/items/antimage/god_eater_belt/god_eater_belt.vmdl",
		"models/items/antimage/god_eater_head/god_eater_head.vmdl",
		"models/items/antimage/god_eater_shoulder/god_eater_shoulder.vmdl",
		"models/items/antimage/god_eater_weapon/god_eater_weapon.vmdl",
		"models/items/antimage/god_eater_off_hand/god_eater_off_hand.vmdl",
		

		"models/items/ember_spirit/rapier_burning_god_offhand/rapier_burning_god_offhand.vmdl",
		"models/items/ember_spirit/rapier_burning_god_weapon/rapier_burning_god_weapon.vmdl",
		"models/items/ember_spirit/blazearmor_belt/blazearmor_belt.vmdl",
		"models/items/ember_spirit/rekindled_ashes_head/rekindled_ashes_head.vmdl",
		"models/items/ember_spirit/rekindled_ashes_shoulder/rekindled_ashes_shoulder.vmdl",

		"models/items/lycan/ambry_belt/ambry_belt.vmdl",
		"models/items/lycan/ambry_armor/ambry_armor.vmdl",
		"models/heroes/lycan/lycan_head.vmdl",
		"models/items/lycan/ambry_head/ambry_head.vmdl",
		"models/items/lycan/ambry_shoulder/ambry_shoulder.vmdl",
		"models/items/lycan/ambry_weapon/ambry_weapon.vmdl",

		"models/heroes/phantom_lancer/phantom_lancer_head.vmdl",
		"models/heroes/phantom_lancer/phantom_lancer_belt.vmdl",
		"models/heroes/phantom_lancer/phantom_lancer_shoulderpad.vmdl",
		"models/items/phantom_lancer/infinite_waves_serpent_weapon/infinite_waves_serpent_weapon.vmdl",

		"models/items/spectre/malicious_head/malicious_head.vmdl",
		"models/items/spectre/darkgabriel_shoulder/darkgabriel_shoulder.vmdl",
		"models/items/spectre/dotapit_s3_spectral_guardian_belt/dotapit_s3_spectral_guardian_belt.vmdl",
		"models/items/spectre/teeth_of_the_eternal_light/teeth_of_the_eternal_light.vmdl",

		"models/heroes/omniknight/head.vmdl",
		"models/items/omniknight/grey_night_back/grey_night_back.vmdl",
		"models/items/omniknight/grey_night_head/grey_night_head.vmdl",
		"models/items/omniknight/gusa_maul/gusa_maul.vmdl",

		"models/heroes/spirit_breaker/spirit_breaker_head.vmdl",
		"models/items/spirit_breaker/elemental_realms_shoulder/elemental_realms_shoulder.vmdl",
		"models/items/spirit_breaker/elemental_realms_head/elemental_realms_head.vmdl",
		"models/items/spirit_breaker/elemental_realms_weapon/elemental_realms_weapon.vmdl",

		"models/heroes/tiny_01/tiny_01_head.vmdl",
		"models/heroes/tiny_01/tiny_01_left_arm.vmdl",
		"models/heroes/tiny_01/tiny_01_right_arm.vmdl",
		"models/heroes/tiny_01/tiny_01_body.vmdl",

		"models/items/rubick/puppet_master_doll/puppet_master_doll.vmdl",
		"models/items/rubick/puppet_master_head/puppet_master_head.vmdl",
		"models/items/rubick/puppet_master_weapon/puppet_master_weapon.vmdl",
		"models/items/rubick/puppet_master_back/puppet_master_back.vmdl",

		"models/items/doom/crown_of_omoz/crown_of_omoz.vmdl",
		"models/items/doom/blazing_lord_shoulder/blazing_lord_shoulder.vmdl",
		"models/items/doom/blazing_lord_belt/blazing_lord_belt.vmdl",
		"models/items/doom/fallen_sword/fallen_sword.vmdl",

		"models/items/windrunner/armaments_of_the_wind_head/armaments_of_the_wind_head.vmdl",
		"models/items/windrunner/rainmaker_bow/rainmaker_bow.vmdl",
		"models/items/windrunner/sparrowhawk_cape/sparrowhawk_cape.vmdl",
		"models/items/windrunner/orchid_flowersong_shoulder/orchid_flowersong_shoulder.vmdl",

		"models/items/siren/arms_of_the_captive_princess_armor/arms_of_the_captive_princess_armor.vmdl",
		"models/items/siren/arms_of_the_captive_princess_head/arms_of_the_captive_princess_head.vmdl",

		"models/items/juggernaut/armor_for_the_favorite_arms/armor_for_the_favorite_arms.vmdl",
		"models/items/juggernaut/armor_for_the_favorite_back/armor_for_the_favorite_back.vmdl",
		"models/items/juggernaut/armor_for_the_favorite_head/armor_for_the_favorite_head.vmdl",
		"models/items/juggernaut/armor_for_the_favorite_legs/armor_for_the_favorite_legs.vmdl",
		"models/items/juggernaut/armor_for_the_favorite_weapon/armor_for_the_favorite_weapon.vmdl",

		"models/items/brewmaster/wep_brewmaster_cleaver_01/wep_brewmaster_cleaver_01.vmdl",

		"models/items/skywrath_mage/blessing_of_the_crested_dawn_back/blessing_of_the_crested_dawn_back.vmdl",
		"models/items/skywrath_mage/guiding_lights_weapon1/guiding_lights_weapon1.vmdl",

		"models/items/storm_spirit/esl_harmony_armor/esl_harmony_armor.vmdl",
		"models/items/storm_spirit/esl_harmony_arms/esl_harmony_arms.vmdl",
		"models/items/storm_spirit/anuxi_ring_of_storm/anuxi_ring_of_storm.vmdl",

		"models/heroes/troll_warlord/troll_warlord_head.vmdl",
		"models/heroes/troll_warlord/troll_warlord_axe_melee_l.vmdl",
		"models/heroes/troll_warlord/troll_warlord_axe_ranged_r.vmdl",
		"models/heroes/troll_warlord/mesh/troll_warlord_armor_model_lod0.vmdl",
		"models/heroes/troll_warlord/troll_warlord_shoulders.vmdl",

		"models/items/slark/crawblade/crawblade.vmdl",
		"models/items/slark/shivshell_head/shivshell_head.vmdl",

		"models/items/phantom_assassin/kiss_of_crows_weapon/kiss_of_crows_weapon.vmdl",
		"models/items/phantom_assassin/phantom_knight_shoulder/phantom_knight_shoulder.vmdl",
		"models/items/phantom_assassin/kiss_of_crows_head/kiss_of_crows_head.vmdl",
		"models/items/phantom_assassin/phantom_knight_belt/phantom_knight_belt.vmdl",
		"models/items/phantom_assassin/phantom_knight_back/phantom_knight_back.vmdl"


	}
	local t = #sp
	for i=1,t do
		PrecacheResource("model", sp[i], context)
		print("PrecacheResource:",sp[i])
	end

	local task_part_ltx = 
	{
		"particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash_water9b.vpcf",
		"particles/units/heroes/hero_dazzle/dazzle_base_attack.vpcf",
		"particles/units/heroes/hero_huskar/huskar_base_attack.vpcf",
		"particles/units/heroes/hero_invoker/invoker_base_attack.vpcf",
		"particles/units/heroes/hero_lina/lina_base_attack.vpcf",
		"particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
		"particles/units/heroes/hero_razor/razor_base_attack.vpcf",
		"particles/units/heroes/hero_shadow_demon/shadow_demon_base_attack.vpcf",
		"particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf",
		"particles/econ/items/sniper/sniper_charlie/sniper_base_attack_bulletcase_charlie.vpcf",
		"particles/units/heroes/hero_tinker/tinker_base_attack.vpcf",
		"particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf",
		"particles/econ/items/witch_doctor/witch_doctor_ribbitar/witchdoctor_ward_cast_staff_fire_ribbitar_c.vpcf",
		"particles/econ/items/zeus/lightning_weapon_fx/zuus_base_attack_arc_immortal_lightning.vpcf",
		"particles/items_fx/desolator_projectile.vpcf",
		"particles/econ/items/keeper_of_the_light/kotl_weapon_arcane_staff/keeper_base_attack_arcane_staff.vpcf",
		"particles/units/heroes/hero_viper/viper_base_attack.vpcf",
		"particles/econ/events/ti6/hero_levelup_ti6.vpcf",			--accept task particle
		"particles/items2_fx/refresher.vpcf"		
	}
	--[[]]
	local npart_ltx = #task_part_ltx
	for i=1,npart_ltx do
		PrecacheResource("particle", task_part_ltx[i], context)

		print("PrecacheResource:",task_part_ltx[i])
	end

	local sound_ltx = 
	{
		"soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lich.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_chen.vsndevts",
		"soundevents/custom_sound_events.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts",
		"soundevents/voscripts/game_sounds_vo_secretshop.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_viper.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_slark.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_lion.vsndevts"
	}
	local nsound_ltx = #sound_ltx
	for i=1,nsound_ltx do
		PrecacheResource("soundfile", sound_ltx[i], context)
		print("PrecacheResource:",sound_ltx[i])
	end
	
end
 
function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            PrecacheEverythingFromTable( context, value )
        else
            if string.find(value, "vpcf") then
                PrecacheResource( "particle",  value, context)
                print("PRECACHE PARTICLE RESOURCE", value)
            end
            if string.find(value, "vmdl") then  
                PrecacheResource( "model",  value, context)
                print("PRECACHE vmdl RESOURCE", value)
            end
            if string.find(value, "vsndevts") then
                PrecacheResource( "soundfile",  value, context)
                print("PRECACHE SOUND RESOURCE", value)
            end
        end
    end    
end