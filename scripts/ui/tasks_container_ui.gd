extends VBoxContainer

var tasks_manager = null

# nodes references
var task_container_player_1 = null 
var task_container_player_2 = null

func _ready():
	set_task_manager()
	task_container_player_1 = get_tree().get_nodes_in_group("ui_task_player")[0]
	
func set_task_manager():
	tasks_manager = get_tree().get_first_node_in_group("task_manager")

func _on_player_toggle_task_list(is_player_with_keyboard):
	task_container_player_1.set_visible(!task_container_player_1.visible)
