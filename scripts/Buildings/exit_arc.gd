extends StaticBody2D

var counter_players_detected = 0
var task_manager_ref = null

var detected_foliage : Array[Node2D] = []

@onready var world_script = "../levels/world.gd"

func detect_foliage(area):
	if area.get_parent().is_in_group("Grass") or area.get_parent().is_in_group("Bush") or \
		area.get_parent().is_in_group("Tree"):
		detected_foliage.append(area.get_parent())

func _ready():
	set_task_manager_ref()

func _process(_delta):	
	if counter_players_detected == 2 and check_task_completion():
		# trigger next map or end if conditions met
		if check_condiditons():
			pass
		pass
	
func check_condiditons():
	if NPCEncounter.huggy == 3 \
	or NPCEncounter.greasy == 3 \
	or NPCEncounter.ovaltine == 3 \
	or NPCEncounter.baby == 3:
		return true
	return false
		
func check_task_completion():
	var npc_ref = get_tree().get_first_node_in_group("npc")
	var task_ids = npc_ref.npc_task_ids
	for id in task_ids:
		if not task_manager_ref.is_task_completed():
			return false
	return true

func set_task_manager_ref():
	task_manager_ref = get_tree().get_first_node_in_group("task_manager")
	assert(task_manager_ref != null, "Task manager not found")

func _on_detection_area_body_entered(body):
	if body.is_in_group("players"):
		++counter_players_detected;

func _on_detection_area_body_exited(body):
	if body.is_in_group("players"):
		--counter_players_detected;

