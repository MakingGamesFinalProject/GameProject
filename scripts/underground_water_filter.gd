extends CharacterBody2D

var players_count_on_building = 0

func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		players_count_on_building += 1

func _on_player_detector_body_exited(body):
	if body.is_in_group("players") && players_count_on_building > 0:
		players_count_on_building -= 1
