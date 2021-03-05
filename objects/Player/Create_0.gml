//I declared all variables and functions here

facing=0; //0:forward, 1:backward, 2:right, 3:left
player_moving_speed=2;
canvas=instance_find(Canvas,0);


//Colliders is an array of all colliders to check
Colliders[0]=ColliderObj;
Colliders[1]=NPCParent;
Colliders[2]=Door;
Colliders[3]=InterorWall;
Colliders[4]=MomDoor;
Colliders[5]=FurnitureParent;

//walking sounds
walkSound[0]=footsteps_shoe_wood_walk_01;
walkSound[1]=footsteps_shoe_wood_walk_02;
walkSound[2]=footsteps_shoe_wood_walk_03;
walkSound[3]=footsteps_shoe_wood_walk_04;
walkSound[4]=footsteps_shoe_wood_walk_05;

//bookshelf searching sounds
bookshelfSearchSound[0]=Turn_Page_of_Paper_Back_Book_01;
bookshelfSearchSound[1]=Turn_Page_of_Paper_Back_Book_03;


interactableObjs[0]=Npc_1;
interactableObjs[1]=Npc_2;
interactableObjs[2]=MomDoor;
interactableObjs[3]=Door;


global.hasFlashlight=false;
global.haskey=false;
chatPage=1;
isMoving=false;

search=false;
searchTimer=5*room_speed;

hasPiece1=false;
hasPiece2=false;
hasPiece3=false;
hasPiece4=false;

failed=false;

//set initial player appearance
sprite_index=player_forward;
image_index=1;
image_speed=0;
indoorDoorInteraction=false;
faucetTurnedOn=false;
function SetChatMessage(text){
	canvas.SetChatMessage(text);
}


//The main logic of the game: Interaction with each object in the game
function Interaction(){
if(distance_to_object(Npc_1)<=20){
	if(keyboard_check_pressed(vk_space)){
		audio_play_sound(show_msg,1,false);
		SetChatMessage("Mom: You are NOT allowed to go out to play now! You've been playing all day today and haven't done ANY homework!! DO YOUR HOMEWORK!!!");

	}
}else if(distance_to_object(Npc_2)<=20){
	if(hasPiece1 && hasPiece2 && hasPiece3){
		if(!failed){
			if(!hasPiece4){
				if(!indoorDoorInteraction){
			if(keyboard_check_pressed(vk_space)){
				if(chatPage==1){
					audio_play_sound(show_msg,1,false);
					SetChatMessage("Hey dad, I've found three pieces, but I can't find the remainings! >>");
					chatPage++;
				}else if(chatPage==2){
					audio_play_sound(show_msg,1,false);
					SetChatMessage("Dad: Well... Actually I have the last piece... >>");
					chatPage++;
				}else if(chatPage==3){
					audio_play_sound(show_msg,1,false);
					SetChatMessage("Could you give me the last piece? Pleaseeeeeee~ >>");
					chatPage++;
				}else if(chatPage==4){
					audio_play_sound(show_msg,1,false);
					SetChatMessage("Dad: hmmm... I can, but you must answer my question >>");
					chatPage++;
				}else if(chatPage==5){
					audio_play_sound(show_msg,1,false);
					indoorDoorInteraction=true;
					keyboard_string="";
				}
				}
				}	
			}else{
				//has piece 4
				if(keyboard_check_pressed(vk_space)){
					audio_play_sound(show_msg,1,false);
					if(chatPage==1){
						SetChatMessage("This is the complete passcode >>");
						chatPage++;
					}else{
						if(!audio_is_playing(Turn_Page_of_Paper_Back_Book_01)){
							audio_play_sound(Turn_Page_of_Paper_Back_Book_01,1,false);
						}
						canvas.DrawPaper(pwd_complete);
					}
				}
			}
		}else{
			//failed
			if(keyboard_check_pressed(vk_space)){
				audio_play_sound(show_msg,1,false);
				if(chatPage==1){
					SetChatMessage("As a penalty, I will not give you that piece! >>");
					chatPage++;
				}else if(chatPage==2){
					SetChatMessage("(Hint: Because you lied, your father will not give you the last piece, but you can still infer"+ 
					" the password based on the three pieces you have. Press space to view all your pieces >> )");
					chatPage++;
				}else if(chatPage>=3){
					if(!audio_is_playing(Turn_Page_of_Paper_Back_Book_01)){
						audio_play_sound(Turn_Page_of_Paper_Back_Book_01,1,false);
					}
					canvas.DrawPaper(pwd_incomplete);
					canvas.draw=false;
				}
				
			}
		}
			
		if(indoorDoorInteraction){
			//text input
			SetChatMessage("Dad: Have you finished your homework? \n"+"your answer: "+keyboard_string);
			
			if(keyboard_check_pressed(vk_enter)){
				audio_play_sound(show_msg,1,false);
				if(string_lower(keyboard_string)=="yes"){
					failed=true;
					chatPage=2;
					SetChatMessage("Your mom told me that you haven't. You shouldn't lie to me, son. I will not give you the last piece anymore! >>");
				}else if(string_lower(keyboard_string)=="no"){
					hasPiece4=true;
					SetChatMessage("Great! You are honest and you've passed my test! Take the last piece and joint them together!  (press space to see the complete passcode)>>");
					chatPage=2;
				}else{
					SetChatMessage("I didn't get your point, son.");
				}
				indoorDoorInteraction=false;
			}
		}
	}else{
		if(keyboard_check_pressed(vk_space)){
		if(chatPage==1){
			audio_play_sound(show_msg,1,false);
			SetChatMessage("Dad: Hey son, if you really want to go out to play, I will give you a hint: the key is hidden somewhere in your mom's room. Try to find the passcode to enter into her room!        >>");
			chatPage++;
		}else if(chatPage==2){
			audio_play_sound(show_msg,1,false);
			SetChatMessage("(Hint: the passcode is hidden somewhere in this house, press space to interact with objects in the house!)");
			chatPage=1;
		}
		
	}
	}
	
}else if(distance_to_object(MomDoor)<=20){
	var success=false;
	if(!global.hasRoomKey){
		if(keyboard_check_pressed(vk_space)&&!indoorDoorInteraction){
			audio_play_sound(show_msg,1,false);
			SetChatMessage("");
			indoorDoorInteraction=true;
			keyboard_string="";
		}
		//allow the player to input the passcode of the door
		if(indoorDoorInteraction){
			//text input
			canvas.msg="Please input the passcode to open the door. Press enter to verify, or press esc to exit: \n"+keyboard_string;
			if(keyboard_check_pressed(vk_enter)){
				if(string_lower(keyboard_string)=="i love my son"){
					global.hasRoomKey=true;
					with(MomDoor){
						//TODO: play success sound
						instance_destroy();
						success=true;
					}
					canvas.SetHint("Correct Password!");
				}else{
					if(!audio_is_playing(sfx_sounds_error3)){
						audio_play_sound(sfx_sounds_error3,1,false);
					}
	
					keyboard_string="";
					success=false;
					canvas.msg="Wrong Password!";
				}
				indoorDoorInteraction=false;
				//canvas.draw=false;
			}
			if(keyboard_check_pressed(vk_escape)){
				indoorDoorInteraction=false;
				canvas.draw=false;
			}
		}
	}
}else if(distance_to_object(Door)<=20){
	if(keyboard_check_pressed(vk_space)){
		audio_play_sound(door_open,1,false);
		if(!global.haskey){
			SetChatMessage("I want to GO OUT!!!! What's the passcode?");
		}else{
			with(Door){
				if(sprite_index!=door_up){
					sprite_index=door_up;
					x-=32;	
					audio_play_sound(finish,1,false);
				}
				other.SetChatMessage("I opened it!! Now I can go out to play!!! (Game Ends. Thanks for playing and enjoy exploring the map! Press R to restart the game.");
			}
			
		}
		
	}
	
}else if(distance_to_object(Bookshelf)<=20 || distance_to_object(Bookshelf2)<=20){
	if(keyboard_check_pressed(vk_space)){
		if(!hasPiece1){
			if(chatPage==1){
				audio_play_sound(show_msg,1,false);
				chatPage++;
				SetChatMessage("This is my father's bookself, is the passcode hidden in the book? (press space to search)");
			}else if(!search){
				//start searching
				search=true;
				searchTimer=5*room_speed;
			}
			
		}else{
			if(chatPage==1){
				audio_play_sound(show_msg,1,false);
				chatPage++;
				SetChatMessage("This is the piece I found >>");
			}else{
				canvas.draw=false;
				if(!audio_is_playing(Turn_Page_of_Paper_Back_Book_01)){
					audio_play_sound(Turn_Page_of_Paper_Back_Book_01,1,false);
				}
				canvas.DrawPaper(pwd_1);
			}
			
		}	
	}
	
	if(search){
		searchTimer--;
		SetChatMessage("Searching....Please wait for "+string(round(searchTimer/room_speed))+" seconds.");
		if(!audio_is_playing(bookshelfSearchSound[0]) && !audio_is_playing(bookshelfSearchSound[1])){
			var index=irandom_range(0,1);
			audio_play_sound(bookshelfSearchSound[index],1,false);
		}
		
		if(searchTimer<=0){
			searchTimer=0;
			search=false;
			result=GetBookshelfSearchResult();
			if(result){
				//TODO: play a sound here
				SetChatMessage("I find a piece of paper... (Press space to see what you found)");
				hasPiece1=true;
				chatPage=2;
			}else{
				
				if(!audio_is_playing(sfx_sounds_error3)){
					audio_play_sound(sfx_sounds_error3,1,false);
				}
				SetChatMessage("I didn't find anything this time, maybe try again? (Hint: Press space to try again. The more time you try, the more likely you will find the passcode!)");
			}
		}
	}
}else if(distance_to_object(Flashlight)<=20 && !global.hasFlashlight){
	if(keyboard_check_pressed(vk_space)){
		audio_play_sound(key_get,1,false);
		canvas.SetHint("I found a flashlight under the TV set! It might be helpful somewhere");
		global.hasFlashlight=true;
		Flashlight.visible=false;
	
	}
}else if(distance_to_object(Bed)<=20){
	if(keyboard_check_pressed(vk_space)){
		audio_play_sound(show_msg,1,false);
		if(!hasPiece2){
			if(chatPage==1){
			SetChatMessage("This is my bed. Is is possible that I can find some clues under my bed?  (press space to search) >>");
			chatPage++;
		}else if(chatPage==2){
			if(!global.hasFlashlight){
				SetChatMessage("It's too dark under my bed. I can't see anything...");
			}else{
				SetChatMessage("Now I have the flashlight. Do I need to turn it on? (press space to turn on your flishlight) >>");
				chatPage++;
			}
		}else if(chatPage==3){
			audio_play_sound(switch29,1,false);
			if(!search){
				search=true;
				searchTimer=3*room_speed;
			}
			}
		}else{
			if(chatPage==1){
				SetChatMessage("This is the piece that I found under my bed >>");
				chatPage++;
			}else{
				if(!audio_is_playing(Turn_Page_of_Paper_Back_Book_01)){
					audio_play_sound(Turn_Page_of_Paper_Back_Book_01,1,false);
				}
				canvas.draw=false;
				canvas.DrawPaper(pwd_2);
			}
		}
		
	}
	
	if(search){
		searchTimer--;
		SetChatMessage("Searching....Please wait for "+string(round(searchTimer/room_speed))+" seconds.");
		if(!audio_is_playing(Household_Furniture_Rummage_Through_Drawers_Short_01) && searchTimer<=room_speed*2.5){
			audio_play_sound(Household_Furniture_Rummage_Through_Drawers_Short_01,1,false);
		}
		if(searchTimer<=0){
			searchTimer=0;
			search=false;
			audio_stop_sound(Household_Furniture_Rummage_Through_Drawers_Short_01);
			//TODO: play a sound here
			SetChatMessage("I find a piece of paper... (Press space to see what you found)");
			hasPiece2=true;
			chatPage=2;
		}
	}
}else if(distance_to_object(Sofa)<=20){
	if(keyboard_check_pressed(vk_space)){
		if(chatPage==1){
			audio_play_sound(show_msg,1,false);
			SetChatMessage("Mom loves to lie on the sofa and watch TV. Is it possible to find something under the sofa?  >>>");
			chatPage++;
		}else if(chatPage==2){
			if(!search){
				search=true;
				searchTimer=3*room_speed;
			}
		}
	}
	if(search){
		searchTimer--;
		SetChatMessage("Searching....Please wait for "+string(round(searchTimer/room_speed))+" seconds.");
		if(!audio_is_playing(Household_Furniture_Rummage_Through_Drawers_Short_01)){
			audio_play_sound(Household_Furniture_Rummage_Through_Drawers_Short_01,1,false);
		}
		if(searchTimer<=0){
			searchTimer=0;
			search=false;
			audio_stop_sound(Household_Furniture_Rummage_Through_Drawers_Short_01);
			audio_play_sound(show_msg,1,false);
			SetChatMessage("Seems there's nothing under the sofa.");
			chatPage=1;
		}
	}
}else if(distance_to_object(CarpetLiv)<=20){
	if(!hasPiece3){
		if(keyboard_check_pressed(vk_space)&&!indoorDoorInteraction){
		indoorDoorInteraction=true;
		audio_play_sound(show_msg,1,false);
		keyboard_string="";
	}
	if(indoorDoorInteraction){
		SetChatMessage("The carpet in the living room seems normal, what should I do with it? (input an action, or press esc to exit) (Hint: what's under the carpet?) >> \n"+
			keyboard_string);
		if(keyboard_check_pressed(vk_enter)){
				audio_play_sound(Household_Chair_Rolling_On_Carpet_11,1,false);
				canvas.draw=false;
				if(string_lower(keyboard_string)=="flip"||string_lower(keyboard_string)=="open"||string_lower(keyboard_string)=="lift"
				||string_lower(keyboard_string)=="search"||string_lower(keyboard_string)=="find"||string_lower(keyboard_string)=="reverse"
				||string_lower(keyboard_string)=="turn"){
					audio_play_sound(show_msg,1,false);
					SetChatMessage("You opened the carpet, and found something under it >>>");
					hasPiece3=true;
					chatPage=2;
				}else if(string_lower(keyboard_string)=="walk"||string_lower(keyboard_string)=="jump"){
					if(!audio_is_playing(sfx_sounds_error3)){
						audio_play_sound(sfx_sounds_error3,1,false);
					}
					canvas.SetHint("You walked onto the carpet, but nothing happened.");
				}else{
					if(!audio_is_playing(sfx_sounds_error3)){
						audio_play_sound(sfx_sounds_error3,1,false);
					}
					canvas.SetHint("Nothing happened");
				}
				indoorDoorInteraction=false;
				//canvas.draw=false;
			}
		if(keyboard_check_pressed(vk_escape)){
			indoorDoorInteraction=false;
			canvas.draw=false;
		}
		}
	}else{
		if(keyboard_check_pressed(vk_space)){
			if(chatPage==1){
				chatPage++;
				audio_play_sound(show_msg,1,false);
				SetChatMessage("This is the piece that I found under the carpet >>");
			}else{
				if(!audio_is_playing(Turn_Page_of_Paper_Back_Book_01)){
					audio_play_sound(Turn_Page_of_Paper_Back_Book_01,1,false);
				}
				canvas.draw=false;
				canvas.DrawPaper(pwd_3);
			}
			
		}
	
	}
}else if(distance_to_object(Key)<=10){
	if(keyboard_check_pressed(vk_space)){
		audio_play_sound(key_get,1,false);
		global.haskey=true;
		with(Key){
			instance_destroy();
		}
		canvas.SetHint("I found the key!!");
	}
}else if(distance_to_object(Toliet)<=20){
	if(keyboard_check_pressed(vk_space)){
		//TODO: play a sound here
		//audio_play_sound(door_open,1,false);
		if(!search){
				search=true;
				searchTimer=3*room_speed;
		}
	}
	
	if(search){
		searchTimer--;
		if(!audio_is_playing(Liquid_Water_Toilet_Flushing_In_Public_Bathroom_01_)){
			audio_play_sound(Liquid_Water_Toilet_Flushing_In_Public_Bathroom_01_,1,false);
		}
		SetChatMessage("You are using the toilet...\n Please wait for "+string(round(searchTimer/room_speed))+" seconds.");
		if(searchTimer<=0){
			search=false;
			searchTimer=0;
			canvas.draw=false;
		}
	}
		
}else if(distance_to_object(Bathtub)<=20){
	if(keyboard_check_pressed(vk_space)){
		audio_play_sound(show_msg,1,false);
		SetChatMessage("It's not the time for a bath yet, I usually do that at night");
	}
}else if(distance_to_object(Sink)<=20){
	if(keyboard_check_pressed(vk_space)){
		audio_play_sound(show_msg,1,false);
		if(faucetTurnedOn){
			SetChatMessage("*You turned off the tap");
			faucetTurnedOn=false;
		}else{
			SetChatMessage("*You turned on the tap");
			faucetTurnedOn=true;
		}
		
	}
}else{
	//if(distance_to_object(Npc_1)>=50 &&distance_to_object(Npc_2)>=50 
	var temp=false;
	for(var i=0; i<array_length(interactableObjs); i++){
		if(distance_to_object(interactableObjs[i])<=50){
			temp=true;
		}
	}
	
	if(!temp){
		canvas.draw=false;
		canvas.drawPaper=false;
		indoorDoorInteraction=false;
		chatPage=1;
	}
	
}
}

function MoveOrCollideX(obj_to_check,velocityX){
	var meet=false;
	for(var i=0; i<array_length(Colliders);i++){
		if(place_meeting(x+velocityX,y,obj_to_check[i])){
			meet=true;
		}
	}
	if(!meet){
		hspeed=velocityX;
	}else{
		hspeed=0;
	}
}

function MoveOrCollideY(obj_to_check,velocityY){
	var meet=false;
	for(var i=0; i<array_length(Colliders);i++){
		if(place_meeting(x,y+velocityY,obj_to_check[i])){
			meet=true;
		}
	}
	if(!meet){
		vspeed=velocityY;
	}else{
		vspeed=0;
	}
}

function PlayWalkingSound(){
	if(isMoving){
		audioIsPlaying=false;
		for(var i=0; i<5;i++){
			if(audio_is_playing(walkSound[i])){
				audioIsPlaying=true;
			}
		}
	
		if(!audioIsPlaying){
			if(!place_meeting(x,y,Carpet2)&&!place_meeting(x,y,CarpetLiv)&&!place_meeting(x,y,CarpetLiv2)){
				if(place_meeting(x,y,Floor)){
					var index=irandom_range(0,4);
					audio_play_sound(walkSound[index],1,false);
				}
				
			}
		}
	}
	
}


function ChangeSprite(facingIndex){
	if(facingIndex==0){
		sprite_index=player_forward;
	}else if(facingIndex==1){
		sprite_index=player_backward;
	}else if(facingIndex==2){
		sprite_index=player_right;
	}else{
		sprite_index=player_left;
	}
}

function GetBookshelfSearchResult(){
	r=irandom_range(0,100);
	return r<=25;
}
