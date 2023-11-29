extends StaticBody2D

var variant : int

var detected_bushes : Array[StaticBody2D] = []

func _ready():
	get_child(variant).show()

func detect_bush(area) -> void:
	var parent : Node2D = area.get_parent()
	if parent.is_in_group("Bush"):
		detected_bushes.append(parent)
