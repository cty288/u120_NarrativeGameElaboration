/// @description Insert description here
// You can write your code in this editor
hspeed=0;
vspeed=0;
image_speed=0;


if(!place_meeting(x,y,Bush)&&distance_to_object(NPCParent)>=50){
	depth=0;
}

if(!indoorDoorInteraction && !search){
	if(keyboard_check(ord("W"))){
	PlayWalkingSound();
	facing=0;
	ChangeSprite(0);
	MoveOrCollideY(Colliders,-player_moving_speed);
	image_speed=1;
}
if(keyboard_check(ord("S"))){
	PlayWalkingSound();
	facing=1;
	ChangeSprite(1);
	MoveOrCollideY(Colliders,player_moving_speed);
	image_speed=1;
}
if(keyboard_check(ord("A"))){
	PlayWalkingSound();
	facing=3;
	ChangeSprite(3);
	MoveOrCollideX(Colliders,-player_moving_speed);
	image_speed=1;
}
if(keyboard_check(ord("D"))){
	PlayWalkingSound();
	facing=2;
	ChangeSprite(2);
	MoveOrCollideX(Colliders,player_moving_speed);
	image_speed=1;
}
}


Interaction();

if(hspeed==0&&vspeed==0){
	isMoving=false;
}else{
	isMoving=true;
}
if(distance_to_object(Exit)<=20){
	//win
	audio_play_sound(finish,1,false);
	room_goto_previous();
	
}






