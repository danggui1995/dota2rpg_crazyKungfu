
function btn_ac()
{
	var temp_t = {};
	if($('#QuestTitle').text[0]=='-')
	{
		//$.Msg("come in primary accept");
		temp_t['id'] = Players.GetLocalPlayer();
		temp_t['task_type'] = 1;
		GameEvents.SendCustomGameEventToServer("ListennerOnAcceptTask",temp_t);
	}
	else if ($('#QuestTitle').text[0]=='o' || $('#QuestTitle').text[0]=='O')
	{
		//$.Msg("come in other accept");
		temp_t['id'] = Players.GetLocalPlayer();
		temp_t['task_type'] = 2;
		var task_index = "";
		if ($('#QuestTitle').text.substring($('#QuestTitle').text.length-2,$('#QuestTitle').text.length-1)=='r'
			||$('#QuestTitle').text.substring($('#QuestTitle').text.length-2,$('#QuestTitle').text.length-1)=='R')
		{
			task_index = $('#QuestTitle').text[$('#QuestTitle').text.length-1];
		}
		else
		{
			task_index = $('#QuestTitle').text.substring($('#QuestTitle').text.length-2,$('#QuestTitle').text.length);
		}
		temp_t['task_index'] = task_index;
		GameEvents.SendCustomGameEventToServer("ListennerOnAcceptTask",temp_t);
	}
	QuitArea();	
}

function btn_sub()
{
	//$.Msg("come in the sub");
	var temp_t = {};
	if($('#QuestTitle').text[0]=='-')
	{
		//$.Msg("come in the primary");
		temp_t['id'] = Players.GetLocalPlayer();
		temp_t['task_type'] = 1;
		GameEvents.SendCustomGameEventToServer("ListennerOnSubmitTask",temp_t);
	}
	else if ($('#QuestTitle').text[0]=='o'||$('#QuestTitle').text[0]=='O')
	{
		//$.Msg("come in the other");
		temp_t['id'] = Players.GetLocalPlayer();
		temp_t['task_type'] = 2;
		var task_index = "";
		if ($('#QuestTitle').text.substring($('#QuestTitle').text.length-2,$('#QuestTitle').text.length-1)=='r'||$('#QuestTitle').text.substring($('#QuestTitle').text.length-2,$('#QuestTitle').text.length-1)=='R')
		{
			task_index = $('#QuestTitle').text[$('#QuestTitle').text.length-1];
		}
		else
		{
			task_index = $('#QuestTitle').text.substring($('#QuestTitle').text.length-2,$('#QuestTitle').text.length);
		}
		temp_t['task_index'] = task_index;
		//$.Msg(task_index);
		GameEvents.SendCustomGameEventToServer("ListennerOnSubmitTask",temp_t);
	}
	QuitArea();
}

function QuitArea()
{
	if($('#TaskShowRoot').style.visibility == 'visible')
	{
		$('#TaskShowRoot').style.visibility = 'collapse';
	}
}

function ComeInArea(data)
{
	$('#l_sub_btn').text = $.Localize("#tijiao");
	$('#l_ac_btn').text = $.Localize("#jieshou");
	var task_index = "";
	//$.Msg(data.title);
	//$.Msg("aaaa");
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
		$('#QuestTitle').text = "--" + $.Localize("#"+data.title);
	}
	else
	{
		$('#QuestTitle').text = "o-" + $.Localize("#"+data.title) + "--"+task_index;
	}

	$('#Description').text = $.Localize(data.description);

	var str = data.award;
	var str_array = str.split(',');
	str="";
	for(var i = 0;i<str_array.length;i++)
	{
		if(str_array[i][0]=="e")
		{
			str+=$.Localize("#award_exp")+"   ";
			str+=str_array[i].substring(1,str_array[i].length);
			str+=";\n";
		}
		else if (str_array[i][0]=="g")
		{
			str+=$.Localize("#award_gold")+"   ";
			str+=str_array[i].substring(1,str_array[i].length);
			str+=";\n";
		}
		else if (str_array[i][0]=="i")
		{
			var __str = str_array[i].substring(1,str_array[i].length);
			var ___str = __str.split('|');
			str+=$.Localize("#award_item")+" : ";
			for(var __i = 0;__i<___str.length;__i++)
			{
				str+=$.Localize("#DOTA_Tooltip_ability_"+___str[__i]);
				if (__i<___str.length-1)
				{
					str+="   "+$.Localize("#or")+"  ";
				}
			}
			str+=";\n";
		}
		else if (str_array[i][0]=="s")
		{
			var __str = str_array[i].substring(1,str_array[i].length);
			str+=$.Localize("#award_sw")+" : "+__str;
			str+=";\n";
		}
	}
	if (data.awardAbility!=undefined)
	{
		var ___index_array = data.awardAbility.split(',');
		var ___index = ___index_array[2];
		str += $.Localize("#suiji") + ___index +  $.Localize("#jiejineng");
	}
	$('#Description_award').text = str;
	$('#TaskShowRoot').style.visibility = 'visible';
	var item_image_name = "file://{images}/items/"+data.image_address+".png";
	$( "#Dest" ).SetImage( item_image_name );
}

function InitAll()
{
	if($('#TaskShowRoot').style.visibility == 'collapse')
	{
		$('#TaskShowRoot').style.visibility = 'visible';
	}
	else
	{
		$('#TaskShowRoot').style.visibility = 'collapse';
	}
}

function FbComeInArea(data)
{
	var fb_type = data.fb_type;
	$('#l_sub_btn').text = $.Localize("#jinru");
	$('#l_cancle_btn').text = $.Localize("#quxiao");
	$('#l_ac_btn').text = $.Localize("#kaiqi");
	if(fb_type==1)
	{
		$('#QuestTitle').text = $.Localize("#youanzhisen");
		$('#Description').text = $.Localize("#youanzhisen_desc");
		$('#TaskShowRoot').style.visibility = 'visible';
		var item_image_name = "file://{images}/items/bottle.png"
		$( "#Dest" ).SetImage( item_image_name );
	}
	else if(fb_type==2)
	{
		$('#QuestTitle').text = $.Localize("#taohuayuan");
		$('#Description').text = $.Localize("#taohuayuan_desc");
		$('#TaskShowRoot').style.visibility = 'visible';
		var item_image_name = "file://{images}/items/bottle.png"
		$( "#Dest" ).SetImage( item_image_name );
	}
	else if(fb_type==3)
	{
		$('#QuestTitle').text = $.Localize("#fuben3");
		$('#Description').text = $.Localize("#fuben3_desc");
		$('#TaskShowRoot').style.visibility = 'visible';
		var item_image_name = "file://{images}/items/bottle.png"
		$( "#Dest" ).SetImage( item_image_name );
	}
	else if(fb_type==4)
	{
		$('#QuestTitle').text = $.Localize("#fuben4");
		$('#Description').text = $.Localize("#fuben4_desc");
		$('#TaskShowRoot').style.visibility = 'visible';
		var item_image_name = "file://{images}/items/bottle.png"
		$( "#Dest" ).SetImage( item_image_name );
	}
}

(function(){  
	GameEvents.Subscribe("quest_show", ComeInArea);
	GameEvents.Subscribe("quest_hide", QuitArea);
})();