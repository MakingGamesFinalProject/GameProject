extends Node2D
signal gift_box_picked_up
signal gift_arrived_at_destination

var game_manager_ref : Node = null;
var task_manager_ref: Node = null;
var was_picked_up = false

func _ready():
	task_manager_ref = get_tree().get_first_node_in_group("task_manager")
	game_manager_ref = get_tree().get_first_node_in_group("game_manager")
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("players"):
		pick_up_item(body)
		task_manager_ref.assign_task(0)
		

func pick_up_item(body): 
	var is_player_with_keyboard = body.get("is_player_with_keyboard")
	# Player 2 is playing with the keyboard
	#if is_player_with_keyboard:
	#	gift_box_picked_up.emit	(2)
	#else:
	#	gift_box_picked_up.emit(1)	
	was_picked_up = true
	self.hide()
