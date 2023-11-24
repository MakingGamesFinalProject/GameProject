extends StaticBody2D

var player1_is_close := false
var player2_is_close := false

@export var before_task_npc_dialog_id_list := [1]
@export var after_task_npc_dialog_id_list := [1]
@export var task_id := 1

var dialog_open := false
var before_current_dialog := 0
var after_current_dialog := 0

func _ready():
	$InteractibleButtonHelper.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dialog_node = get_tree().get_first_node_in_group("Notification")
	var player_array = get_tree().get_nodes_in_group("players")
	var task_manager = get_tree().get_first_node_in_group("task_manager")
	
	if Input.is_action_just_pressed("interaction_p1") and player1_is_close:
		if dialog_node.name == "notification":
			if player_array[0].name == "Player":
				process_dialog_logic(
					dialog_node, 
					task_manager, 
					player_array[0], 
					task_id, 
					before_task_npc_dialog_id_list, 
					after_task_npc_dialog_id_list, 
					before_current_dialog, 
					after_current_dialog
				)
		
	if Input.is_action_just_pressed("interaction_p2") and player2_is_close:
		if dialog_node.name == "notification":
			if player_array[1].name == "Player2":
				process_dialog_logic(
					dialog_node, 
					task_manager, 
					player_array[1], 
					task_id, 
					before_task_npc_dialog_id_list, 
					after_task_npc_dialog_id_list, 
					before_current_dialog, 
					after_current_dialog
				)

func process_dialog_logic(dialog_node, task_manager, player, task_id, before_dialog_list, after_dialog_list, current_before_dialog, current_after_dialog):
	if dialog_open && (current_before_dialog == before_dialog_list.size()):
		reset_dialog_state(dialog_node, player)
	elif dialog_open && (current_after_dialog == after_dialog_list.size()):
		reset_dialog_state(dialog_node, player)
	else:
		dialog_open = true
		if task_manager.is_task_completed(task_id):
			after_current_dialog = show_next_dialog(dialog_node, after_dialog_list, current_after_dialog)
		else:
			before_current_dialog = show_next_dialog(dialog_node, before_dialog_list, current_before_dialog)
		player.player_freeze()

func show_next_dialog(dialog_node, dialog_id_list, current_dialog_index):
	dialog_node.show_dialog(dialog_id_list[current_dialog_index])
	return current_dialog_index + 1

func reset_dialog_state(dialog_node, player):
	dialog_open = false
	before_current_dialog = 0
	after_current_dialog = 0
	dialog_node.hide_dialog()
	player.player_unfreeze()

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
