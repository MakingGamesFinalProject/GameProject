extends Sprite2D

var tasks_manager = null
var task_container_player = null 

func _ready():
	var tree = get_tree()
	tasks_manager = tree.get_first_node_in_group("task_manager")
	task_container_player = tree.get_first_node_in_group("ui_task_player")
	assert(tasks_manager != null, "Task manager not found")
	assert(task_container_player != null, "Task container reference not found")
	load_assigned_tasks()
	
func _on_player_toggle_task_list(is_player_with_keyboard):
	self.set_visible(!self.visible)
	load_assigned_tasks()
	
func load_assigned_tasks():
	var tasks_assigned = tasks_manager.get_tasks_assigned(-1)
	
	for i in range(0, len(tasks_assigned)):
		if tasks_assigned[i] != null:
			var task_card = get_task_card(i)
			if task_card != null:
				update_task_card_ui(task_card, tasks_assigned[i])	
	
func get_task_card(index):
	var task_card_path = $Control/GridContainer
	if index > 0:
		task_card_path = task_card_path.get_node("TaskCard" + str(index))
	else:
		task_card_path = task_card_path.get_node("TaskCard")
	return task_card_path

func update_task_card_ui(task_card, task):
	var vbox_container = task_card.get_node("Panel/VBoxContainer")
	vbox_container.get_node("GoalLabel").text = "Goal"
	vbox_container.get_node("Goal").text = task.name
	
	if task.reward != null:
		vbox_container.get_node("RewardLabel").text = "Reward"
		var format_string = "%d %s"
		var actual_string = format_string % [task.reward.amount, task.reward.resource]
		vbox_container.get_node("Reward").text = actual_string


func _on_task_manager_new_task_assigned(task):
	load_assigned_tasks()
