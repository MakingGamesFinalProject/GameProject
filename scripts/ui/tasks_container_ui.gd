extends Sprite2D

var tasks_manager = null
var task_container_player = null 
var sound_when_toggled_on = preload("res://sounds/UI Soundpack/MP3/Wood Block1.mp3")
var sound_when_toggled_off = preload("res://sounds/UI Soundpack/MP3/Wood Block2.mp3")

var chosen_card_index = -1

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
	
	if (Input.is_action_just_pressed("menu_press") and self.visible == true and chosen_card_index != -1):
		var curr_task = get_task_card(chosen_card_index)
		curr_task.press_current()
	
	if (Input.is_action_just_pressed("menu_right") and self.visible == true and chosen_card_index != -1):
		var curr_task = get_task_card(chosen_card_index)
		var tasks_assigned = tasks_manager.get_tasks_assigned(-1)
		var last_button = curr_task.is_last_chosen()
		if last_button:
			# choose next card
			if chosen_card_index >= len(tasks_assigned) - 1:
				chosen_card_index = 0
			else:
				chosen_card_index = chosen_card_index + 1
			curr_task = get_task_card(chosen_card_index)
			curr_task.choose_first()
		else:
			curr_task.choose_next()
		
	
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
	var tasks_completed = tasks_manager.get_completed_tasks(-1)
	
	if len(tasks_assigned) == 0 and len(tasks_completed) == 0:
		for i in range(0, 3):
			delete_task_card_ui(get_task_card(i))
	
	if len(tasks_assigned) > 0:
		chosen_card_index = 0
		var curr_task = get_task_card(chosen_card_index)
		curr_task.choose_first()
	
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
	task_card.task_name = task.name
	var vbox_container = task_card.get_node("Panel/VBoxContainer")
	vbox_container.get_node("GoalLabel").text = "Goal"
	vbox_container.get_node("Goal").text = task.name
	
	if task.reward != null:
		vbox_container.get_node("RewardLabel").text = "Reward"
		var format_string = "%d %s"
		var actual_string = format_string % [task.reward.amount, task.reward.resource]
		vbox_container.get_node("Reward").text = actual_string

func delete_task_card_ui(task_card):
	task_card.task_name = ""
	var vbox_container = task_card.get_node("Panel/VBoxContainer")
	vbox_container.get_node("GoalLabel").text = ""
	vbox_container.get_node("Goal").text = ""
	vbox_container.get_node("RewardLabel").text = ""
	vbox_container.get_node("Reward").text = ""
	vbox_container.get_node("Button3").set_visible(false)
	var hbox_container = task_card.get_node("Panel/VBoxContainer/HBoxContainer")
	hbox_container.get_node("Button").set_visible(false)
	hbox_container.get_node("Button2").set_visible(false)
	task_card.get_node("Panel/CompletedSprite").set_visible(false)
	
	task_card.task_completed = false
	
	var current_task_ui_p1 = get_tree().get_nodes_in_group("current_task_ui")[0]
	var current_task_ui_p2 = get_tree().get_nodes_in_group("current_task_ui")[1]
	current_task_ui_p1.text = ""
	current_task_ui_p2.text = ""
	

func _on_task_manager_new_task_assigned(task):
	load_assigned_tasks()
