extends Sprite2D

var tasks_manager = null
var task_container_player = null 
var sound_when_toggled_on = preload("res://sounds/UI Soundpack/MP3/Wood Block1.mp3")
var sound_when_toggled_off = preload("res://sounds/UI Soundpack/MP3/Wood Block2.mp3")

func _ready():
	var tree = get_tree()
	tasks_manager = tree.get_first_node_in_group("task_manager")
	task_container_player = tree.get_first_node_in_group("ui_task_player")
	assert(tasks_manager != null, "Task manager not found")
	assert(task_container_player != null, "Task container reference not found")
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_assigned_tasks()
	
func _process(delta):
	check_for_ui_toggle()	
	
func check_for_ui_toggle():
	var toggle_button_pressed_p1 = Input.is_action_just_pressed("toggle_task_list_p1")
	var toggle_button_pressed_p2 = Input.is_action_just_pressed("toggle_task_list_p2")
	if toggle_button_pressed_p1 || toggle_button_pressed_p2:
		get_tree().paused = !get_tree().paused
		var parent = self.get_parent()
		var audio_player = parent.get_node("ToggleSound")
		self.set_visible(!self.visible)
		var current_task_ui = parent.get_node("CurrentTaskUI")
		if self.visible:
			current_task_ui.set_visible(false)
			audio_player.stream = sound_when_toggled_off
			audio_player.play()
		else:
			current_task_ui.set_visible(true)
			audio_player.stream = sound_when_toggled_on
			audio_player.play()
		var canvas_layer = self.get_parent()
		var dark_background = canvas_layer.get_node("DarkBackgroundForPause")
		dark_background.set_visible(!dark_background.visible)
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
