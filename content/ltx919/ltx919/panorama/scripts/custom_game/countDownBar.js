"use strict"


function startCountDown(){
	var title = data.title | "no title";
	var time = data.time | 80;

	$('#countDownPanel').style.visibility == "visible" ;
	updateCountDownBar(title,time);
}

function updateCountDownBar(title,time,percent){
	if (!Game.IsGamePaused()){
		var countDownBar = $('#countDownBar');
		countDownBar.style.width = percent * ( time-1/time );
		if (percent && percent<=0) {
			interruptCountDown();
		}
	}
	$.Schedule(1,updateCountDownBar,title,time,percent);
}

function interruptCountDown(){
	$.CancelScheduled(updateCountDownBar);
}

function addCdb(line,time) {
	var cdb = $(line);

	if(!cdb||cdb==undefined) return ;

	var barBg = $.CreatePanel('Panel', cdb, line+'barBg');
	var bar = $.CreatePanel('Panel',barBg,line+'bar');

	barBg.AddClass('countDownBarBg');
	bar.AddClass('countDownBar');
}

function addLine(cdbid,subid,text){    
	var cdb = $('#cdb'+cdbid+'#LineContainer');

	if(!cdb||cdb==undefined) return ;

	var line = $.CreatePanel('Panel', cdb, 'cdb'+cdbid+'#Line'+subid);
	line.AddClass('cdbLinePanel');
	lineText = $.CreatePanel('Label', line, 'cdb'+cdbid+'#Line'+subid+'#Text');
	lineText.html = true;
	if (text) {
		lineText.text = " • " + text;
	}
	
	lineText.AddClass('cdbLine');
	
	return line;
}

function addcdb (id,title){

	if($('#cdb'+id)){
		$('#cdb'+id).RemoveAndDeleteChildren();
		$('#cdb'+id).DeleteAsync(0);
	}
	var cdb = $.CreatePanel('Panel', $('#ContainerPanel'), 'cdb'+id);
	var cdbTitle = $.CreatePanel('Label', cdb, 'cdb'+id+"title");
	var cdbBarBg = $.CreatePanel('Panel', cdb, 'cdb'+id+'barBg');
	var cdbBar = $.CreatePanel('Panel', cdbBarBg, 'cdb'+id+'bar');
		
	
	cdbTitle.text = title;
	
	cdb.AddClass('cdbPanel');
	
	var lineContainer = $.CreatePanel('Panel', cdb, 'cdb'+id+'#LineContainer');
	lineContainer.AddClass('cdbLineContainer');
	
}


(function () {
  GameEvents.Subscribe( "startCountDown", startCountDown );
})();


