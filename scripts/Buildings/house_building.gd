extends StaticBody2D

var players_counter_on_area = 0;

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

var collection_resource_water := 0
var collection_resource_energy := 5
var collection_resource_scrap := 5

func _ready():
	$Collider.disabled = true
	$shed.hide()
	$shed_outline.hide()
	$ExclamationMark.hide()
	$HelperButton.hide()

func _process(_delta):
	can_be_build = sufficient_resources()

	if can_be_build and not has_been_built:
		$Collider.disabled = false
		$shed_outline.show()

		# Make the silhouette pulse if it's not
		if not silhouette_is_pulsing:
			silhouette_is_pulsing = true
			silhouette_pulse()

	if Input.is_action_just_pressed("interaction_p1") and  player1_is_close:
		if can_be_build and not has_been_built:
			ResourceManager.decrease_water(50)
			ResourceManager.decrease_scraps(50)
			has_been_built = true

			$shed_outline.queue_free()
			$shed.show()
			building_fade_in()
			building_play_sounds()
		
		elif has_been_built and is_collectable:
			start_collection_timer()
			give_resources()
		
	if Input.is_action_just_pressed("interaction_p2") and player2_is_close:
		
		if can_be_build and not has_been_built:
			ResourceManager.decrease_water(50)
			ResourceManager.decrease_scraps(50)
			has_been_built = true

			$shed_outline.queue_free()
			$shed.show()
			building_fade_in()
			building_play_sounds()
			
		elif has_been_built and is_collectable:
			start_collection_timer()
			give_resources()

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
	fade.tween_property($shed_outline, "modulate", Color(1, 1, 1, 0), SILHOUETTE_PULSE_TIME). \
		from(Color(1, 1, 1, 1))
	fade.tween_property($shed_outline, "modulate", Color(1, 1, 1, 1), SILHOUETTE_PULSE_TIME). \
		from(Color(1, 1, 1, 0))
	await(fade.finished)
	silhouette_is_pulsing = false

func building_fade_in():
	var fade = create_tween()
	fade.tween_property($shed, "modulate", Color(1, 1, 1, 1), BUILDING_FADE_TIME). \
		from(Color(1, 1, 1, 0))

func building_play_sounds():
	$Building.play()
	await($Building.finished)
	$Built.play()
	has_been_built = true
	start_collection_timer()

func sufficient_resources():
	if ResourceManager.scraps >= 5:
		return true
	else:
		return false

func detect_foliage(area):
	if area.get_parent().is_in_group("Grass") or area.get_parent().is_in_group("Bush") or \
		area.get_parent().is_in_group("Tree"):
		detected_foliage.append(area.get_parent())

func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		$HelperButton.show()
		++players_counter_on_area;
		if body.name == "Player":
			player1_is_close = true
			
		if body.name == "Player2":
			player2_is_close = true
	
func _on_player_detector_body_exited(body):
	if body.is_in_group("players"):
		$HelperButton.hide()
		--players_counter_on_area;
		if body.name == "Player":
			player1_is_close = false
			
		if body.name == "Player2":
			player2_is_close = false
		
