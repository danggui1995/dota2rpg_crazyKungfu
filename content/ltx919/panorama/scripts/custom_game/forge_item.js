
var forgeInfo = {};
var suitInfo = {};
var showText1 = "";
var showText2 = "";
var showSuitInfo = "";

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

function ForgeItem(data)
{
	var entIndex = Players.GetLocalPlayerPortraitUnit();
	if( !Entities.IsControllableByPlayer(entIndex,Players.GetLocalPlayer()) )
		return;
	GameEvents.SendCustomGameEventToServer("__forge__item",{opt:data,unit:entIndex});
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

function StrengthenItem()
{
	var entIndex = Players.GetLocalPlayerPortraitUnit();
	if( !Entities.IsControllableByPlayer(entIndex,Players.GetLocalPlayer()) )
		return;
	GameEvents.SendCustomGameEventToServer("__strengthen__item",{unit:entIndex});

}

(function()
{
	getItemForgeInfo();
	getSuitInfo();
	GameUI.CustomUIConfig().showForgeInfo = ShowBaseUp;
})();