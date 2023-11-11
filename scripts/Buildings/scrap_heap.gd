extends StaticBody2D

# Is a player situated close to the scrap heap?
var scrap_collectable := false

func _process(_delta):
	# Currently, the interaction button is F
	if Input.is_action_just_pressed("interaction") and scrap_collectable:
		ResourceManager.increase_scraps(25)
		queue_free()

func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		scrap_collectable = true

func _on_player_detector_body_exited(body):
	if body.is_in_group("players"):
		scrap_collectable = false
