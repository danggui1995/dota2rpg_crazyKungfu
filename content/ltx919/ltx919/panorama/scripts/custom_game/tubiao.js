var forgeInfo = {};
var suitInfo = {};
var showText1 = "";
var showText2 = "";
var showSuitInfo = "";

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


function SearchForgeInfo()
{
	if($("#mid_container2").style.visibility == "visible")
	{
		$("#mid_container2").style.visibility = "collapse"
	}
	else
	{
		$("#mid_container2").style.visibility = "visible"
	}
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

function StrengthenItem()
{
	var entIndex = Players.GetLocalPlayerPortraitUnit();
	if( !Entities.IsControllableByPlayer(entIndex,Players.GetLocalPlayer()) )
		return;
	GameEvents.SendCustomGameEventToServer("__strengthen__item",{unit:entIndex});

}

function ForgeItem(data)
{
	var entIndex = Players.GetLocalPlayerPortraitUnit();
	if( !Entities.IsControllableByPlayer(entIndex,Players.GetLocalPlayer()) )
		return;
	GameEvents.SendCustomGameEventToServer("__forge__item",{opt:data,unit:entIndex});
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

function _ShowTooltip_forge()
{

	$.DispatchEvent( "DOTAShowTextTooltip", $("#strengthen_item"), showText);
}
function __ShowTooltip_forge(data)
{
	if (data==1)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $("#forgeInfo1"), showText1);
	}
	else if(data==2)
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $("#forgeInfo2"), showText2);
	}
	else 
	{
		$.DispatchEvent( "DOTAShowTextTooltip", $("#suitInfo"), showSuitInfo);
	}
	
}

function _HideTooltip_forge()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideTextTooltip" );
}
function __HideTooltip_forge()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideTextTooltip" );
}


function getSuitInfo()
{
	suitInfo = CustomNetTables.GetTableValue( "Suit", "SuitInfo" );
	for ( var i in suitInfo )
	{
		showSuitInfo+=$.Localize("DOTA_Tooltip_ability_"+suitInfo[i][1])+" = ";

		for(var j in suitInfo[i][2][1])
		{
			showSuitInfo+=$.Localize("DOTA_Tooltip_ability_"+suitInfo[i][2][1][j]);
			if(j<getJsonObjLength(suitInfo[i][2][1]))
			{
				showSuitInfo+=" + ";
			}
		}
		showSuitInfo+="<Br>";
	}
}

function getItemForgeInfo()
{
	forgeInfo = CustomNetTables.GetTableValue( "Forges", "ForgesInfo" );

	for ( var i in forgeInfo[1] )
	{

		showText1+=$.Localize("DOTA_Tooltip_ability_"+forgeInfo[1][i]["1"])+" = ";
		for(var j in forgeInfo[1][i]["2"]["2"])
		{
			showText1+=$.Localize("DOTA_Tooltip_ability_"+forgeInfo[1][i]["2"]["2"][j]);
			if(j<getJsonObjLength(forgeInfo[1][i]["2"]["2"]))
			{
				showText1+=" + ";
			}
		}
		showText1+="<Br>";
	}
	for (var i in forgeInfo[2])
	{
		showText2+=$.Localize("DOTA_Tooltip_ability_"+forgeInfo[2][i]["1"])+" = ";
		for(var j in forgeInfo[2][i]["2"]["2"])
		{
			showText2+=$.Localize("DOTA_Tooltip_ability_"+forgeInfo[2][i]["2"]["2"][j]);
			if(j<getJsonObjLength(forgeInfo[2][i]["2"]["2"]))
			{
				showText2+=" + ";
			}
		}
		showText2+="<Br>";
	}
}
function getJsonObjLength(jsonObj) {
    var Length = 0;
    for (var item in jsonObj) {
        Length++;
    }
    return Length;
}

(function()
{
	getItemForgeInfo();
	getSuitInfo();
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdataTaskPanel );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdataTaskPanel );
	GameEvents.Subscribe( "__refresh_sw", OnRefreshSw);
	GameEvents.Subscribe( "__refresh_nlys", OnRefreshNlys);
	GameEvents.Subscribe( "__refresh_boshu", OnRefreshBoshu);
	GameEvents.Subscribe( "ping_at_minimap", OnPingAtMinimap);
	Game.AddCommand( "btnjidi", ShowBaseUp, "", 0 );
	Game.AddCommand( "btnhuicheng", OnHuiCheng, "", 0 );
})();