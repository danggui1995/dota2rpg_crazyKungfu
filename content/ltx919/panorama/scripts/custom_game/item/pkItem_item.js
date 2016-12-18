"use strict";

var m_Item = -1;
var m_PackIndex = -1;
var m_QueryUnit = -1;


function UpdateItem (data) {
	var heroIndex = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
	var backpackIndex = $.GetContextPanel().m_PackIndex;
	if(data[backpackIndex+1]!=undefined)
	{
		var itemIndex = data[backpackIndex+1].itemIndex;
		var itemName = Abilities.GetAbilityName(itemIndex);
		$.Msg(itemName);
		$("#ItemImage").itemname = itemName;
		m_Item = itemIndex;
		m_QueryUnit = heroIndex;
	}
	else
	{
		$("#ItemImage").itemname = "";
		m_Item = -1;
	}
}

function RemoveItem(data)
{
	m_Item = -1;
	m_QueryUnit = -1;
	$("#ItemImage").itemname = "";
}

function ItemShowTooltip()
{
	if ( m_Item == -1 )
		return;
	
	var itemName = Abilities.GetAbilityName( m_Item );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, m_QueryUnit );
}

function ItemHideTooltip()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideTextTooltip" );
}

function SetPackIndex ( packIndex ) {
	m_PackIndex = packIndex;

	$.GetContextPanel().m_PackIndex = m_PackIndex;

}

function OnDragEnter( a, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;

	if ( draggedItem === null || draggedItem == m_Item )
		return true;
	$.GetContextPanel().AddClass( "potential_drop_target" );
	return true;
}

function OnDragDrop( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;

	if ( draggedItem === null )
		return true;
	var heroIndex = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
	if ( draggedItem == m_Item )
		return true;
	
	GameEvents.SendCustomGameEventToServer( "slot_to_backpack_pk", {slot:draggedPanel.m_ItemSlot } );

	return true;
}

function OnDragLeave( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	if ( draggedItem === null || draggedItem == m_Item )
		return false;

	$.GetContextPanel().RemoveClass( "potential_drop_target" );
	return true;
}

function OnDragEnd( panelId, draggedPanel )
{

	if ( !draggedPanel.m_DragCompleted )
	{
		var entIndex = Players.GetLocalPlayerPortraitUnit();

		if( !Entities.IsControllableByPlayer(entIndex,Players.GetLocalPlayer()) )
		{
			draggedPanel.DeleteAsync( 0 );
			$.GetContextPanel().RemoveClass( "dragging_from" );
			return true;
		}
	}

	$.GetContextPanel().RemoveClass( "dragging_from" );
	return true;
}

(function () {
	$.GetContextPanel().SetPackIndex = SetPackIndex;
	$.GetContextPanel().m_PackIndex = m_PackIndex;

	$.RegisterEventHandler( 'DragEnter', $.GetContextPanel(), OnDragEnter );
	$.RegisterEventHandler( 'DragDrop', $.GetContextPanel(), OnDragDrop );
	$.RegisterEventHandler( 'DragLeave', $.GetContextPanel(), OnDragLeave );
	$.RegisterEventHandler( 'DragEnd', $.GetContextPanel(), OnDragEnd );
	GameUI.CustomUIConfig().pkCancle = RemoveItem;
	GameEvents.Subscribe( "addItem__pk", UpdateItem );
	GameEvents.Subscribe( "removeItem__pk", RemoveItem );
})();