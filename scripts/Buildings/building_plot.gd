extends StaticBody2D

var player_is_close := false
var can_be_build := false

func _ready():
	$Collider.disabled = true

func _process(delta):
	can_be_build = sufficient_resources()

	if can_be_build:
		$Collider.disabled = false
		$SimpleHouseSilhouette.show()

	if Input.is_action_just_pressed("interaction") and can_be_build and player_is_close:
		ResourceManager.decrease_water(50)
		ResourceManager.decrease_scraps(50)

		$SimpleHouseSilhouette.queue_free()
		$SimpleHouse.show()

func sufficient_resources():
	if ResourceManager.water >= 50 and ResourceManager.scraps >= 50:
		return true
	else:
		return false

func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		player_is_close = true

func _on_player_detector_body_exited(body):
	if body.is_in_group("players"):
		player_is_close = false
