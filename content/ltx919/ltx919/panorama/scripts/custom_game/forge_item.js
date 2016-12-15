
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


function StrengthenItem()
{
	GameEvents.SendCustomGameEventToServer("__strengthen__item",{});
}

function ForgeItem(data)
{
	GameEvents.SendCustomGameEventToServer("__forge__item",{opt:data});
}


(function()
{
	GameEvents.Subscribe( "__show__forge", ShowBaseUp);
})();