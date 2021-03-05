/// @description Insert description here
// You can write your code in this editor
if(!Player.indoorDoorInteraction){
	if(keyboard_check_pressed(ord("R"))){
		audio_play_sound(finish,1,false);
		room_goto(1);

	}
}

if(Player.faucetTurnedOn){
	if(!audio_is_playing(bathroom_faucet_1_01)){
		audio_play_sound(bathroom_faucet_1_01,1,true);
	}
}else{
	audio_stop_sound(bathroom_faucet_1_01);
}