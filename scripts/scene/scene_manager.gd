extends Node

# Reference to the scene containing the fade effect
var scene_transition_scene = preload("res://scenes/scene/scene_transition.tscn")

# Who is transitioning to where?
var player : CharacterBody2D
var location : Area2D

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		ResourceManager.reset_resources()
		get_tree().change_scene_to_file("res://scenes/main.tscn")

# The following function records the above information, instantiates the fade and repositions
func change_scene(player_to_reposition : CharacterBody2D, location_to_reposition_to : Area2D):
	player = player_to_reposition
	location = location_to_reposition_to

	var scene_transition = scene_transition_scene.instantiate()
	# Changing the position of the fade effect to the correct player
	if player.name == "Player2":
		scene_transition.global_position = Vector2(1024, 0)
	get_tree().root.add_child(scene_transition)
	# Fetch the custom signal from the transition and connect to a function
	scene_transition.connect("screen_darkened", reposition)

func reposition():
	# The position is obviously temporary and arbitrary
	player.global_position = location.global_position - Vector2(100, 100)
