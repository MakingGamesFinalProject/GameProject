extends Node

# Declaration of our three resources
var first_resource : int
var second_resource : int
var third_resource : int

func _ready():
	# Initialization of our three resources
	first_resource = 0
	second_resource = 0
	third_resource = 0

func _process(_delta):
	# Everything here is temporary until we implement actual picking up of resources
	# U, I, O to increase first, second and third resource respectively
	if Input.is_action_just_pressed("increase_first_resource"):
		add_first_resource()
	if Input.is_action_just_pressed("increase_second_resource"):
		second_resource = clamp(second_resource + 1, 0, 999)
	if Input.is_action_just_pressed("increase_third_resource"):
		third_resource = clamp(third_resource + 1, 0, 999)

	# J, K, L to decrease first, second and third resource respectively
	if Input.is_action_just_pressed("decrease_first_resource"):
		first_resource = clamp(first_resource - 1, 0, 999)
	if Input.is_action_just_pressed("decrease_second_resource"):
		second_resource = clamp(second_resource - 1, 0, 999)
	if Input.is_action_just_pressed("decrease_third_resource"):
		third_resource = clamp(third_resource - 1, 0, 999)

func add_first_resource():
	first_resource = clamp(first_resource + 1, 0, 999)
