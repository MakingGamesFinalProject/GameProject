extends CanvasLayer

# Set this to 1 if the ui is for the first player, else set it to two
@export var player_number = 1
var tasks_manager = null
var seconds_to_wait_to_hide_message = 5
var is_task_list_visible = false
var TASKS_PER_PAGE = 5
var current_displayed_page = 0

# if set to true the hbox node shows the array of completed tasks
var hbox_displaying_completed_tasks = false

# nodes references
var task_container_player_1 = null 
var task_container_player_2 = null
var node_ref_next_button = null
var node_ref_prev_button = null

func _ready():
	set_task_manager()
	load_task_into_container(current_displayed_page)
	task_container_player_1 = get_tree().get_nodes_in_group("ui_task_player")[0]
	task_container_player_2 = get_tree().get_nodes_in_group("ui_task_player")[1]
	set_up_task_list_buttons()
	
func set_up_task_list_buttons():
	node_ref_next_button = $TasksContainer/PaginationContainer/Next
	node_ref_prev_button = $TasksContainer/PaginationContainer/Previous
	node_ref_prev_button.disabled = true
	
func set_task_manager():
	tasks_manager = get_tree().get_first_node_in_group("task_manager")

func hide_message_after(seconds):
	await get_tree().create_timer(seconds).timeout
	$Notification.text = ""

func _on_toggle_quest_menu_button_pressed():
	var task_list_container = $TasksListContainer
	if task_list_container != null:
		if task_list_container.visible:
			task_list_container.set_visible(false)
		else:
			task_list_container.set_visible(true)

func load_task_text_in_task_list(node, task):
	var actual_string = ""
	if task.reward != null:
		actual_string = format_task_with_reward(task)
	else:
		actual_string = format_task_without_reward(task)
	assert(actual_string != "", "Could not build task message to display in task list")
	node.text = actual_string
	
func format_task_with_reward(task):
	var format_string = "%s\nGives: %s %d"
	return format_string % [task.name, task.reward.resource, task.reward.amount]
	
func format_task_without_reward(task):
	var format_string = "%s\n"
	return format_string % [task.name]
	
func _on_task_manager_task_completed(task_completed):
	var format_message_to_show = "Player %s completed the task: %s"
	var actual_message_to_show = format_message_to_show % [str(player_number), task_completed.name]
	$Notification.text = actual_message_to_show
	hide_message_after(seconds_to_wait_to_hide_message)

func _on_next_pressed():
	current_displayed_page += 1
	load_task_into_container(current_displayed_page)
	
	var limit = len(tasks_manager.get_tasks(-1))
	var base = (current_displayed_page * tasks_manager.get_page_limit()) + tasks_manager.get_page_limit()
	if  base >= limit:
		node_ref_next_button.disabled = true
		
	if node_ref_prev_button.disabled == true:
		node_ref_prev_button.disabled = false
		node_ref_prev_button.text = "Previous"

func _on_previous_pressed():
	current_displayed_page -= 1
	if current_displayed_page <= 0:
		node_ref_prev_button.disabled = true
		
	if node_ref_next_button.disabled == true:
		node_ref_next_button.disabled = false
		node_ref_next_button.text = "Next"
	load_task_into_container(current_displayed_page)


func _on_player_2_toggle_task_list(is_player_with_keyboard):
	handle_task_list_toggle("toggle_task_list_p2", task_container_player_2)

func _on_player_toggle_task_list(is_player_with_keyboard):
	handle_task_list_toggle("toggle_task_list_p1", task_container_player_1)
	
func handle_task_list_toggle(action, node_ref):
	if task_container_player_1 == null || task_container_player_2 == null:
		assert(false, "One of the task containers is null")
		return;
	var button_pressed = Input.is_action_just_pressed(action)
	if button_pressed && node_ref.visible:
		node_ref.set_visible(false)	
		return
	elif button_pressed && !node_ref.visible:
		node_ref.set_visible(true)
		return

func _on_load_completed_tasks_button_pressed():
	current_displayed_page = 0
	hbox_displaying_completed_tasks = true
	load_task_into_container(current_displayed_page)
	node_ref_prev_button.disabled = true

func _on_load_tasks_button_pressed():
	current_displayed_page = 0
	hbox_displaying_completed_tasks = false
	load_task_into_container(current_displayed_page)
	node_ref_prev_button.disabled = true

# the first tab is the one with all the tasks, the second one just shows the 
# completed ones
func _on_player_player_2_changes_tab_in_task_list_ui(tab):
	if tab == 1:
		current_displayed_page = 0
		hbox_displaying_completed_tasks = false
		load_task_into_container(current_displayed_page)	
		node_ref_prev_button.disabled = true
	elif tab == 2:
		current_displayed_page = 0
		hbox_displaying_completed_tasks = true
		load_task_into_container(current_displayed_page)
		node_ref_prev_button.disabled = true
		

func _on_player_player_2_changes_page_in_task_list_ui(action):
	if !$TasksContainer.visible: return;
	
	if action == "next":
		current_displayed_page += 1
		load_task_into_container(current_displayed_page)
	elif action == "prev" && current_displayed_page > 0:
		current_displayed_page -= 1
		load_task_into_container(current_displayed_page)
		
		
func load_task_into_container(page):
	var tasks = []
	if hbox_displaying_completed_tasks:
		tasks = tasks_manager.get_completed_tasks(page)
	else:
		tasks = tasks_manager.get_tasks(page)
		
	if tasks.is_empty():
		node_ref_prev_button.disabled = true
		node_ref_next_button.disabled = true
	else:
		if node_ref_next_button != null:
			node_ref_next_button.disabled = false
		
	if len(tasks) >= 1:
		load_task_text_in_task_list($TasksContainer/Task1, tasks[0])	
	else:
		$TasksContainer/Task1.text = ""
		
	if len(tasks) >= 2:
		load_task_text_in_task_list($TasksContainer/Task2, tasks[1])	
	else:
		$TasksContainer/Task2.text = ""
		
	if len(tasks) >= 3:
		load_task_text_in_task_list($TasksContainer/Task3, tasks[2])	
	else:
		$TasksContainer/Task3.text = ""
		
	if len(tasks) >= 4:
		load_task_text_in_task_list($TasksContainer/Task4, tasks[3])
	else: 	
		$TasksContainer/Task4.text = ""

