extends StaticBody2D

var player1_is_close := false
var player2_is_close := false

var npc_dialog_id := 1

var dialog_open := false

func _ready():
	$InteractibleButtonHelper.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dialog_node = get_tree().get_first_node_in_group("Notification")
	var player_array = get_tree().get_nodes_in_group("players")
	
	if Input.is_action_just_pressed("interaction_p1") and player1_is_close:
		if dialog_node.name == "notification":
			if player_array[0].name == "Player":
				if dialog_open:
					dialog_node.hide_dialog()
					player_array[0].player_unfreeze()
				else:
					dialog_open = true
					dialog_node.show_dialog(npc_dialog_id)
					player_array[0].player_freeze()
		
	if Input.is_action_just_pressed("interaction_p2") and player2_is_close:
		if dialog_node.name == "notification":
			if player_array[1].name == "Player2":
				if dialog_open:
					dialog_node.hide_dialog()
					player_array[1].player_unfreeze()
				else:
					dialog_open = true
					dialog_node.show_dialog(npc_dialog_id)
					player_array[1].player_freeze()

func _on_player_detector_body_entered(body):
	if body.is_in_group("players"):
		$InteractibleButtonHelper.show()
		if body.name == "Player":
			player1_is_close = true
			
		if body.name == "Player2":
			player2_is_close = true

func _on_player_detector_body_exited(body):
	if body.is_in_group("players"):
		$InteractibleButtonHelper.hide()
		if body.name == "Player":
			player1_is_close = false
			
		if body.name == "Player2":
			player2_is_close = false
