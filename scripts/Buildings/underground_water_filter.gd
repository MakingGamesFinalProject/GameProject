extends CharacterBody2D

enum available_states {WORKING, TO_REPAIR, REPAIRING}

var current_state = available_states.TO_REPAIR
var task_manager = null
var player_counter_on_building = 0

@export var time_to_repair_in_seconds = 5

func _ready():
	set_task_manager()

func set_task_manager():
	task_manager = get_tree().get_nodes_in_group("task_manager")[0]
	assert(task_manager != null, "Task manager not found")
	
func _process(delta):
	if player_counter_on_building > 0:
		handle_interaction()	
	check_for_batteries_task()

func check_for_batteries_task():
	if current_state != available_states.WORKING:
		return
	# to complete this task the other player must be on the house
	var a_user_is_interacting = Input.is_action_pressed("interaction_p1") || Input.is_action_pressed("interaction_p2")
	if a_user_is_interacting && player_counter_on_building > 0:
		var time_manager = WaitUtil.new()
		time_manager.wait(time_to_repair_in_seconds, self, "_on_check_for_batteries_callback")
	
func _on_check_for_batteries_callback():
	task_manager.set_task_as_done(4)
	
func handle_interaction():
	if Input.is_action_pressed("interaction_p1") || Input.is_action_pressed("interaction_p2"):
		if current_state == available_states.TO_REPAIR:
			repair_self()		

func repair_self():
	current_state = available_states.REPAIRING
	var time_manager = WaitUtil.new()
	time_manager.wait(time_to_repair_in_seconds, self, "_on_repair_complete_callback")
	
func _on_repair_complete_callback():
	current_state = available_states.WORKING
	if task_manager != null:
		task_manager.set_task_as_done(0)


func _on_player_detector_body_entered(body):
	if is_player(body):
		player_counter_on_building += 1
		

func _on_player_detector_body_exited(body):
	if is_player(body):
		player_counter_on_building -= 1

func is_player(body):
	return body.is_in_group("players")

