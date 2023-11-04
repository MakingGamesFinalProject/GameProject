extends Control

# Creating references to the three resource labels
@onready var first_resource : Label = $HBoxContainer/FirstResource
@onready var second_resource : Label = $HBoxContainer/SecondResource
@onready var third_resource : Label = $HBoxContainer/ThirdResource

# Creating a reference to the scene tracker label
@onready var scene : Label = $Scene

func _process(_delta):
	# Keep the labels up to date
	first_resource.text = "First: " + str(world_inventory.first_resource)
	second_resource.text = "Second: " + str(world_inventory.second_resource)
	third_resource.text = "Third: " + str(world_inventory.third_resource)

	scene.text = "Scene: " + SceneManager.scene
