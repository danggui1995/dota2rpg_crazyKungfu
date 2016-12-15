"use strict";

function DismissMenu()
{
	$.DispatchEvent( "DismissAllContextMenus" )
}

function OnSell()
{
	Items.LocalPlayerSellItem( $.GetContextPanel().Item );
	DismissMenu();
}

function OnDisassemble()
{
	Items.LocalPlayerDisassembleItem( $.GetContextPanel().Item );
	DismissMenu();
}

function OnAlert()
{
	Items.LocalPlayerItemAlertAllies( $.GetContextPanel().Item );
	DismissMenu();
}
