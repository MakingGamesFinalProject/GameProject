extends StaticBody2D

# Is a player situated close to the river?
var water_collectable_p1 := false
var water_collectable_p2 := false
var counter_player_detected = 0

var is_collectable = true
var COLLECTABILITY_TIMER = 20.0

func _process(_delta):
	# Currently, the interaction button is F for p1 and action_down joystick for player2
	if Input.is_action_just_pressed("interaction_p1") and water_collectable_p1 and is_collectable:
		ResourceManager.increase_water(5)
		var player_array = get_tree().get_nodes_in_group("players")
		player_array[0].player_interaction()
		start_collection_timer()
		
	if Input.is_action_just_pressed("interaction_p2") and water_collectable_p2 and is_collectable:
		ResourceManager.increase_water(5)
		var player_array = get_tree().get_nodes_in_group("players")
		player_array[1].player_interaction()
		start_collection_timer()f
		
func start_collection_timer():
	is_collectable = false
	await get_tree().create_timer(COLLECTABILITY_TIMER).timeout
	is_collectable = true

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
