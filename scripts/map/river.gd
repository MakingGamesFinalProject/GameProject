extends StaticBody2D

# Is a player situated close to the river?
var water_collectable_p1 := false
var water_collectable_p2 := false
var counter_player_detected = 0

var is_collectable = true
var COLLECTABILITY_TIMER = 20.0

func _process(_delta):
	# Currently, the interaction button is F for p1 and action_down joystick for player2
	if Input.is_action_just_pressed("interaction_p1") and water_collectable_p1 and is_collectable:
		ResourceManager.increase_water(5)
		var player_array = get_tree().get_nodes_in_group("players")
		player_array[0].player_interaction()
		start_collection_timer()
		check_task_completion()
		
	if Input.is_action_just_pressed("interaction_p2") and water_collectable_p2 and is_collectable:
		ResourceManager.increase_water(5)
		var player_array = get_tree().get_nodes_in_group("players")
		player_array[1].player_interaction()
		start_collection_timer()
		check_task_completion()
		
	
		
func start_collection_timer():
	is_collectable = false
	await get_tree().create_timer(COLLECTABILITY_TIMER).timeout
	is_collectable = true
	
func player_has_my_task():
	var task_manager_ref = get_tree().get_first_node_in_group("task_manager")
	assert(task_manager_ref != null, "Task manager not found")
	var task_id = task_manager_ref.get_task_by_name("Collect Water").uid
	var npc = get_tree().get_first_node_in_group("npc")
	
	for npc_task_id in npc.npc_task_ids:
		if npc_task_id == task_id:
			return true
	return false

func check_task_completion():
	# This function needs to be here but it is supposed to 
	# call the correct "check tasks" depending on the building
	# check_for_fixing_task() # decided we don't need because of time constraints
	if player_has_my_task():
		check_for_retrieve_water_task()

func check_for_retrieve_water_task():
	var task_manager_ref = get_tree().get_first_node_in_group("task_manager")
	assert(task_manager_ref != null, "Task manager not found")
	var task_id = task_manager_ref.get_task_by_name("Collect Water").uid
	if task_manager_ref.get_current_task(1) == task_id or task_manager_ref.get_current_task(2) == task_id:
		if (Input.is_action_pressed("interaction_p1") and water_collectable_p1):
			var player_array = get_tree().get_nodes_in_group("players")
			player_array[0].player_interaction()
			var time_manager = WaitUtil.new()
			time_manager.wait(2.0, self, "_on_create_scrap_task_callback")
		elif (Input.is_action_pressed("interaction_p2") and water_collectable_p2):
			var player_array = get_tree().get_nodes_in_group("players")
			player_array[1].player_interaction()
			var time_manager = WaitUtil.new()
			time_manager.wait(2.0, self, "_on_retrieve_water_task_callback")

func _on_retrieve_water_task_callback():
	var task_manager_ref = get_tree().get_first_node_in_group("task_manager")
	assert(task_manager_ref != null, "Task manager not found")
	var task_id = task_manager_ref.get_task_by_name("Collect Water").uid
	task_manager_ref.set_task_as_done(task_id)

func _on_player_detection_body_entered(body):
	if body.is_in_group("players"):
		body.show_helper_button("F")
		counter_player_detected += 1
	if body.name == "Player":
			water_collectable_p1 = true
			
	if body.name == "Player2":
		water_collectable_p2 = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("players"):
		body.hide_helper_button()
		counter_player_detected -= 1
	if body.name == "Player":
		water_collectable_p1 = false
			
	if body.name == "Player2":
		water_collectable_p2 = false
