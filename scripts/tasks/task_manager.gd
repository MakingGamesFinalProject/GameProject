extends Node

signal task_completed(task)
signal new_task_assigned(task)
# Complete array of all the tasks in our game, it doesn't get modified
# The uid reflects the index of the task, this makes more easy to identify tasks
# uid stands for "Unique id"
"""const tasks = [
	{
		"uid": 0,
		"name": "Clean Water Filter",
		"reward": null
	},
	{
		"uid": 1,
		"name": "Unclog the Trash Bin",
		"reward": {
			"amount": 40,
			"resource": "Scrap"
		}
	},
	{
		"uid": 2,
		"name": "Fix the Wind Turbines",
		"reward": null
	},
	{
		"uid": 3,
		"name": "Check batteries (Wind Turbines)",
		"reward": {
			"amount": 50,
			"resource": "Energy"
		}
	},
	{
		"uid": 4,
		"name": "Check batteries (Water Filter)",
		"reward": {
			"amount": 50,
			"resource": "Energy"
		}
	},
	{
		"uid": 5,
		"name": "Recycle Trash",
		"reward": {
			"amount": 50,
			"resource": "Scrap"
		}
	}
]"""

# Path to JSON tasks file
var tasks_path = "res://data/tasks.json"

# The loaded JSON file
var tasks := []

# Once a task is completed it gets pushed in "task_completed"
var tasks_completed = []
var tasks_assigned = []
var TASKS_PER_PAGE = 4
var resource_manager = null
var current_task_uid_p1 = -1
var current_task_uid_p2 = -1

func _ready():
	set_resource_manager()
	
	# Get JSON data and save in a variable
	var file = FileAccess.open(tasks_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var tasks_data = json.data["tasks"]
		if typeof(tasks_data) == TYPE_ARRAY:
			tasks = tasks_data
		else:
			print("Unexpected data in tasks")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	
func set_resource_manager():
	resource_manager = get_tree().get_nodes_in_group("resource_manager")[0]
	assert(resource_manager != null, "Resource manager not found")

func is_task_completed(task_uid):
	for t in tasks_completed:
		if t.uid == task_uid:
			return true
	return false

func _on_gift_box_gift_box_picked_up(player_number):
	set_task_as_done(0)

func assign_task(uid): 
	for j in range(0, len(tasks_completed)):
		if tasks_completed[j].uid == uid:
			return
	
	for j in range(0, len(tasks_assigned)):
		if tasks_assigned[j].uid == uid:
			return
			
	for i in range(0, len(tasks)):
		if tasks[i].uid == uid:
			tasks_assigned.push_back(tasks[i])
			new_task_assigned.emit(tasks[i])	

func get_current_task(player):
	if player == 1:
		return current_task_uid_p1
	else:
		return current_task_uid_p2	

func get_task_by_name(name):
	for i in range(0, len(tasks)):
		var task = tasks[i]
		if task.name == name:
			return task
	return null

func set_current_task(uid, player):
	if is_task_completed(uid):
		print("task is completed")
		return;
	
	if player == 1:
		if current_task_uid_p1 != uid:
			current_task_uid_p1 = uid
		else:
			current_task_uid_p1 = -1
	elif player == 2:
		if current_task_uid_p2 != uid:
			current_task_uid_p2 = uid	
		else:
			current_task_uid_p2 = -1	

func set_task_as_done(task_uid):
	var task = tasks[task_uid]
	
	#if the task was already completed then do nothing
	for i in range(0, len(tasks_completed)):
		if task.name == tasks_completed[i].name:
			return
		
	tasks_completed.push_back(task)
	
	var to_be_removed = -1
	for i  in range(0, len(tasks_assigned)):
		if tasks_assigned[i].uid == task_uid:
			to_be_removed = i
	if to_be_removed != -1:
		tasks_assigned.remove_at(to_be_removed)
			
	task_completed.emit(task)
	
	if task.reward != null:
		give_reward_to_user(task.reward.resource, task.reward.amount)
		
func give_reward_to_user(resource, amount):
	if resource == "Energy":
		resource_manager.increase_energy(amount)
	if resource == "Scrap":
		resource_manager.increase_scraps(amount)
	if resource == "Water":
		resource_manager.incrase_water(amount)
	
# It's O(N) but given that we won't have a lot of quests it does the job	
func get_task_by_uid(uid):
	if uid >= tasks.size() || uid < 0:
		# I could not find anything on how to throw an error
		# It was suggested to use assertions instead
		assert(false, "Index out of bound")
	for t in tasks:
		if uid == t.uid:
			return t

func get_tasks(page):
	if page == -1:
		return tasks
	else:
		return load_tasks_page(page)
	
func get_tasks_assigned(page):
	if page == -1:
		return tasks_assigned
	else:
		return load_tasks_from_assigned_tasks(page)	
		
func load_tasks_page(page):
	return load_tasks_from_array(page, tasks)
	
func get_completed_tasks(page):
	if page == -1:
		return tasks_completed
	else:
		return load_tasks_from_completed_tasks(page)	
	
func load_tasks_from_completed_tasks(page):
	return load_tasks_from_array(page, tasks_completed)
	
func load_tasks_from_assigned_tasks(page):
	return load_tasks_from_array(page, tasks_assigned)
	
func load_tasks_from_array(page, array):
	var tasks_in_page = []
	var index_of_first_element_in_page = page * TASKS_PER_PAGE
	
	if index_of_first_element_in_page > len(array):
		return []
		
	var upper_limit = min(index_of_first_element_in_page + TASKS_PER_PAGE, len(array))
	
	for i in range(index_of_first_element_in_page, upper_limit):
		if array[i] != null:
			tasks_in_page.push_back(array[i])	
	
	return tasks_in_page
	
func get_page_limit():
	return TASKS_PER_PAGE
