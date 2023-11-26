extends Control

var task_manager = null

func _ready():
	task_manager = get_tree().get_first_node_in_group("task_manager")
	
func _on_button_pressed():
	var task_name = $Panel/VBoxContainer/Goal.text
	var task = task_manager.get_task_by_name(task_name)
	task_manager.set_current_task(task.uid, 1)
	var current_task_ui_p1 = get_tree().get_nodes_in_group("current_task_ui")[0]
	current_task_ui_p1.text = task.name


func _on_button_2_pressed():
	var task_name = $Panel/VBoxContainer/Goal.text
	var task = task_manager.get_task_by_name(task_name)
	task_manager.set_current_task(task.uid, 1)
	var current_task_ui_p1 = get_tree().get_nodes_in_group("current_task_ui")[1]
	current_task_ui_p1.text = task.name
