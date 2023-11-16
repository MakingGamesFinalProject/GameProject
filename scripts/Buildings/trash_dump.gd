extends CharacterBody2D

var player_detection_counter = 0
var river_ref = null
var task_manager_ref = null

func _ready():
	set_river_ref()
	set_task_manager_ref()

func _process(delta):
	if player_detection_counter > 0:
		check_for_task_completion()
		
func check_for_task_completion():
	if river_ref.counter_player_detected > 0:
		task_manager_ref.set_task_as_done(1)
			
func set_task_manager_ref():
	task_manager_ref = get_tree().get_first_node_in_group("task_manager")
	assert(task_manager_ref != null, "Task manager was not found")
		
	
func set_river_ref():
	river_ref = get_tree().get_first_node_in_group("river")
	assert(river_ref != null, "River ref is null")

func _on_detection_area_body_entered(body):
	if body.is_in_group("players"):
		player_detection_counter += 1

func _on_detection_area_body_exited(body):
	if body.is_in_group("players"):
		player_detection_counter -= 1
