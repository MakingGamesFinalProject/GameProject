extends StaticBody2D

# Is a player situated close to the river?
var water_collectable_p1 := false
var water_collectable_p2 := false
var counter_player_detected = 0

func _process(_delta):
	# Currently, the interaction button is F for p1 and action_down joystick for player2
	if Input.is_action_just_pressed("interaction_p1") and water_collectable_p1:
		ResourceManager.increase_water(25)
		
	if Input.is_action_just_pressed("interaction_p2") and water_collectable_p2:
		ResourceManager.increase_water(25)

func _on_player_detection_body_entered(body):
	if body.is_in_group("players"):
		body.show_helper_button("F")
		counter_player_detected += 1
	if body.name == "Player":
			water_collectable_p1 = true
			
	if body.name == "Player2":
		water_collectable_p2 = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("players"):
		body.hide_helper_button()
		counter_player_detected -= 1
	if body.name == "Player":
		water_collectable_p1 = false
			
	if body.name == "Player2":
		water_collectable_p2 = false
