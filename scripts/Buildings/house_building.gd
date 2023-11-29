extends StaticBody2D

var players_counter_on_area = 0;

var detected_foliage : Array[Node2D] = []

func detect_foliage(area):
	if area.get_parent().is_in_group("Grass") or area.get_parent().is_in_group("Bush") or \
		area.get_parent().is_in_group("Tree"):
		detected_foliage.append(area.get_parent())

func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		++players_counter_on_area;
	
func _on_player_detector_body_exited(body):
	if players_counter_on_area > 0 && body.is_in_group("players"):
		--players_counter_on_area;
