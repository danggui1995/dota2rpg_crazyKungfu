"use strict";

var CurrentHero = -1;
var CurrentPlayerID = -1;
var str_g = 0;
var int_g = 0;
var agi_g = 0;
var hp_r = 0;
var mp_r = 0;
function UpdateGameUI () {
	//var entIndex = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
	var entIndex = Players.GetLocalPlayerPortraitUnit();
	if(entIndex != -1)
	{
		var max_health = Entities.GetMaxHealth(entIndex);
		var health_percent = 100-Entities.GetHealthPercent(entIndex);
		var health = Entities.GetHealth( entIndex );
		$("#HealthOverlay").style.height = health_percent.toString() + "%";
		$("#HealthNum").text = health.toString() + " / " + max_health.toString();
		var mana = Entities.GetMana(entIndex);
		var max_mana = Entities.GetMaxMana(entIndex);
		var mana_percent = 100-( mana / ((max_mana == 0)? 1 : max_mana) )*100;
		$("#ManaOverlay").style.height = mana_percent.toString() + "%";
		$("#ManaNum").text = mana.toString() + " / " + max_mana.toString();
		var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());
		var xpBase = 0;

		var level = Entities.GetLevel(entIndex);
		$("#HeroLevelText").text = level;
		var b_ishero = Entities.IsRealHero( entIndex );
		if (b_ishero)
		{
			var __gold = 	Players.GetGold( Game.GetLocalPlayerID() );
			$("#myGoldText").text = __gold;
			var curExp = Entities.GetCurrentXP(entIndex);
			var totalExp = Entities.GetNeededXPToLevel(entIndex);
			totalExp = ((totalExp)? totalExp : 1);
			for(var i = 1;i<level;i++)
			{
				xpBase = xpBase + i*200;
			}
			totalExp -= xpBase;
			curExp -= xpBase;
			var percentExp = ( curExp / totalExp)*100;
			$("#EXPOverlay").style.width = percentExp.toString() + "%";
			$("#ExpNum").text = curExp.toString() + " / " + totalExp.toString();
		}
		
		var damage_min = Entities.GetDamageMin( entIndex );
		var damage_max = Entities.GetDamageMax( entIndex );
		var damage_avg = (damage_min + damage_max )/ 2;
		var damage_bonus = Entities.GetDamageBonus( entIndex );
		var temp_damagetxt = damage_avg.toString();
		var temp_bonustxt = " + " + damage_bonus.toString();
		$('#HeroNameText').text = $.Localize("#"+Entities.GetUnitName( entIndex ));	
		$('#HeroDamageText').text = $.Localize("#gongjili")+" : "+temp_damagetxt;
		if (damage_bonus == 0)
		{
			$('#HeroDamageText2').text = "";
		}
		else
		{
			$('#HeroDamageText2').text = " + " + damage_bonus;
		}
		$('#HeroArmorText').text = $.Localize("#hujia")+" : "+Math.floor(Entities.GetArmorForDamageType( entIndex, 1 ));
		// 1 : wulihujia   2 : mofakangxing
		$("#MoveSpeedValueText").text = $.Localize("#yisu")+" : "+Math.floor(Entities.GetMoveSpeedModifier(entIndex,Entities.GetBaseMoveSpeed(entIndex)));
		$('#MagicResistenceText').text = $.Localize("#mokang")+" : "+Math.floor(Entities.GetArmorForDamageType( entIndex, 2 )*100);
		$('#AttackSpeedText').text = $.Localize("#gongsu")+" : "+Math.ceil(Entities.GetAttackSpeed( entIndex )*100);
	}

	$.Schedule(0.03,UpdateGameUI);
}
function BackSelf () {
	Players.PlayerPortraitClicked( Players.GetLocalPlayer(), false, false );
}

function HideP()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideTextTooltip" );
}
function ShowP(data)
{
	var entIndex = Players.GetLocalPlayerPortraitUnit();
	if (data=="1" || data==1)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $('#HealthOverlayPanel'), Math.floor(hp_r*100)/100);
	}
	else if (data==2)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $('#ManaOverlayPanel'), Math.floor(mp_r*100)/100);
	}
	else if (data==3)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $('#HeroStr'), Math.floor(str_g*100)/100);
	}
	else if (data==4)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $('#HeroAgi'), Math.floor(agi_g*100)/100);
	}
	else if (data==5)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $('#HeroInt'), Math.floor(int_g*100)/100);
	}
}
function Refresh_Properties(data)
{
	var _str = data._str;
	var _agi = data._agi;
	var _int = data._int;
	var _shengwang = data._shengwang
	$('#HeroStrText').text = $.Localize("#liliang") +"  :  "+ _str;
	$('#HeroAgiText').text = $.Localize("#minjie") +"  :  "+ _agi;
	$('#HeroIntText').text = $.Localize("#zhili") +"  :  "+ _int;
	$('#ShengWangText').text = $.Localize("#shengwang") +"  :  "+ _shengwang;
	agi_g = data._str_g;
	int_g = data._int_g;
	str_g = data._str_g;
	hp_r = data._hp_r;
	mp_r = data._mp_r;
}

(function()
{
	UpdateGameUI();
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateGameUI );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateGameUI );
	GameEvents.Subscribe( "refresh_properties", Refresh_Properties );

})();
