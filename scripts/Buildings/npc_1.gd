extends StaticBody2D

var player1_is_close := false
var player2_is_close := false

@export var what_npc_am_i := NPC.HUGGY

@export var startup_dialog := false
@export var resource_dialog_trigger := Vector3.ZERO #water, electricity, scrap
@export var Building_built_path_trigger := building_options.NULL
@export var task_id_trigger := -1

@export var at_startup_npc_dialog_id_list := [0]
@export var before_resource_npc_dialog_id_list := [0]
@export var before_building_npc_dialog_id_list := [0]
@export var before_task_npc_dialog_id_list := [0]
@export var after_task_npc_dialog_id_list := [0]

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

enum NPC {
	HUGGY,
	GREASY,
}

enum state {
	STARTUP,
	RESOURCE,
	BUILDING,
	TASK,
	END,
}

enum building_options {
	NULL,
	BuildingPlot,
	HouseBuilding,
}

var building_option_list := [null, "BuildingPlot", "HouseBuilding"]

var curr_state = state.STARTUP

var dialog_open := false
var current_dialog := 0

func _ready():
	$InteractibleButtonHelper.hide()
	if !startup_dialog:
		curr_state = state.RESOURCE
		if resource_dialog_trigger == Vector3.ZERO:
			curr_state = state.BUILDING
			if Building_built_path_trigger == building_options.NULL:
				curr_state = state.TASK
				if task_id_trigger == -1:
					print("ERROR: no triggers set in npc")
	
	if what_npc_am_i == NPC.HUGGY:
		$Huggy.visible = true
		$Greasy.visible = false
		state_machine.travel("idle_Huggy")
	elif what_npc_am_i == NPC.GREASY:
		$Greasy.visible = true
		$Huggy.visible = false
		state_machine.travel("idle_Greasy")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dialog_node = get_tree().get_first_node_in_group("Notification")
	var player_array = get_tree().get_nodes_in_group("players")
	
	if Input.is_action_just_pressed("interaction_p1") and player1_is_close:
		if dialog_node.name == "notification":
			if player_array[0].name == "Player":
				process_dialog_logic(
					dialog_node, 
					player_array[0], 
					current_dialog
				)
		
	if Input.is_action_just_pressed("interaction_p2") and player2_is_close:
		if dialog_node.name == "notification":
			if player_array[1].name == "Player2":
				process_dialog_logic(
					dialog_node,
					player_array[1], 
					current_dialog
				)
				
	check_triggers_and_change_state()

func process_dialog_logic(dialog_node, player, _current_dialog):

	
	if dialog_open && (curr_state == state.STARTUP) && (_current_dialog == at_startup_npc_dialog_id_list.size()):
		curr_state = state.RESOURCE	
		reset_dialog_state(dialog_node, player)
	elif dialog_open && (curr_state == state.RESOURCE) && (_current_dialog == before_resource_npc_dialog_id_list.size()):
		reset_dialog_state(dialog_node, player)
	elif dialog_open && (curr_state == state.BUILDING) && (_current_dialog == before_building_npc_dialog_id_list.size()):
		reset_dialog_state(dialog_node, player)
	elif dialog_open && (curr_state == state.TASK) && (_current_dialog == before_task_npc_dialog_id_list.size()):
		reset_dialog_state(dialog_node, player)
	elif dialog_open && (curr_state == state.END) && (_current_dialog == after_task_npc_dialog_id_list.size()):
		reset_dialog_state(dialog_node, player)
	else:
		dialog_open = true
		
		if curr_state == state.STARTUP:
			show_next_dialog(dialog_node, at_startup_npc_dialog_id_list, _current_dialog)
			current_dialog += 1
		elif curr_state == state.RESOURCE:
			show_next_dialog(dialog_node, before_resource_npc_dialog_id_list, _current_dialog)
			current_dialog += 1
		elif curr_state == state.BUILDING:
			show_next_dialog(dialog_node, before_building_npc_dialog_id_list, _current_dialog)
			current_dialog += 1
		elif curr_state == state.TASK:
			show_next_dialog(dialog_node, before_task_npc_dialog_id_list, _current_dialog)
			current_dialog += 1
		elif curr_state == state.END:
			show_next_dialog(dialog_node, after_task_npc_dialog_id_list, _current_dialog)
			current_dialog += 1

		player.player_freeze()

func show_next_dialog(dialog_node, dialog_id_list, current_dialog_index):
	dialog_node.show_dialog(dialog_id_list[current_dialog_index])

func reset_dialog_state(dialog_node, player):
	dialog_open = false
	current_dialog = 0
	dialog_node.hide_dialog()
	player.player_unfreeze()
	
func check_triggers_and_change_state():
	if curr_state == state.RESOURCE:
		check_resources()
		
	if curr_state == state.BUILDING:
		check_building()
		
	if curr_state == state.TASK:
		check_task()
		
		
func check_resources():
	var resource_manager = get_tree().get_first_node_in_group("resource_manager")
	if resource_manager != null:
		var water = resource_manager.water
		var energy = resource_manager.energy
		var scrap = resource_manager.scraps
		if (water >= resource_dialog_trigger.x) && (energy >= resource_dialog_trigger.y) && (scrap >= resource_dialog_trigger.z):
			curr_state = state.BUILDING
	else:
		print("ERROR: reasource manager not found in npc")
	
func check_building():
	var buildings = get_tree().get_nodes_in_group("Building")
	
	for building in buildings:
		if building.name == building_option_list[Building_built_path_trigger]:
			if building.has_been_built:
				curr_state = state.TASK
				set_task()

func set_task():
	var task_manager = get_tree().get_first_node_in_group("task_manager")
	if task_manager != null:
		task_manager.assign_task(task_id_trigger)
	else:
		print("ERROR: task manager not found in npc")

func check_task():
	if task_id_trigger == -1:
		curr_state = state.END
		return
	var task_manager = get_tree().get_first_node_in_group("task_manager")
	if task_manager != null:
		if task_manager.is_task_completed(task_id_trigger):
			curr_state = state.END
	else:
		print("ERROR: task manager not found in npc")
	
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
