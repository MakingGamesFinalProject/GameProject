extends StaticBody2D

# path to the npc_building_task JSON
var npc_building_task_json_path := "res://data/npc_building_task.json"

var player1_is_close := false
var player2_is_close := false

var what_npc_am_i := "Huggy"

# id's of what dialog to use. ref. notifications JSON
var dialog_startup_id := -1
var dialog_before_task_id := -1
var dialog_after_task_id := -1
var dialog_parting_phrase_id := -1
var dialog_not_done_yet_id := -1

# what tasks this npc assigns
var npc_task_ids = []

var dialog_open := false
var startup_dialog_is_open := true
var after_task_dialog_read := false

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	reset_npc()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dialog_node = get_tree().get_first_node_in_group("Notification")
	var player_array = get_tree().get_nodes_in_group("players")
	
	if not dialog_node.name == "notification":
		print("ERROR: notification node not found")
		return
		
	if not player_array[0].name == "Player":
		print("ERROR: Palyer1 not found")
		return
		
	if not player_array[1].name == "Player2":
		print("ERROR: Player2 not found")
		return
	
	if (Input.is_action_just_pressed("interaction_p1") and player1_is_close) \
		or Input.is_action_just_pressed("interaction_p2") and player2_is_close:
		process_dialog_logic(
			dialog_node, 
			player_array
		)
	elif (Input.is_action_just_pressed("interaction_p1") or Input.is_action_just_pressed("interaction_p2")) and dialog_open:
		reset_dialog_state(dialog_node, player_array)

func process_dialog_logic(dialog_node, player_array):
	var task_complete = check_tasks()

	if not task_complete:
		close_notification_exclamation()
		show_dialog(dialog_before_task_id)
	elif task_complete and not after_task_dialog_read:
		close_notification_exclamation()
		show_dialog(dialog_after_task_id)
		after_task_dialog_read = true
	else:
		show_dialog(dialog_parting_phrase_id)

func show_dialog(dialog_id):
	var dialog_node = get_tree().get_first_node_in_group("Notification")
	var player_array = get_tree().get_nodes_in_group("players")
	
	if not dialog_node.name == "notification":
		print("ERROR: notification node not found")
		return
		
	if not player_array[0].name == "Player":
		print("ERROR: Palyer1 not found")
		return
		
	if not player_array[1].name == "Player2":
		print("ERROR: Player2 not found")
		return
	
	player_array[0].player_freeze()
	player_array[1].player_freeze()
	
	dialog_open = true
	dialog_node.show_dialog(dialog_id)

func reset_dialog_state(dialog_node, player_array):
	dialog_open = false
	dialog_node.hide_dialog()
	player_array[0].player_unfreeze()
	player_array[1].player_unfreeze()

func show_correct_npc():
	if what_npc_am_i == "Huggy":
		$Huggy.visible = true
		$Greasy.visible = false
		state_machine.travel("idle_Huggy")
	elif what_npc_am_i == "Greasy":
		$Greasy.visible = true
		$Huggy.visible = false
		state_machine.travel("idle_Greasy")
		
func reset_npc():
	## TODO: MAKE NOTIFICATION SYMBOLE AND MAKE IT APPEAR
	get_json_data()
	set_tasks()
	show_correct_npc()
	show_dialog(dialog_startup_id)

func get_json_data():
	# Get JSON data and save in a variable
	var file = FileAccess.open(npc_building_task_json_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var json_data = json.data["relationships"]
		if typeof(json_data) == TYPE_ARRAY:
			for relationship in json_data:
				if relationship["npc"] == what_npc_am_i:
					dialog_startup_id = int(relationship["dialogs"]["startup"])
					dialog_before_task_id = int(relationship["dialogs"]["before task"])
					dialog_after_task_id = int(relationship["dialogs"]["after task"])
					dialog_parting_phrase_id = int(relationship["dialogs"]["parting phrase"])
					dialog_not_done_yet_id = int(relationship["dialogs"]["not done yet"])
					npc_task_ids = relationship["tasks"]
		else:
			print("Unexpected data in notifications")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		
func set_tasks():
	var task_manager = get_tree().get_first_node_in_group("task_manager")
	if task_manager != null:
		for task_id in npc_task_ids:
			task_manager.assign_task(task_id)
	else:
		print("ERROR: task manager not found in npc")

func check_tasks():
	if npc_task_ids.size() == 0:
		return false
		
	var task_manager = get_tree().get_first_node_in_group("task_manager")
	if task_manager != null:
		for task_id in npc_task_ids:
			if not task_manager.is_task_completed(task_id):
				return false
		return true
	else:
		print("ERROR: task manager not found in npc")
		return false
		
	# TODO: SOMEHOW CHECK THE TASKS WITHOUT ASSIGNING THE TASKS
		
func open_notification_exclamation():
	#TODO: SHOW THE EXCLAMATION
	return
		
func close_notification_exclamation():
	#TODO: MAKE THE EXCLAMATION HIDDEN
	return
		
func set_npc(npc_name):
	what_npc_am_i = npc_name
	reset_npc()
	
func cant_leave_yet():
	show_dialog(dialog_not_done_yet_id)
	
func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		$InteractibleButtonHelper.show()
		if body.name == "Player":
			player1_is_close = true
			
		if body.name == "Player2":
			player2_is_close = true
			

func _on_player_detector_body_exited(body):
	if body.is_in_group("players"):
		$InteractibleButtonHelper.hide()
		if body.name == "Player":
			player1_is_close = false
			
		if body.name == "Player2":
			player2_is_close = false
