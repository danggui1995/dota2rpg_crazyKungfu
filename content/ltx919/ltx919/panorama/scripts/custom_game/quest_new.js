// $.Every = function(start, time, tick, func){
// 	var startTime = Game.Time(); 
// 	var tickRate = tick;
// 	if(tick < 1){    
// 		if(start < 0) tick--;
// 		tickRate = time / -tick;
// 	}
	
// 	var tickCount =  time/ tickRate;
	
// 	if(time < 0){
// 		tickCount = 9999999;
// 	}
// 	if(start < 0){
// 		start = 0;
// 	}else{
// 		startTime += start;
// 	}
// 	var numRan = 0;
// 	$.Schedule(start, (function(startTime, start,numRan,tickRate,tickCount){
// 		return function(){
// 			if(func()) return;
// 			var tickNew = function(){
// 				numRan++;
// 				var delay = (startTime+tickRate*numRan)-Game.Time();
// 				if((startTime+tickRate*numRan)-Game.Time() < 0){
// 					delay = 0;
// 				}
// 				$.Schedule(delay, function(){
// 					if(func()){
// 						return;
// 					};
// 					tickCount--;
// 					if(tickCount > 0) tickNew();
// 				});
// 			};
// 			tickNew();  
// 		}
// 	})(startTime, start,numRan,tickRate,tickCount)); 
// };
questHide = false;
var OnQuestHide = function(){
	if(questHide){
		$('#MiniLabel').text = " --- ";
		$('#ContainerPanel').visible = true;
		$('#QuestRoot').AddClass('QuestRoot');
		$('#QuestRoot').RemoveClass('QuestRootSmall');
		$('#backimg').style.height='100%';
		questHide = false;
	}else{
		$('#MiniLabel').text = "  +  ";
		$('#ContainerPanel').visible = false;
		$('#QuestRoot').AddClass('QuestRootSmall');
		$('#backimg').style.height='0%';
		questHide = true;
	}
};

OnQuestHide();	

var questId;

var playerId = Players.GetLocalPlayer();

var OnQuestSmallerHide = function(quest){
	var q = $('#Quest'+quest)
	if(q.GetAttributeInt('reveal', 0) == 0){
		q.SetAttributeInt('reveal', 1);
		$('#Quest'+quest+'#LineContainer').style.visibility = 'collapse';
		$('#Quest'+quest+'#Minimize#Label').text = "  +  ";
	}else{
		q.SetAttributeInt('reveal', 0);
		$('#Quest'+quest+'#LineContainer').style.visibility = 'visible';
		$('#Quest'+quest+'#Minimize#Label').text = " ― ";
		
	}
}

var organizeQuestLines = function(){

}

var flashQuest = function(questId, green){
	
} 
var i = 0
var ran = 0; 

function getIndexByName(questName,name)
{
	if($('#Quest'+questName+'#Line'+name+'#Text'))
	{
		return $('#Quest'+questName+'#Line'+name+'#Text');
	}
	// if ($('#Quest'+questName+'#Text'+))
	// {
	// 	var children = $('#Quest'+questName+'#LineContainer').children;
	// 	for(var q in children)
	// 	{
	// 		if(q.text==name || $.Localize("#"+name)==q.text
	// 		|| name==q.text.toLocaleLowerCase())
	// 		{
	// 			return q;
	// 		}
	// 	}
	// }
	
	$.Msg("error");
	return undefined;
}

var addQuest = function(name){

	if($('#Quest'+name)){
		$('#Quest'+name).RemoveAndDeleteChildren(); 
		$('#Quest'+name).DeleteAsync(0);
	}
	var quest = $.CreatePanel('Panel', $('#ContainerPanel'), 'Quest'+name);
	var questHeaderPanel = $.CreatePanel('Panel', quest, 'Quest'+name+'#Panel');
	var questHeader = $.CreatePanel('Label', questHeaderPanel, 'Quest'+name+'#Text');
	var minimizeButton = $.CreatePanel('Button', questHeaderPanel, 'Quest'+name+'#Minimize');
	var minimizeButtonLabel = $.CreatePanel('Label', minimizeButton, 'Quest'+name+'#Minimize#Label');
	
	questHeader.AddClass('QuestHeaderDefault');
	questHeaderPanel.AddClass('QuestHeaderPanel');
	//if(questId == 1){
	//	questHeader.AddClass('QuestHeaderOrange');
	//}else if(questId == 2){
	//	questHeader.AddClass('QuestHeaderGreen');
	//}else if(questId == 3){
	//	questHeader.AddClass('QuestHeaderRed');
	//}else if(questId == 5){
	//	$.Msg('1 : ' + name); 
	//	questHeader.AddClass('QuestHeaderViolet');
	//}
	questHeader.text = name;
	
	quest.AddClass('QuestPanel'); 
	
	minimizeButton.AddClass('MinierPanel');
	minimizeButton.SetPanelEvent('onactivate', (function(){OnQuestSmallerHide(name)}));
	
	minimizeButtonLabel.AddClass('MinierPanelLabel');
	minimizeButtonLabel.text = " ― ";
	
	var lineContainer = $.CreatePanel('Panel', quest, 'Quest'+name+'#LineContainer');
	lineContainer.AddClass('QuestLineContainer');
	// var tick = false;
}

var addLine = function(questName,name, text){    
	var quest = $('#Quest'+questName+'#LineContainer');

	if(!quest||quest==undefined) return ;

	var line = $.CreatePanel('Panel', quest, 'Quest'+questName+'#Line'+name);
	line.AddClass('QuestLinePanel');
	lineText = $.CreatePanel('Label', line, 'Quest'+questName+'#Line'+name+'#Text');
	lineText.html = true;
	lineText.text = " • " + text;
	
		lineText.AddClass('QuestLine');
	//if(count == 1){
	//	lineText.AddClass('QuestLineSlashed');
	//}
	return line;
}

var setLine = function(qLabel, text,questName,unitName){

	if(!qLabel||qLabel==undefined){
		addLine(questName,unitName,text);
		return;
	}

	$('#Quest'+questName+'#Line'+unitName+'#Text').html = true;
	$('#Quest'+questName+'#Line'+unitName+'#Text').text = " • " + text;
}

var removeQuest = function(dat){
	if(!dat) return;
	$('#Quest'+dat.title).RemoveAndDeleteChildren();
	$('#Quest'+dat.title).DeleteAsync(0);
}

var removeLine = function(dat){
	if(!dat) return;
	$('#Quest'+dat.questName+'#Line'+dat.unitName).RemoveAndDeleteChildren();
	$('#Quest'+dat.questName+'#Line'+dat.unitName).DeleteAsync(0);
}


var onQuestCreate = function(dat){
	if(!dat) return;
	if(dat.player != playerId) return;
	addQuest(dat.title);
}

var onQuestCompleteLine = function(dat){
	if(!dat) return;
	if(dat.player != playerId) return;
	if(!dat.fade){
		removeLine(dat.id,dat.lineIndex);
	}else{
		$.Schedule(2, function(){onQuestCompleteLine(dat.id,dat.lineIndex,!dat.fade)});
	}
}

var onQuestSetLine = function(data){
	if(!data) return;
	if(data.player != playerId) return;
	if (data.unitName!=undefined)
	{
		var qLabel = getIndexByName(data.title,data.unitName);
		var __str = $.Localize(data.unitName) + data.str;
		setLine(qLabel,__str,data.title,data.unitName);
	}
}

var onQuestRemove = function(dat){
	if(!dat) return;
	$('#Quest'+dat.title).RemoveAndDeleteChildren();
	$('#Quest'+dat.title).DeleteAsync(0);
}

var onQuestFlag = function(dat){
	if(!dat) return;
	if(dat.player != playerId) return;
	if(dat.flag == "pendingComplete"){
		$('#Quest'+dat.id+'#Text').AddClass('QuestHeaderGreen');
	}else if(dat.flag == "completeWithFade"){
		removeQuest({id:dat.id});
	}else if(dat.flag == "complete"){
		removeQuest(dat.id);
	}else if(dat.flag == "pendingFailure"){
		removeQuest(dat.id);
	}else if(dat.flag == "clearLines"){
		if($('#Quest'+dat.id+'#LineContainer')) $('#Quest'+dat.id+'#LineContainer').RemoveAndDeleteChildren();
	}else if(dat.flag == "clearAll"){
		$('#ContainerPanel').RemoveAndDeleteChildren();
	}else if(dat.flag == "setRed"){
		$('#Quest'+dat.id+'#Text').AddClass('QuestHeaderRed');
	}	
	
}

var onQuestShow = function(table, key, data){
	if(!data) return;
	if(data.player != playerId) return;
	if(data.show === null || data.show == 1){
		$('#QuestRoot').visible = true;
	}else{
		$('#QuestRoot').visible = false;
	}
	OnQuestHide();
}

var onQuestRefresh = function(data)
{
	if(!dat) return;
	if(dat.player != playerId) return;
	if (dat.op!=undefined)
	{
		var __id = getIndexByName(dat.title);
		var __str = $.Localize(dat.unitName) + dat.str;
		setLine(__id,dat.op,__str);
	}
	else
	{
		var __id = getIndexByName(dat.title);
		var __str = $.Localize(dat.unitName) + dat.str;
		setLine(__id,0,__str);
	}
}

function ReSubscribe()
{
	GameEvents.Subscribe("quest_create", onQuestCreate);
	GameEvents.Subscribe("quest_set_line", onQuestSetLine);
	GameEvents.Subscribe("quest_complete_line", onQuestCompleteLine);
	GameEvents.Subscribe("quest_set_sub_line", onQuestSetSubLine);
	GameEvents.Subscribe("quest_complete_sub_line", onQuestCompleteSubLine);
	GameEvents.Subscribe("quest_remove", onQuestRemove);
	GameEvents.Subscribe("quest_refresh",onQuestRefresh);
	GameEvents.Subscribe("quest_flag", onQuestFlag);
	GameEvents.Subscribe( "quest_update", onGetDataFromSever);
	CustomNetTables.SubscribeNetTableListener( "quest", onQuestShow );
	Game.AddCommand( "btnquest", Btn_quest, "", 0 );
}

function Btn_quest()
{
	GameEvents.SendCustomGameEventToServer("transportPara",{});
}

$.Msg('INIT - Quest UI');
(function(){  
	GameEvents.Subscribe("quest_create", onQuestCreate);
	GameEvents.Subscribe("quest_set_line", onQuestSetLine);
	GameEvents.Subscribe("quest_complete_line", onQuestCompleteLine);
	GameEvents.Subscribe("quest_remove", onQuestRemove);
	GameEvents.Subscribe("quest_flag", onQuestFlag);
	CustomNetTables.SubscribeNetTableListener( "quest", onQuestShow );
	Game.AddCommand( "btnquest", OnQuestHide, "", 0 );
	$.Msg('Quest Init. NULL : ' + $('#ContainerPanel'));
})();
