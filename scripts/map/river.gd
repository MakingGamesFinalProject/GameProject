extends StaticBody2D

# Is a player situated close to the river?
var water_collectable := false

func _process(_delta):
	# Currently, the interaction button is F
	if Input.is_action_just_pressed("interaction") and water_collectable:
		ResourceManager.increase_water(25)

func _on_player_detection_body_entered(body):
	if body.is_in_group("players"):
		water_collectable = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("players"):
		water_collectable = false
