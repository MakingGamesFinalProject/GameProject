extends Control

# Creating references to the three resource labels
@onready var first_resource : Label = $FirstResource
@onready var second_resource : Label = $SecondResource
@onready var third_resource : Label = $ThirdResource

func _ready():
	# Temporarily made the sprites look different from eachother
	$FirstResourceSprite.modulate = Color(1, 0.75, 0.75, 1)
	$SecondResourceSprite.modulate = Color(0.75, 1, 0.75, 1)
	$ThirdResourceSprite.modulate = Color(0.75, 0.75, 1, 1)

func _process(_delta):
	# Keep the labels up to date
	first_resource.text = str(ResourceManager.first_resource)
	second_resource.text = str(ResourceManager.second_resource)
	third_resource.text = str(ResourceManager.third_resource)
