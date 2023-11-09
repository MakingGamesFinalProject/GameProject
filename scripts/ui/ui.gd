extends CanvasLayer

# Set this to 1 if the ui is for the first player, else set it to two
@export var player_number = 1
var tasks_manager = null
var seconds_to_wait_to_hide_message = 5
var is_task_list_visible = false

func _ready():
	set_task_manager()

func set_task_manager():
	tasks_manager = get_tree().get_first_node_in_group("task_manager")

func hide_message_after(seconds):
	await get_tree().create_timer(seconds).timeout
	$Notification.text = ""

func _on_toggle_quest_menu_button_pressed():
	if $TasksListContainer.visible:
		$TasksListContainer.set_visible(false)
	else:
		$TasksListContainer.set_visible(true)

func _on_task_manager_task_completed(task_completed):
	var format_message_to_show = "Player %s completed the task: %s"
	var actual_message_to_show = format_message_to_show % [str(player_number), task_completed.description]
	$Notification.text = actual_message_to_show
	hide_message_after(seconds_to_wait_to_hide_message)
