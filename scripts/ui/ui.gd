extends CanvasLayer

# Set this to 1 if the ui is for the first player, else set it to two
@export var player_number = 1
var tasks_manager = null

func _ready():
	set_player_number()
	set_task_manager()

func set_player_number():
	$PlayerNumber.text = str(player_number)

func set_task_manager():
	tasks_manager = get_tree().get_first_node_in_group("task_manager")
	print("task manager found")
	if tasks_manager:
		tasks_manager.connect(self, "on_task_manager_on_task_completed")

func on_task_manager_on_task_completed(task_uid, objective_indedx, player_number):
	$Notification.text = "Player " + player_number + " completed a task"
