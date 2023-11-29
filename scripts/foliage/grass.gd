extends Node2D

var variant : int

var detected_grass : Array[Node2D] = []

func _ready():
	get_child(variant).show()

func detect_grass(area) -> void:
	var parent : Node2D = area.get_parent()
	if parent.is_in_group("Grass"):
		detected_grass.append(parent)
