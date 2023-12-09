extends StaticBody2D

var player1_is_close = false
var player2_is_close = false

var task_manager_ref = null
var npc_ref = null

var detected_foliage : Array[Node2D] = []

func detect_foliage(area):
	if area.get_parent().is_in_group("Grass") or area.get_parent().is_in_group("Bush") or \
		area.get_parent().is_in_group("Tree"):
		detected_foliage.append(area.get_parent())

func _ready():
	set_task_manager_ref()
	set_npc_ref()
	$BlueCircle.hide()
	#var world = new world_script()

func _process(_delta):	
	if player1_is_close or player2_is_close:
		$BlueCircle.show()
	else:
		$BlueCircle.hide()
	
	if player1_is_close and player2_is_close:
		if check_task_completion():
			if check_condiditons():
				# end game
				pass
			else:
				#next map
				var world = get_tree().get_first_node_in_group("World")
				assert(world, "World not found")
				reset_players()
				world.regenerate()
		else:
			npc_ref.cant_leave_yet()
			reset_players()
	
func check_condiditons():
	if NPCEncounter.huggy == 3 \
	or NPCEncounter.greasy == 3 \
	or NPCEncounter.ovaltine == 3 \
	or NPCEncounter.baby == 3:
		return true
	return false
		
func check_task_completion():
	var task_ids = npc_ref.npc_task_ids
	for id in task_ids:
		if not task_manager_ref.is_task_completed(id):
			return false
	return true

func set_task_manager_ref():
	task_manager_ref = get_tree().get_first_node_in_group("task_manager")
	assert(task_manager_ref != null, "Task manager not found")
	
func set_npc_ref():
	npc_ref = get_tree().get_first_node_in_group("npc")
	assert(npc_ref != null, "NPC not found")
	
func reset_players():
	var player_array = get_tree().get_nodes_in_group("players")
	player_array[0].global_position.x = 300
	player_array[0].global_position.y = 2400
	player_array[1].global_position.x = 300
	player_array[1].global_position.y = 2600
	player1_is_close = false
	player2_is_close = false

func _on_detection_area_body_entered(body):
	if body.is_in_group("players"):
		if body.name == "Player":
			player1_is_close = true
			
		if body.name == "Player2":
			player2_is_close = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("players"):
		if body.name == "Player":
			player1_is_close = false
			
		if body.name == "Player2":
			player2_is_close = false

