"use strict";
var m_data = {};
var m_data2 = {};
var m_Isinrange = true;
function ChangeState(data)
{
	if (data.opt == 1)
	{
		m_Isinrange = true;
	}
	else
	{
		m_Isinrange = false;
	}
}

function GetIsInRange()
{
	return true;
}

function LoadEquipmentShop () {
	m_data = CustomNetTables.GetTableValue( "Shops", "ShopsInfo" );
	m_data2 = CustomNetTables.GetTableValue( "Compose", "ComposeInfo" );
	var firstColPanel = $( "#ShopItemListCol1" );
	var secondColPanel = $( "#ShopItemListCol2" );
	var thirdColPanel = $( "#ShopItemListCol3" );
	if ( !firstColPanel || !secondColPanel || !thirdColPanel )
		return;

	firstColPanel.RemoveAndDeleteChildren();
	secondColPanel.RemoveAndDeleteChildren();
	thirdColPanel.RemoveAndDeleteChildren();
	for ( var i in m_data )
	{
		var parentPanel = firstColPanel; 
		if (m_data[i].type ==4 )
		{
			continue;
		}
		else if (m_data[i].type==2)
		{
			parentPanel = secondColPanel; 
		}
		else if(m_data[i].type==3)
		{
			parentPanel = thirdColPanel; 
		}
		var itemPanel = $.CreatePanel( "Panel", parentPanel, "" );
		itemPanel.BLoadLayout("file://{resources}/layout/custom_game/shop/shop_items.xml",false,false);
		itemPanel.SetItem(m_data[i],setItemInfo);
	}
}

function CloseShop()
{
	if ($('#Content').style.visibility == 'visible')
	{
		$('#Content').SetHasClass("ComeIn",true)
		$.Schedule(0.25,__RemoveClass);
	}
	else
	{
		$('#Content').SetHasClass("ComeOut",true)
		$('#Content').style.visibility = 'visible';
		$.Schedule(0.25,__AddClass);
	}
}

function __AddClass()
{
	$('#Content').SetHasClass("ComeOut",false);
	
}

function __RemoveClass()
{
	$('#Content').SetHasClass("ComeIn",false);
	$('#Content').style.visibility = 'collapse';
}

function setItemInfo ( data ) {
	$("#ItemImage").itemname = data.name;
};

function ShopVisibleInit () {
	$('#Content').style.visibility = 'collapse';
}

function ShowCompose(data)
{
	var panel1 = $( "#composeList1" );
	var panel2 = $( "#composeList2" );
	var panel3 = $( "#composeList3" );
	if ( !panel3||!panel2||!panel1 )
		return;
	panel3.RemoveAndDeleteChildren();
	panel2.RemoveAndDeleteChildren();
	panel1.RemoveAndDeleteChildren();
	var itemPanel1 = $.CreatePanel( "Panel", panel2, "" );
	itemPanel1.BLoadLayout("file://{resources}/layout/custom_game/shop/shop_items.xml",false,false);
	itemPanel1.SetItem(data,setItemInfo);
	for ( var i in m_data2 )
	{
		for(var _i in m_data2[i].need)
		{
			var temp = {};
			if (m_data2[i].need[_i] == data.name)
			{
				for ( var ii in m_data )
				{
					if (m_data[ii].name == m_data2[i].name)
					{
						temp.name = m_data2[i].name;
						temp.__p = m_data[ii].__p;
						temp.gold = m_data[ii].gold;
						var itemPanel = $.CreatePanel( "Panel", panel1, "" );
						itemPanel.BLoadLayout("file://{resources}/layout/custom_game/shop/shop_items.xml",false,false);
						itemPanel.SetItem(temp,setItemInfo);
					}
				}
			}
		}
		if (m_data2[i].name==data.name)
		{
			for(var _i in m_data2[i].need)
			{
				var temp = {};
				for ( var ii in m_data )
				{
					//$.Msg(m_data[ii].name+"   "+ m_data2[i].need[_i])
					if (m_data[ii].name == m_data2[i].need[_i])
					{
						temp.name = m_data2[i].need[_i];
						temp.__p = m_data[ii].__p;
						temp.gold = m_data[ii].gold;
						var itemPanel = $.CreatePanel( "Panel", panel3, "" );
						itemPanel.BLoadLayout("file://{resources}/layout/custom_game/shop/shop_items.xml",false,false);
						itemPanel.SetItem(temp,setItemInfo);
					}
				}
			}
		}
		//ItemList[data[i].name] = data[i];
	}
}

function TransportBl()
{
	var temp ={};
	temp[1] = m_data;
	temp[2] = m_data2;
	return temp;
}

(function () {
	GameUI.CustomUIConfig().loadCompose = ShowCompose;
	GameUI.CustomUIConfig().getItemInfo = TransportBl;
	ShopVisibleInit();
	LoadEquipmentShop();
	GameUI.CustomUIConfig().nwCloseShop = CloseShop;
	GameUI.CustomUIConfig().getInRange = GetIsInRange;
	GameEvents.Subscribe( "change_state_shop", ChangeState);
})();