extends CharacterBody2D

var players_count_on_building := false

func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		players_count_on_building = true

func _on_player_detector_body_exited(body):
	if body.is_in_group("players") && players_count_on_building:
		players_count_on_building = false

func _process(delta):
	# Temporary trigger for increasing an arbitrary resource
	if players_count_on_building:
		ResourceManager.increase_water()
