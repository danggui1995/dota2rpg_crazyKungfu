

function ShowBaseUp()
{
	GameUI.CustomUIConfig().baseClick();
}

function ShowShop()
{
	GameUI.CustomUIConfig().nwCloseShop();
}

function ShowPk()
{
	GameUI.CustomUIConfig().pkPanel();
}

function OnHuiCheng()
{
	GameEvents.SendCustomGameEventToServer("__on_hc",{});
}

function showToolTip(text,type){
	if (type==1) {
		$.DispatchEvent( "DOTAShowTextTooltip", $('#btn_showbase_des'), $.Localize(text));
	}else if (type==2) {
		$.DispatchEvent( "DOTAShowTextTooltip", $('#btn_hc_des'), $.Localize(text));
	}else {
		$.DispatchEvent( "DOTAShowTextTooltip", $('#btn_hc'), $.Localize(text));
	}
	
}

function hideTootip(){
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideTextTooltip" );
}


function SearchForgeInfo()
{
	GameUI.CustomUIConfig().showForgeInfo();
}

function OnRefreshSw(data)
{
	$("#shengwang_label2").text = data.sw;
}
function OnTingGuai(data)
{
	if (Players.GetGold( Game.GetLocalPlayerID() )<3500)
	{
		var temp = {};
		temp['text'] = "#jinbibuzu";
		temp['duration'] = 1;
		temp['style'] = {color:"red"};
		GameUI.CustomUIConfig().errorMessage(temp)
		Game.EmitSound( "warning.moregold" );
		return;
	}
	var config = CustomNetTables.GetTableValue( "Config", "ConfigInfo" );
	//$.Msg(config);
	var m_cooldown = config[1]["tingguai"];
	/*for(var i in config)
	{
		var kk = config[i];
		for(var j in kk)
		{
			m_cooldown = kk[j];
		}
	}*/
	//$.Msg(m_cooldown);
	if ( m_cooldown == 0 || m_cooldown=="0" )
	{
		var playerName = Players.GetPlayerName( Game.GetLocalPlayerID() )
		GameEvents.SendCustomGameEventToServer("__on_tg",{playerName:playerName});
	}
	else
	{
		var temp = {};
		temp['text'] = "#incooldown";
		temp['duration'] = 1;
		temp['style'] = {color:"red"};
		GameUI.CustomUIConfig().errorMessage(temp)
		Game.EmitSound( "General.Cancel" );
	}
}
function OnRefreshNlys(data)
{
	$("#nlys_label2").text = data.nlys;
}
function OnPingAtMinimap(data)
{
	var __pos = data.pos;
	if (__pos!=undefined)
	{
		GameUI.PingMinimapAtLocation( __pos );
	}
}
function _ShowTooltip(data)
{
	$.DispatchEvent( "DOTAShowTextTooltip", $("#btn_tg_des"), $.Localize("#description_tingguai"));
}

function _HideTooltip()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideTextTooltip" );
}
function OnRefreshBoshu(data)
{
	$('#boshu_label2').text = data.data;
}




function UpdataTaskPanel()
{
	
	var localId = Players.GetLocalPlayer()

	var hero = Players.GetPlayerHeroEntityIndex( localId )

	var pos1 = Entities.GetAbsOrigin( hero )

	var queryUnit = Players.GetLocalPlayerPortraitUnit();

	var pos2 = Entities.GetAbsOrigin(queryUnit)

	//$.Msg(pos1.x);
}


(function()
{
	// GameEvents.Subscribe( "dota_player_update_selected_unit", UpdataTaskPanel );
	// GameEvents.Subscribe( "dota_player_update_query_unit", UpdataTaskPanel );
	GameEvents.Subscribe( "__refresh_sw", OnRefreshSw);
	GameEvents.Subscribe( "__refresh_nlys", OnRefreshNlys);
	GameEvents.Subscribe( "__refresh_boshu", OnRefreshBoshu);
	GameEvents.Subscribe( "ping_at_minimap", OnPingAtMinimap);
	Game.AddCommand( "btnforge", SearchForgeInfo, "", 0 );
	Game.AddCommand( "btnjidi", ShowBaseUp, "", 0 );
	Game.AddCommand( "btnhuicheng", OnHuiCheng, "", 0 );
})();