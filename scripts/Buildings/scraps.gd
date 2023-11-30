extends StaticBody2D

var detected_scraps : Array[StaticBody2D] = []
var detected_foliage : Array[Node2D] = []

var is_obstructed := false

func detect_scraps(area):
	if area.get_parent().is_in_group("Scraps"):
		detected_scraps.append(area.get_parent())

	if area.get_parent().is_in_group("World") or area.get_parent().is_in_group("Building") or \
		area.get_parent().is_in_group("Forest Tree"):
		is_obstructed = true

	if area.get_parent().is_in_group("Grass") or area.get_parent().is_in_group("Bush") or \
		area.get_parent().is_in_group("Tree"):
		detected_foliage.append(area.get_parent())
