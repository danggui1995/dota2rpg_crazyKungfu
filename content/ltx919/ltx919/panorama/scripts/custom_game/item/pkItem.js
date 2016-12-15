"use strict";

var ColumnCount = 2;

function HideTijiaoPanel(data)
{
	$("#TijiaoPanel").style.visibility = 'collapse';
}

function ShowTijiaoPanel(data)
{
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
		inventoryPanel.BLoadLayout( "file://{resources}/layout/custom_game/item/pkItem_item.xml", false, false );
		inventoryPanel.SetPackIndex( i );

		m_InventoryPanels.push( inventoryPanel );
	}
}

function OnForButtonYes(data)
{
	GameEvents.SendCustomGameEventToServer( "pkItem__sure", {} );
	$('#SureText').text = "";
}

function OnForButtonNo(data)
{
	GameEvents.SendCustomGameEventToServer( "pkItem__cancle", {} );
	GameUI.CustomUIConfig().pkCancle();
	HideTijiaoPanel();
	$('#SureText').text = "";
}

function RefreshPkState()
{
	$('#SureText').text = $.Localize("#duifangok");
}

(function () {
	CreateInventoryPanels();
	$.RegisterEventHandler( 'DragDrop', $.GetContextPanel(), OnDragDrop );
	$.RegisterEventHandler( 'DragEnter', $.GetContextPanel(), OnDragEnter );
	$.RegisterEventHandler( 'DragLeave', $.GetContextPanel(), OnDragLeave );
	GameEvents.Subscribe( "pkItem__hide", HideTijiaoPanel );
	GameEvents.Subscribe( "pkItem__show", ShowTijiaoPanel );
	GameEvents.Subscribe( "refresh__pk_state", RefreshPkState );
})();