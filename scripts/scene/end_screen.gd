extends Node2D

func _ready():
	if NPCEncounter.huggy == 3:
		$Huggy.show()
	elif NPCEncounter.greasy == 3:
		$Greasy.show()
	elif NPCEncounter.ovaltine == 3:
		$Ovaltine.show()
	else:
		$Baby.show()

func _process(_delta):
	if Input.is_action_just_pressed("toggle_pause"):
		get_tree().quit()
