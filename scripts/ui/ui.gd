extends CanvasLayer

# Set this to 1 if the ui is for the first player, else set it to two
@export var player_number = 1
var tasks_manager = null
var seconds_to_wait_to_hide_message = 5
var is_task_list_visible = false
var TASKS_PER_PAGE = 5
var current_displayed_page = 0

func _ready():
	set_task_manager()
	load_task_into_container(current_displayed_page)

func set_task_manager():
	tasks_manager = get_tree().get_first_node_in_group("task_manager")

func hide_message_after(seconds):
	await get_tree().create_timer(seconds).timeout
	$Notification.text = ""

func _on_toggle_quest_menu_button_pressed():
	var tasks = tasks_manager.get_tasks()
	var task_list_container = $TasksListContainer
	if task_list_container != null:
		if task_list_container.visible:
			task_list_container.set_visible(false)
		else:
			task_list_container.set_visible(true)
			
func load_task_into_container(page):
	var tasks = tasks_manager.get_tasks(page)
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
	
func load_task_text_in_task_list(node, task):
	var format_string = "%s\n%s"
	var actual_string = format_string % [task.name, task.description]
	node.text = actual_string

func _on_task_manager_task_completed(task_completed):
	var format_message_to_show = "Player %s completed the task: %s"
	var actual_message_to_show = format_message_to_show % [str(player_number), task_completed.description]
	$Notification.text = actual_message_to_show
	hide_message_after(seconds_to_wait_to_hide_message)


func _on_next_pressed():
	current_displayed_page += 1
	load_task_into_container(current_displayed_page)
	
	var limit = len(tasks_manager.get_tasks(-1))
	var base = (current_displayed_page * tasks_manager.get_page_limit()) + tasks_manager.get_page_limit()
	if  base >= limit:
		$TasksContainer/PaginationContainer/Next.text = ""
		$TasksContainer/PaginationContainer/Next.disabled = true
		
	if $TasksContainer/PaginationContainer/Previous.disabled == true:
		$TasksContainer/PaginationContainer/Previous.disabled = false
		$TasksContainer/PaginationContainer/Previous.text = "Previous"


func _on_previous_pressed():
	current_displayed_page -= 1
	if current_displayed_page <= 0:
		$TasksContainer/PaginationContainer/Previous.disabled = true
		$TasksContainer/PaginationContainer/Previous.text = ""
		
	if $TasksContainer/PaginationContainer/Next.disabled == true:
		$TasksContainer/PaginationContainer/Next.disabled = false
		$TasksContainer/PaginationContainer/Next.text = "Next"
	load_task_into_container(current_displayed_page)
