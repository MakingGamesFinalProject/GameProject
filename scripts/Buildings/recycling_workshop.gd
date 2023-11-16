extends CharacterBody2D

var counter_players_detected = 0
var task_manager_ref = null

@export var time_to_recycle_trash_in_seconds = 3

func _ready():
	task_manager_ref = get_tree().get_first_node_in_group("task_manager")

func _process(delta):
	check_for_recycle_task_completion()

func check_for_recycle_task_completion():
	var a_user_is_interacting = Input.is_action_pressed("interaction_p1") || Input.is_action_pressed("interaction_p2")
	if a_user_is_interacting && counter_players_detected > 0:
		var time_manager = WaitUtil.new()
		time_manager.wait(time_to_recycle_trash_in_seconds, self, "_on_time_out_recycle_task")
	
func _on_time_out_recycle_task():
	task_manager_ref.set_task_as_done(5)

func _on_detection_area_body_entered(body):
	if is_player(body):
		counter_players_detected += 1

func _on_detection_area_body_exited(body):
	if is_player(body) && counter_players_detected > 0:
		counter_players_detected -= 1

func is_player(body):
	return body.is_in_group("players")
