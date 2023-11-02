extends Node

# Declaration of the scene tracker
var scene : String

func _ready():
	# Initialization of the scene tracker
	scene = "Main"

func _process(_delta):
	# Keeping track of which scene is currently active
	scene = get_tree().root.get_children()[get_tree().root.get_child_count() - 1].name

	# Everything here is temporary until we implement actual triggers to change scenes
	# E to change the scene
	if Input.is_action_just_pressed("change_scene"):
		if scene == "Main":
			get_tree().change_scene_to_file("res://House.tscn")
		else:
			get_tree().change_scene_to_file("res://Main.tscn")
