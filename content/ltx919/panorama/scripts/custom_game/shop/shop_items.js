"use strict";

var m_itemName = "";
var m_shopIndex = -1;
var m_unit = -1;
var m_IsP = -1;
var m_gold = 0;
var m_data = {};
var __bj = 0 ;
function BuyItem () {
	var m_Isinrange = GameUI.CustomUIConfig().getInRange();
	if(!m_Isinrange)
	{
		var temp = {};
		temp['text'] = "#no_shop_in_range";
		temp['duration'] = 1;
		temp['style'] = {color:"red"};
		GameUI.CustomUIConfig().errorMessage(temp)
		Game.EmitSound( "General.Cancel" );
		return;
	}
	if (m_gold>	Players.GetGold( Game.GetLocalPlayerID() ))
	{
		var temp = {};
		temp['text'] = "#jinbibuzu";
		temp['duration'] = 1;
		temp['style'] = {color:"red"};
		GameUI.CustomUIConfig().errorMessage(temp)
		Game.EmitSound( "warning.moregold" );
		return;
	}
	if (m_IsP == 0)
	{
		var temp = {};
		temp['text'] = "#baoshi_error";
		temp['duration'] = 1;
		temp['style'] = {color:"red"};
		GameUI.CustomUIConfig().errorMessage(temp)
		Game.EmitSound( "General.Cancel" );
		return;
	}/*
	else if (m_IsP == 2)
	{
		var temp = {};
		temp['text'] = "#hecheng_error";
		temp['duration'] = 1;
		temp['style'] = {color:"red"};
		GameUI.CustomUIConfig().errorMessage(temp)
		Game.EmitSound( "General.Cancel" );
		return;
	}
	else if (m_IsP == 3)
	{
		var temp = {};
		temp['text'] = "#manmanhecheng";
		temp['duration'] = 1;
		temp['style'] = {color:"red"};
		GameUI.CustomUIConfig().errorMessage(temp)
		Game.EmitSound( "General.Cancel" );
		return;
	}*/
	m_unit = Players.GetLocalPlayerPortraitUnit();
	if( m_unit != -1)
	{
		if (m_IsP==1)
		{
			Game.EmitSound( "General.Buy" );
			GameEvents.SendCustomGameEventToServer( "UI_BuyItem", { 'entindex':m_unit, 'name':m_itemName,'gold':m_gold} );
			return;
		}
		var __data = GameUI.CustomUIConfig().getItemInfo();
		__bj=0;
		dg_finditem(m_itemName,__data);
	}
}

function dg_finditem(itemname,__data)
{
	for( var i in __data[2] )
	{
		if (__data[2][i].name == itemname)
		{
			for(var _i in __data[2][i].need)
			{
				if (__bj==1)
				{
					return;
				}
				//$.Msg(__data[2][i].need[_i]+  "  fuck");
				var __p = -1;
				var gold = 0;
				for(var ii in __data[1])
				{
					if (__data[1][ii].name==__data[2][i].need[_i])
					{
						__p = __data[1][ii].__p;
						gold = __data[1][ii].gold;
						break;
					}
				}
				var bj = 0;
				for(var j=0;j<12;j++)
				{
					if (Abilities.GetAbilityName( Entities.GetItemInSlot( m_unit, j ) )==__data[2][i].need[_i])
					{
						bj=1;
						break;
					}
				}
				if (bj==1)
				{
					continue;
				}
				//$.Msg(gold+"    "+__data[2][i].need[_i]+"  "+__data[2][i].name);
				if (gold>Players.GetGold( Game.GetLocalPlayerID() ))
				{
					var temp = {};
					temp['text'] = "#jinbibuzu";
					temp['duration'] = 1;
					temp['style'] = {color:"red"};
					GameUI.CustomUIConfig().errorMessage(temp)
					Game.EmitSound( "warning.moregold" );
					__bj=1;
					return -1;
				}
				if (__p==1)
				{

					Game.EmitSound( "General.Buy" );
					GameEvents.SendCustomGameEventToServer( "UI_BuyItem", { 'entindex':m_unit, 'name':__data[2][i].need[_i],'gold':gold} );
				}
			//	$.Schedule(1,function () {
				dg_finditem(__data[2][i].need[_i],__data);
			//			})
				
			}
		}
	}
}

function SetItem (data, func) {
	m_unit = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
	m_itemName = data.name;
	$('#ItemImage').itemname = m_itemName;
	m_IsP = data.__p;
	m_gold = data.gold;
}

function OnMouseOver () {
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), m_itemName, m_unit );
}

function OnMouseOut () {
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
}

function OnShowCompose()
{
	var temp= {};
	temp.name = m_itemName;
	temp.__p = m_IsP;
	temp.gold = m_gold;
	GameUI.CustomUIConfig().loadCompose(temp);
}

(function () {
	$.GetContextPanel().SetItem = SetItem;
})();

