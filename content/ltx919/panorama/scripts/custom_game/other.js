"use strict";

function ComeInArea(data)
{
	var opt = data.opt;
	if (opt!=undefined)
		$('#Jxcs').style.visibility = 'visible';
	else
		$('#Fubencs').style.visibility = 'visible';
}

function QuitArea(data)
{
	var opt = data.opt;
	if (opt!=undefined)
		$('#Jxcs').style.visibility = 'collapse';
	else
		$('#Fubencs').style.visibility = 'collapse';
}

function __toarea(data)
{
	GameEvents.SendCustomGameEventToServer("__to_chuansong",{area:data});
}
function __toarea2(data)
{
	$('#Jxcs').style.visibility = 'collapse';
	GameEvents.SendCustomGameEventToServer("__to_chuansong",{opt:data});
}

function ShowPkPanel()
{
	if ($('#PKPanel').style.visibility=='visible')
	{
		$('#PKPanel').style.visibility='collapse';
	}
	else
	{
		$('#PKPanel').style.visibility='visible';
		UpdatePlayer();
	}
}

function _ShowTooltip(data)
{
	if (data==1)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $("#jxcs1"), $.Localize("#description_jx1"));
	}
	else if (data==2)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $("#jxcs2"), $.Localize("#description_jx2"));
	}
	else if (data==3)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $("#jxcs3"), $.Localize("#description_jx3"));
	}
	else if (data==4)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $("#slzl"), $.Localize("#description_slzl"));
	}
}

function _HideTooltip()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideTextTooltip" );
}

function UpdatePlayer()
{
	var panel = $("#PlayerList");
	var localid = Players.GetLocalPlayer()
	for ( var i = 0;i<12;i++ )
	{
		if(i==	localid)
		{
			continue;
		}
		if (Players.IsValidPlayerID(i))
		{
			var playerPanel = $.CreatePanel( "Panel", panel, "" );
			playerPanel.BLoadLayout("file://{resources}/layout/custom_game/shop/player.xml",false,false);
			playerPanel.SetPlayerId(i);
			playerPanel.SetSteamId(-1);
		}
	}
}

function ComeInFb(data)
{
	var index = data.img[4];
	$('#FbPanel').style.visibility = 'visible';
	$('#FbTitle').text = $.Localize("#"+data.img)+"  --  "+index;
}
function QuitFb(data)
{
	$('#FbPanel').style.visibility = 'collapse';
}
function FbKaiqi()
{
	var str = $('#FbTitle').text[$('#FbTitle').text.length-1];
	//$.Msg(str);
	GameEvents.SendCustomGameEventToServer("__fb_shuaguai",{index:str});
	$('#FbPanel').style.visibility = 'collapse';
}

(function(){  
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false );      //Courier controls.
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, false );      //Glyph.
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, false );     //Gold display.
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false );      //Suggested items shop panel.
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS, false );     //Hero selection Radiant and Dire player lists.
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME, false );     //Hero selection game mode name display.
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK, false );     //Hero selection clock.
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_MENU_BUTTONS, false );     //Top-left menu buttons in the HUD.
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false );      //Endgame scoreboard.    
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND, false );     //Top-left menu buttons in the HUD.
	GameUI.CustomUIConfig().pkPanel = ShowPkPanel;
    GameEvents.Subscribe("init_pk_panel", UpdatePlayer);
	GameEvents.Subscribe("__show_door", ComeInArea);
	GameEvents.Subscribe("__hide_door", QuitArea);
	GameEvents.Subscribe("fbPanel__show", ComeInFb);
	GameEvents.Subscribe("fbPanel__hide", QuitFb);
})();