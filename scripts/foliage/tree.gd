extends StaticBody2D

var variant : int

var detected_trees : Array[StaticBody2D] = []
var detected_forest_trees : Array[StaticBody2D] = []
var detected_foliage : Array[Node2D] = []

func _ready():
	get_child(variant).show()

func detect_tree(_area_rid, area, area_shape_index, local_shape_index) -> void:
	var parent : Node2D = area.get_parent()
	if parent.is_in_group("Tree"):
		detected_trees.append(parent)

	if area_shape_index == 1 and local_shape_index == 1 and parent.is_in_group("Forest Tree"):
		detected_forest_trees.append(parent)

	if parent.is_in_group("Grass") or parent.is_in_group("Bush"):
		detected_foliage.append(parent)
