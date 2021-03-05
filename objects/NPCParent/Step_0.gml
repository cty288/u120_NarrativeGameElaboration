/// @description Insert description here
// You can write your code in this editor
if(distance_to_object(player)<=50){
	//show_debug_message(distance_to_object(player));
	if(player.y-y>=0){
		
		player.depth=0;
	}else{
		player.depth=350;
		show_debug_message(player.depth);
	}
}
