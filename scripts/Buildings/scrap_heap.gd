extends StaticBody2D

# Is a player situated close to the scrap heap?
var scrap_collectable_p1 := false
var scrap_collectable_p2 := false

func _process(_delta):
	# Currently, the interaction button is F
	if Input.is_action_just_pressed("interaction_p1") and scrap_collectable_p1:
		ResourceManager.increase_scraps(25)
		queue_free()
		
	if Input.is_action_just_pressed("interaction_p2") and scrap_collectable_p2:
		ResourceManager.increase_scraps(25)
		queue_free()

func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		if body.name == "Player":
			scrap_collectable_p1 = true
			
		if body.name == "Player2":
			scrap_collectable_p2 = true

func _on_player_detector_body_exited(body):
	if body.is_in_group("players"):
		if body.name == "Player":
			scrap_collectable_p1 = false
			
		if body.name == "Player2":
			scrap_collectable_p2 = false
