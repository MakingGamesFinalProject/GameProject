extends VBoxContainer

var player_number = 0

func _ready():
	set_player_number()
	set_text_of_prev_button()
	
func set_player_number():
	var canvas_layer_ref = get_parent()
	if canvas_layer_ref != null:
		player_number = canvas_layer_ref.player_number	
	else:
		assert(false, "UI not found")
	
func set_text_of_prev_button():
	if player_number == 2:
		$PaginationContainer/Next.text = "Next (R2)"
		$PaginationContainer/Previous.text = "Previous (L2)"
		$HBoxContainer/LoadTasksButton.text = "Tasks (L1)"
		$HBoxContainer/LoadCompletedTasksButton.text = "Completed tasks (R1)"
	
