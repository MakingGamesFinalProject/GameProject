extends Node

var scene_transition_scene = preload("res://scenes/scene_transition.tscn")

var player : CharacterBody2D
var location : Area2D

func change_scene(player_to_reposition : CharacterBody2D, location_to_reposition_to : Area2D):
	player = player_to_reposition
	location = location_to_reposition_to

	var scene_transition = scene_transition_scene.instantiate()
	if player.name == "Player2":
		scene_transition.global_position = Vector2(1024, 0)
	get_tree().root.add_child(scene_transition)
	scene_transition.connect("screen_darkened", reposition)

func reposition():
	player.global_position = location.global_position - Vector2(100, 100)
