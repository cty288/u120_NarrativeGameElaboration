/// @description Insert description here
// You can write your code in this editor
player=instance_find(Player,0);
msg="";
draw=false;
positionX=0;
positionY=0;
depth=0;
function SetChatMessage(text){
	positionX=player.x-160;
	positionY=player.y-120;
	//show_debug_message("adwda");
	msg=text;
	draw=true;
	alarm[0]=8*room_speed;
}


hpositionX=player.x-160;
hpositionY=player.y-120;
hintMsg="";
drawHint=false;
hintTimer=0;
function SetHint(text){
	hpositionX=player.x-160;
	hpositionY=player.y-120;
	//show_debug_message("adwda");
	hintMsg=text;
	drawHint=true;
}

drawPaper=false;
drawPaperTimer=0;
p=pointer_null;
dpositionX=player.x;
dpositionY=player.y;

function DrawPaper(paper){
	dpositionX=player.x-160;
	dpositionY=player.y-120;
	drawPaper=true;
	p=paper;	
}