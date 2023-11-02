extends Node

func _process(_delta):
	# Everything here is temporary until we implement actual picking up of resources
	# U, I, O to increase first, second and third resource respectively
	if Input.is_action_just_pressed("increase_first_resource"):
		world_inventory.first_resource = clamp(world_inventory.first_resource + 1, 0, 999)
	if Input.is_action_just_pressed("increase_second_resource"):
		world_inventory.second_resource = clamp(world_inventory.second_resource + 1, 0, 999)
	if Input.is_action_just_pressed("increase_third_resource"):
		world_inventory.third_resource = clamp(world_inventory.third_resource + 1, 0, 999)

	# J, K, L to decrease first, second and third resource respectively
	if Input.is_action_just_pressed("decrease_first_resource"):
		world_inventory.first_resource = clamp(world_inventory.first_resource - 1, 0, 999)
	if Input.is_action_just_pressed("decrease_second_resource"):
		world_inventory.second_resource = clamp(world_inventory.second_resource - 1, 0, 999)
	if Input.is_action_just_pressed("decrease_third_resource"):
		world_inventory.third_resource = clamp(world_inventory.third_resource - 1, 0, 999)
