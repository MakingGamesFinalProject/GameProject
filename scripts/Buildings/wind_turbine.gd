extends CharacterBody2D

enum available_states {WORKING, TO_REPAIR, REPAIRING}

var counter_players_detected = 0
var task_manager_ref = null
var house_ref = null
var current_status = available_states.TO_REPAIR

@export var time_to_repair_in_seconds = 5
@export var time_to_complete_check_batteries_task_in_seconds = 3

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	set_task_manager_ref()
	set_house_ref()

func _process(_delta):
	check_task_completion()
	
func check_task_completion():
	check_for_fixing_task()

func check_for_batteries_task():
	if current_status != available_states.WORKING:
		return
	
	var a_user_is_interacting = Input.is_action_pressed("interaction_p1") || Input.is_action_pressed("interaction_p2")
	if a_user_is_interacting && counter_players_detected > 0:
		var time_manager = WaitUtil.new()
		time_manager.wait(time_to_repair_in_seconds, self, "_on_energy_task_callback")

func _on_energy_task_callback():
	task_manager_ref.set_task_as_done(3)

func check_for_fixing_task():
	var a_user_is_interacting = Input.is_action_pressed("interaction_p1") || Input.is_action_pressed("interaction_p2")
	if counter_players_detected > 0:
		if a_user_is_interacting && current_status == available_states.TO_REPAIR:
			repair_self()

func repair_self():
	current_status = available_states.REPAIRING
	var time_manager = WaitUtil.new()
	time_manager.wait(time_to_repair_in_seconds, self, "_on_repair_complete_callback")
	
func _on_repair_complete_callback():
	current_status = available_states.WORKING
	task_manager_ref.set_task_as_done(2)
	state_machine.travel("Idle")

func set_task_manager_ref():
	task_manager_ref = get_tree().get_first_node_in_group("task_manager")
	assert(task_manager_ref != null, "Task manager not found")

func set_house_ref():
	house_ref = get_tree().get_first_node_in_group("house")
	assert(house_ref != null, "House reference not found")

func _on_detection_area_body_entered(body):
	if is_player(body):
		counter_players_detected += 1

func _on_detection_area_body_exited(body):
	if is_player(body):
		counter_players_detected -= 1

func is_player(body):
	return body.is_in_group("players")
	
func break_turbine():
	state_machine.travel("Broken")
