extends Camera2D

var min_x = 0
var max_x = 1540
#1 for player1, 2 for player2
@export var camera_number = 1; 

func _process(delta):
	var camera_position = global_position
	var player_position = get_player().position
	var new_camera_pos_x = clamp(player_position.x, min_x, max_x)
	camera_position.x = new_camera_pos_x
	global_position = camera_position
	print(new_camera_pos_x)
	
	
func get_player():
	return get_tree().get_nodes_in_group("players")[camera_number - 1] 
