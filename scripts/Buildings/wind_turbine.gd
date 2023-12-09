extends StaticBody2D

enum available_states {WORKING, TO_REPAIR, REPAIRING}

var counter_players_detected = 0
var task_manager_ref = null
var current_status = available_states.WORKING

@export var time_to_repair_in_seconds = 5

var detected_foliage : Array[Node2D] = []

# Time it takes for the silhoutte to pulse in/out
const SILHOUETTE_PULSE_TIME : float = 1.0
# Time it takes for the building to fade in (currently matches the building sound)
const BUILDING_FADE_TIME: float = 10.52

# Keep track of the tween state
var silhouette_is_pulsing := false

var player1_is_close := false
var player2_is_close := false

var can_be_build := false
var has_been_built := false

var is_collectable := false
var COLLECTABILITY_TIMER: float = 20.0

#############################################################################################
############################DIFFERENT FOR EVERY BUILDING ####################################
#####################################vvvvv###################################################
var needed_for_build_water := 0
var needed_for_build_energy := 0
var needed_for_build_scrap := 20

var collection_resource_water := 0
var collection_resource_energy := 50
var collection_resource_scrap := 0
#########################################^^^^################################################
############################DIFFERENT FOR EVERY BUILDING ####################################
#############################################################################################

func detect_foliage(area):
	if area.get_parent().is_in_group("Grass") or area.get_parent().is_in_group("Bush") or \
		area.get_parent().is_in_group("Tree"):
		detected_foliage.append(area.get_parent())

func _ready():
	set_task_manager_ref()
	$Collider.hide()
	$Base.hide()
	$Outline.hide()
	$ExclamationMark.hide()
	$HelperButton.hide()

func _process(_delta):
	check_task_completion()
	
	can_be_build = sufficient_resources()

	if can_be_build and not has_been_built:
		$Collider.disabled = false
		$Outline.show()

		# Make the silhouette pulse if it's not
		if not silhouette_is_pulsing:
			silhouette_is_pulsing = true
			silhouette_pulse()

	if Input.is_action_just_pressed("interaction_p1") and  player1_is_close:
		if can_be_build and not has_been_built:
			ResourceManager.decrease_water(needed_for_build_water)
			ResourceManager.decrease_energy(needed_for_build_energy)
			ResourceManager.decrease_scraps(needed_for_build_scrap)
			has_been_built = true

			$Outline.queue_free()
			$Base.show()
			building_fade_in()
			building_play_sounds()
		
	if Input.is_action_just_pressed("interaction_p2") and player2_is_close:
		if can_be_build and not has_been_built:
			ResourceManager.decrease_water(needed_for_build_water)
			ResourceManager.decrease_energy(needed_for_build_energy)
			ResourceManager.decrease_scraps(needed_for_build_scrap)
			has_been_built = true

			$Outline.queue_free()
			$Base.show()
			building_fade_in()
			building_play_sounds()
	
	if has_been_built and is_collectable and check_shed_turbine_task_connection():
		var player_array = get_tree().get_nodes_in_group("players")
		player_array[0].player_interaction()
		player_array[1].player_interaction()
		start_collection_timer()
		give_resources()

func sufficient_resources():
	if ResourceManager.water >= needed_for_build_water \
	and ResourceManager.energy >= needed_for_build_energy \
	and ResourceManager.scraps >= needed_for_build_scrap:
		return true
	else:
		return false
		
func start_collection_timer():
	$ExclamationMark.hide()
	is_collectable = false
	await get_tree().create_timer(COLLECTABILITY_TIMER).timeout
	is_collectable = true
	$ExclamationMark.show()
	
func give_resources():
	ResourceManager.increase_water(collection_resource_water)
	ResourceManager.increase_energy(collection_resource_energy)
	ResourceManager.increase_scraps(collection_resource_scrap)

# The function simply modifies the alpha value of the sprite
func silhouette_pulse():
	var fade = create_tween()
	fade.tween_property($Outline, "modulate", Color(1, 1, 1, 0), SILHOUETTE_PULSE_TIME). \
		from(Color(1, 1, 1, 1))
	fade.tween_property($Outline, "modulate", Color(1, 1, 1, 1), SILHOUETTE_PULSE_TIME). \
		from(Color(1, 1, 1, 0))
	await(fade.finished)
	silhouette_is_pulsing = false
	
func building_fade_in():
	var fade1 = create_tween()
	fade1.tween_property($Base, "modulate", Color(1, 1, 1, 1), BUILDING_FADE_TIME). \
		from(Color(1, 1, 1, 0))

func building_play_sounds():
	$Building.play()
	await($Building.finished)
	$Built.play()
	has_been_built = true
	start_collection_timer()
	
#############################################################################################
############################DIFFERENT FOR EVERY BUILDING ####################################
#####################################vvvvv###################################################

func check_task_completion():
	# This function needs to be here but it is supposed to 
	# call the correct "check tasks" depending on the building
	# check_for_fixing_task() # decided we don't need because of time constraints
	check_for_batteries_task()

func check_for_batteries_task():
	if current_status != available_states.WORKING: 
		return
	
	# Check if both players have the check batteries task assigned
	var task_id = task_manager_ref.get_task_by_name("Check Batteries").uid
	if task_manager_ref.get_current_task(1) == task_id and task_manager_ref.get_current_task(2) == task_id:
		if check_shed_turbine_task_connection():
			var player_array = get_tree().get_nodes_in_group("players")
			player_array[0].player_interaction()
			player_array[1].player_interaction()
			var time_manager = WaitUtil.new()
			time_manager.wait(time_to_repair_in_seconds, self, "_on_battery_task_callback")

func check_shed_turbine_task_connection():
	# a player is interacting with the wind turbine
	if (Input.is_action_pressed("interaction_p1") and player1_is_close) \
	 or (Input.is_action_pressed("interaction_p2") and player2_is_close):
		var Shed_ref = get_tree().get_first_node_in_group("Shed")
		assert(Shed_ref != null, "Shed reference not found")
		# a player interacting with the house and the wind turbine
		var amount_players_interacting_with_shed = Shed_ref.counter_players_detected
		if counter_players_detected > 0 and amount_players_interacting_with_shed > 0:
			return true
	return false

func _on_battery_task_callback():
	var task_id = task_manager_ref.get_task_by_name("Check Batteries").uid
	task_manager_ref.set_task_as_done(task_id)

func check_for_fixing_task():
	if current_status == available_states.TO_REPAIR: # check if the building needs repair
		return
		
	var a_user_is_interacting = Input.is_action_pressed("interaction_p1") or Input.is_action_pressed("interaction_p2")
	if counter_players_detected > 0:
		if a_user_is_interacting and (current_status == available_states.TO_REPAIR):
			repair_self()

func repair_self():
	current_status = available_states.REPAIRING
	var time_manager = WaitUtil.new()
	time_manager.wait(time_to_repair_in_seconds, self, "_on_repair_complete_callback")

func _on_repair_complete_callback():
	current_status = available_states.WORKING
	task_manager_ref.set_task_as_done(2) # NEEDS THE CORRECT TASK ID FOR THIS BUILDING

#######################################^^^^##################################################
############################DIFFERENT FOR EVERY BUILDING ####################################
#############################################################################################

func set_task_manager_ref():
	task_manager_ref = get_tree().get_first_node_in_group("task_manager")
	assert(task_manager_ref != null, "Task manager not found")

func _on_detection_area_body_entered(body):
	if body.is_in_group("players"):
		if (!has_been_built and can_be_build) or is_collectable:
			$HelperButton.show()
		++counter_players_detected;
		if body.name == "Player":
			player1_is_close = true
			
		if body.name == "Player2":
			player2_is_close = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("players"):
		$HelperButton.hide()
		--counter_players_detected;
		if body.name == "Player":
			player1_is_close = false
			
		if body.name == "Player2":
			player2_is_close = false

