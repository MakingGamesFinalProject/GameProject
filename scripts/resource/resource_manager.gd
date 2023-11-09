extends Node

# Declaration and initialization of our three resources
var water : int = 0
var energy : int = 0
var scraps : int = 0

func _process(_delta):
	# Everything here is temporary until we implement actual picking up of resources
	# U, I, O to increase water, energy and scraps respectively
	if Input.is_action_just_pressed("increase_water"):
		increase_water()
	if Input.is_action_just_pressed("increase_energy"):
		increase_energy()
	if Input.is_action_just_pressed("increase_scraps"):
		increase_scraps()

	# Again, temporary
	# J, K, L to decrease water, energy and scraps respectively
	if Input.is_action_just_pressed("decrease_water"):
		decrease_water()
	if Input.is_action_just_pressed("decrease_energy"):
		decrease_energy()
	if Input.is_action_just_pressed("decrease_scraps"):
		decrease_scraps()

func increase_water():
	water = clamp(water + 1, 0, 999)

func increase_energy():
	energy = clamp(energy + 1, 0, 999)

func increase_scraps():
	scraps = clamp(scraps + 1, 0, 999)

func decrease_water():
	water = clamp(water - 1, 0, 999)

func decrease_energy():
	energy = clamp(energy - 1, 0, 999)

func decrease_scraps():
	scraps = clamp(scraps - 1, 0, 999)
