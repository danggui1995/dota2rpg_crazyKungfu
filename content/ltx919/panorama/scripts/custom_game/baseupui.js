function ShowBaseUp()
{
	//var unit = Players.GetLocalPlayerPortraitUnit();

	//GameEvents.SendCustomGameEventToServer("baseup_close",{});
	if($("#mid_container").style.visibility == "visible")
	{
		$("#mid_container").style.visibility = "collapse"
	}
	else
	{
		$("#mid_container").style.visibility = "visible"
	}
}

function _ShowTooltip()
{
	$.DispatchEvent( "DOTAShowTextTooltip", $("#armor_up_image"), $.Localize("#description_baseup"));
}
function __ShowTooltip()
{
	$.DispatchEvent( "DOTAShowTextTooltip", $("#up_shengwang_btn"), $.Localize("#description_baseup_shengwang"));
}

function _HideTooltip()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideTextTooltip" );
}
function __HideTooltip()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideTextTooltip" );
}

function BaseUpArmor()
{
	GameEvents.SendCustomGameEventToServer("baseup_armor",{opt:1});
}

function UpShengwang()
{
	GameEvents.SendCustomGameEventToServer("baseup_armor",{opt:2});
}

function ShowShop()
{
	GameUI.CustomUIConfig().nwCloseShop();
}

function OnUpdateLv(msg)
{
	$("#armor_lv_des").text = msg.base_lv;
}

function ShowPk()
{
	GameUI.CustomUIConfig().pkPanel();
}

function OnHuiCheng()
{
	GameEvents.SendCustomGameEventToServer("__on_hc",{});
}

function OnRefreshSw(data)
{
	$("#shengwang_label2").text = data.sw;
}
function OnRefreshNlys(data)
{
	$("#nlys_label2").text = data.nlys;
}
(function()
{
	GameUI.CustomUIConfig().baseClick = ShowBaseUp;
	//GameEvents.Subscribe( "__refresh_sw", OnRefreshSw);
	//GameEvents.Subscribe( "__refresh_nlys", OnRefreshNlys);
	Game.AddCommand( "btnjidi", ShowBaseUp, "", 0 );
	Game.AddCommand( "btnhuicheng", OnHuiCheng, "", 0 );
   	GameEvents.Subscribe( "lv_update_base", OnUpdateLv);
})();