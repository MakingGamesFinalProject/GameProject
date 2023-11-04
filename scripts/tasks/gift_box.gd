extends Node2D
signal gift_box_picked_up

var game_manager_ref : Node = null;

func _ready():
	game_manager_ref = get_tree().get_first_node_in_group("game_manager")

func _on_area_2d_body_entered(body):
	if body.is_in_group("players"):
		var is_player_with_keyboard = body.get("is_player_with_keyboard")
		# Player 2 is playing with the keyboard
		if is_player_with_keyboard:
			gift_box_picked_up.emit	(2)
		else:
			gift_box_picked_up.emit(1)	
		queue_free()
		
