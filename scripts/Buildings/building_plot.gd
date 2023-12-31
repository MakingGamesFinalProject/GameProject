extends StaticBody2D

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

func _ready():
	$Collider.disabled = true

func _process(_delta):
	can_be_build = sufficient_resources()

	if can_be_build:
		$Collider.disabled = false
		$SimpleHouseSilhouette.show()

		# Make the silhouette pulse if it's not
		if not silhouette_is_pulsing:
			silhouette_is_pulsing = true
			silhouette_pulse()

	if Input.is_action_just_pressed("interaction_p1") and can_be_build and player1_is_close:
		ResourceManager.decrease_water(50)
		ResourceManager.decrease_scraps(50)

		$SimpleHouseSilhouette.queue_free()
		$SimpleHouse.show()
		building_fade_in()
		building_play_sounds()
		
	if Input.is_action_just_pressed("interaction_p2") and can_be_build and player2_is_close:
		ResourceManager.decrease_water(50)
		ResourceManager.decrease_scraps(50)

		$SimpleHouseSilhouette.queue_free()
		$SimpleHouse.show()
		building_fade_in()
		building_play_sounds()

# The function simply modifies the alpha value of the sprite
func silhouette_pulse():
	var fade = create_tween()
	fade.tween_property($SimpleHouseSilhouette, "modulate", Color(1, 1, 1, 0), SILHOUETTE_PULSE_TIME). \
		from(Color(1, 1, 1, 1))
	fade.tween_property($SimpleHouseSilhouette, "modulate", Color(1, 1, 1, 1), SILHOUETTE_PULSE_TIME). \
		from(Color(1, 1, 1, 0))
	await(fade.finished)
	silhouette_is_pulsing = false

func building_fade_in():
	var fade = create_tween()
	fade.tween_property($SimpleHouse, "modulate", Color(1, 1, 1, 1), BUILDING_FADE_TIME). \
		from(Color(1, 1, 1, 0))

func building_play_sounds():
	$Building.play()
	await($Building.finished)
	$Built.play()
	has_been_built = true

func sufficient_resources():
	if ResourceManager.water >= 50 and ResourceManager.scraps >= 50:
		return true
	else:
		return false

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
