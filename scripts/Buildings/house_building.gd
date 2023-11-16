extends CharacterBody2D

var players_counter_on_area = 0;



func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		++players_counter_on_area;
	
func _on_player_detector_body_exited(body):
	if players_counter_on_area > 0 && body.is_in_group("players"):
		--players_counter_on_area;
