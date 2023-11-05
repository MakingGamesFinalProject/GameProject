extends Node
signal objective_completed(task_uid, objective_index, player_number, description)
signal task_completed
# We should move this to a separate gd script / json file
var map_of_tasks = [
	{
		"uid": "0x00",
		"name": "The most wonderful time of the year",
		"description": "Pick up the gift and go home",
		"objectives": [
			{"type": "item_picked", "item": "gift", "description": "Take the gift"},
			{"type": "position_reached", "position": "home", "description": "Bring the gift home"}
		]
	}
]

var objectives_completed_by_task_uid = {1: {}, 2: {}}
var tasks_completed = []
var tasks = []

func _ready():
	load_tasks()

#	this function should read the tasks from a json or a txt but for now
#	I'll keep it simple
func load_tasks():
	tasks = map_of_tasks
	
func set_objective_as_done_for_task(task_uid, objective_index, player_number):
	for task in map_of_tasks:
		if task.uid == task_uid:
			if task_is_in_player_task_list(player_number, task_uid):
				update_task_in_task_list_of_player(player_number, task, objective_index)
			else:
				add_task_in_task_list_of_player(task_uid, objective_index, player_number)
				objective_completed.emit(task_uid, objective_index, player_number, task.objectives[objective_index].description)
				
func task_is_in_player_task_list(player_number, task_uid):
	return objectives_completed_by_task_uid[player_number].has(task_uid)
				
func update_task_in_task_list_of_player(player_number, task, objective_index):
	objectives_completed_by_task_uid[player_number][task.uid] = task.objectives[objective_index]
	if len(objectives_completed_by_task_uid[player_number][task.uid]) == len(task.objectives):
		tasks_completed.push_back(task.uid)		
		task_completed.emit(task.uid, objective_index, player_number)
		
func add_task_in_task_list_of_player(task_uid, objective_index, player_number):
		objectives_completed_by_task_uid[player_number][task_uid] = [objective_index]

func get_completed_tasks():
	return tasks_completed

func get_objectives_completed_by_uid_for_player(uid, player_number):
	return objectives_completed_by_task_uid[player_number][uid]
	
#Every param is hardcoded here but I'll change that after the prototype
func _on_gift_box_gift_box_picked_up(player_number):
	set_objective_as_done_for_task("0x00", 0, player_number)
	
func get_tasks():
	return map_of_tasks
