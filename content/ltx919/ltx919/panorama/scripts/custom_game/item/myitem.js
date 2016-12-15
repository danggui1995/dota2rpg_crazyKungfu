"use strict";

var ColumnCount = 2;
var EquipData = [];

function CloseOrOpenBackpack ( arg ) {

	if( !$.GetContextPanel().enabled )
	{
		$.GetContextPanel().enabled = true;
	}
	else if( $.GetContextPanel().enabled )
	{
		$.GetContextPanel().enabled = false;
	}
	return $.GetContextPanel().enabled;
}

function HideTijiaoPanel(data)
{
	//$.Msg("come into hide");
	$("#TijiaoPanel").style.visibility = 'collapse';
}

function ShowTijiaoPanel(data)
{
	//$.Msg(data);
	$('#ForButtonYesText').text = $.Localize("#tijiao");
	$('#ForButtonNoText').text = $.Localize("#quxiao");
	var task_index = "";
	//$.Msg("title"+data.title);
	if (data.title.substring(data.title.length-2,data.title.length-1)=='z')
	{
		task_index = data.title[data.title.length-1];
	}
	else
	{
		task_index = data.title.substring(data.title.length-2,data.title.length);
	}
	if (data.title.indexOf("primary")!=-1)
	{
		$('#Title').text = "--" + $.Localize("#"+data.title);
	}
	else
	{
		$('#Title').text = "o-" + $.Localize("#"+data.title) + "--"+task_index;
	}

	var str = data.aimItem;
	var str2 = data.specialItem;
	var str_array = str.split(',');
	str="";
	for(var i = 0;i<str_array.length;i++)
	{
		str+=$.Localize("#qintijiao")+"   ";
		str+=$.Localize("#DOTA_Tooltip_ability_"+str_array[i].substring(0,str_array[i].length));
		str+=";\n";
	}
	if (str2!=undefined)
	{
		var str_array2 = str2.split(',');
		str2 = "";
		for(var i = 0;i<str_array2.length;i++)
		{
			str2+=$.Localize("#DOTA_Tooltip_ability_"+str_array2[i].substring(0,str_array2[i].length));
			str2+=";\n";
		}
		$('#description__text').text = str + "("+$.Localize("#putongjiangli")+")\n"+ $.Localize("#or") +"\n"+ str2+"("+$.Localize("#ewaijiangli")+")";
	}
	else
	{
		$('#description__text').text = str + "("+$.Localize("#putongjiangli")+")\n";
	}
	$("#TijiaoPanel").style.visibility = 'visible';
}



var LastDraggedPanel = null;
function OnDragDrop (panelId, draggedPanel) {
	LastDraggedPanel = draggedPanel;
	if(LastDraggedPanel)LastDraggedPanel.m_DragCompleted = true;
	return true
}

function OnDragEnter (panelId, draggedPanel) {
	LastDraggedPanel = draggedPanel;
	if(LastDraggedPanel)LastDraggedPanel.m_DragCompleted = true;
	return true
}

function OnDragLeave (panelId, draggedPanel) {
	LastDraggedPanel = draggedPanel;
	if(LastDraggedPanel)LastDraggedPanel.m_DragCompleted = true;
	return true
}

function OnLeavePanel () {
	try
	{
		if(LastDraggedPanel)LastDraggedPanel.m_DragCompleted = false;
	}
	catch(e)
	{

	}
}

GameUI.CustomUIConfig().hsjCloseOrOpenBackpack = CloseOrOpenBackpack;

GameUI.CustomUIConfig().hsjIsOpenBackpack = function () {
	return $.GetContextPanel().enabled;
};

function CreateInventoryPanels()
{
	var firstRowPanel = $( "#inventory_row_1" );
	var secondRowPanel = $( "#inventory_row_2" );
	var thirdRowPanel = $( "#inventory_row_3" );
	if ( !firstRowPanel || !secondRowPanel || !thirdRowPanel )
		return;
	firstRowPanel.RemoveAndDeleteChildren();
	secondRowPanel.RemoveAndDeleteChildren();
	thirdRowPanel.RemoveAndDeleteChildren();
	var m_InventoryPanels = []

	for ( var i = 0; i < 4; ++i )
	{
		var parentPanel = firstRowPanel;
		if ( i >= 2&&i<4 )
		{
			parentPanel = secondRowPanel;
		}
		else if ( i >= 4 )
		{
			parentPanel = thirdRowPanel;
		}

		var inventoryPanel = $.CreatePanel( "Panel", parentPanel, "" );
		inventoryPanel.BLoadLayout( "file://{resources}/layout/custom_game/item/inventory_item2.xml", false, false );
		inventoryPanel.SetPackIndex( i );

		m_InventoryPanels.push( inventoryPanel );
	}
}

function OnForButtonYes(data)
{
	//$.Msg("come in button yes");
	var temp_t = {};
	if($('#Title').text[0]=='-')
	{
		temp_t['id'] = Players.GetLocalPlayer();
		temp_t['task_type'] = 1;
		GameEvents.SendCustomGameEventToServer("ListennerOnSubmitTask",temp_t);
	}
	else if ($('#Title').text[0]=='o')
	{
		temp_t['id'] = Players.GetLocalPlayer();
		temp_t['task_type'] = 2;
		var task_index = "";
		if ($('#Title').text.substring($('#Title').text.length-2,$('#Title').text.length-1)=='r')
		{
			task_index = $('#Title').text[$('#Title').text.length-1];
		}
		else
		{
			task_index = $('#Title').text.substring($('#Title').text.length-2,$('#Title').text.length);
		}
		temp_t['task_index'] = task_index;
		GameEvents.SendCustomGameEventToServer("ListennerOnSubmitTask",temp_t);
	}
	HideTijiaoPanel();
}

function OnForButtonNo(data)
{
	if ($("#ForButtonNoText").text=="duanzao" || $("#ForButtonNoText").text==$.Localize("#duanzao"))
	{
		GameEvents.SendCustomGameEventToServer( "duanzao_onclick", { hero:heroIndex,opt:0} );
	}
	else if ($("#ForButtonNoText").text=="tijiaowupin" || $("#ForButtonNoText").text==$.Localize("#tijiaowupin"))
	{
		GameEvents.SendCustomGameEventToServer( "tijiaowupin_onclick", { hero:heroIndex,opt:0} );
	}
	HideTijiaoPanel();
}

(function () {
	CreateInventoryPanels();
	$.RegisterEventHandler( 'DragDrop', $.GetContextPanel(), OnDragDrop );
	$.RegisterEventHandler( 'DragEnter', $.GetContextPanel(), OnDragEnter );
	$.RegisterEventHandler( 'DragLeave', $.GetContextPanel(), OnDragLeave );
	GameEvents.Subscribe( "tijiaowupin__show", ShowTijiaoPanel );
	GameEvents.Subscribe( "tijiaowupin__hide", HideTijiaoPanel );
})();