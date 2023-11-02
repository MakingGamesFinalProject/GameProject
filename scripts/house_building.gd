extends CharacterBody2D

var players_counter_on_area = 0;

func _on_player_detector_body_entered(body):
	print("body entered")
	++players_counter_on_area;
	
func _on_player_detector_body_exited(body):
	if players_counter_on_area > 0:
		--players_counter_on_area;
