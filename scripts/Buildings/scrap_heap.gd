extends StaticBody2D

# Is a player situated close to the scrap heap?
var scrap_collectable_p1 := false
var scrap_collectable_p2 := false

@export var fade_timer: float = 1.0  # Time in seconds to fade out
var fade_elapsed: float = 0.0
var fading_out: bool = false

var detected_scraps : Array[StaticBody2D] = []
var detected_foliage : Array[Node2D] = []

var is_obstructed := false

var amount_of_scrap := 50

func detect_scraps(area):
	if area.get_parent().is_in_group("Scraps"):
		detected_scraps.append(area.get_parent())

	if area.get_parent().is_in_group("World") or area.get_parent().is_in_group("Building") or \
		area.get_parent().is_in_group("Forest Tree"):
		is_obstructed = true

	if area.get_parent().is_in_group("Grass") or area.get_parent().is_in_group("Bush") or \
		area.get_parent().is_in_group("Tree"):
		detected_foliage.append(area.get_parent())

func _ready():
	$InteractibleButtonHelper.hide()
	
	
func _process(_delta):
	check_if_clean_scrap_piles_task()
	if fading_out:
		fade_out(_delta)
	# Currently, the interaction button is F
	else:
		handle_interactions_with_players()
		
func handle_interactions_with_players():
	if Input.is_action_just_pressed("interaction_p1") and scrap_collectable_p1:
		ResourceManager.increase_scraps(amount_of_scrap)
		var player_array = get_tree().get_nodes_in_group("players")
		player_array[0].player_interaction()
		start_fading()
	if Input.is_action_just_pressed("interaction_p2") and scrap_collectable_p2:
		ResourceManager.increase_scraps(amount_of_scrap)
		var player_array = get_tree().get_nodes_in_group("players")
		player_array[1].player_interaction()
		start_fading()
	
func start_fading():
	fading_out = true
	fade_elapsed = 0.0
	
func check_if_clean_scrap_piles_task():
	var scrap_array = get_tree().get_nodes_in_group("Scraps")
	if scrap_array.size() == 1:
		var task_manager_ref = get_tree().get_first_node_in_group("task_manager")
		assert(task_manager_ref != null, "Task manager not found")
		var task_id = task_manager_ref.get_task_by_name("Clean Scrap Heaps").uid
		task_manager_ref.set_task_as_done(task_id)

func fade_out(delta):
	fade_elapsed += delta
	var new_fade_factor = lerp(1.0, 0.0, fade_elapsed / fade_timer)
	var material : ShaderMaterial = $Sprite.get_material()
	material.set_shader_parameter("value", new_fade_factor)

	if fade_elapsed >= fade_timer:
		fading_out = false	
		hide()  
		queue_free()

func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		$InteractibleButtonHelper.show()
		if body.name == "Player":
			scrap_collectable_p1 = true
			
		if body.name == "Player2":
			scrap_collectable_p2 = true

func _on_player_detector_body_exited(body):
	if body.is_in_group("players"):
		$InteractibleButtonHelper.hide()
		if body.name == "Player":
			scrap_collectable_p1 = false
			
		if body.name == "Player2":
			scrap_collectable_p2 = false
