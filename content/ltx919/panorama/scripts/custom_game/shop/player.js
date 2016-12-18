"use strict";

var userName = "";
var userId = -1;
var steamId = -1;
function SetPlayerId (data) {
	userId = data;
	$('#__PlayerID').text = Players.GetPlayerName( userId );
}
function SetSteamId(data)
{
	steamId = data;
}

function OnSelectPk()
{
	GameEvents.SendCustomGameEventToServer("__start_pk",{id:userId});
	GameUI.CustomUIConfig().pkPanel();
}

(function () {
	$.GetContextPanel().SetPlayerId = SetPlayerId;
	$.GetContextPanel().SetSteamId = SetSteamId;
})();

