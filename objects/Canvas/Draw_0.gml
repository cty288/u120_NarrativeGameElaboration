/// @description Insert description here
// You can write your code in this editor
draw_set_font(Font1);
draw_set_halign(fa_left);	
draw_set_valign(fa_top);
if(draw){
	
	draw_sprite(chatbox,0,positionX-10,positionY-5);
	draw_text_ext_transformed(positionX,positionY,msg,20,370,1,1,0);	
	draw=true;
} 


if(drawHint){
	draw_sprite(chatbox,0,hpositionX-10,hpositionY-5);
	draw_text_ext_transformed(hpositionX,hpositionY,hintMsg,20,370,1,1,0);
	hintTimer+=room_speed;
	if(hintTimer>=5000){
		drawHint=false;
		hintTimer=0;
	}
}

if(drawPaper){
	draw_sprite(p,0,dpositionX+120,dpositionY-130);
	drawPaperTimer++;
	if(drawPaperTimer>=3*room_speed){
		drawPaperTimer=0;
		drawPaper=false;
	}
}