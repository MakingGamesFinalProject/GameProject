extends Node

signal task_completed(task)

# Complete array of all the tasks in our game, it doesn't get modified
# The uid reflects the index of the task, this makes more easy to identify tasks
# uid stands for "Unique id"
const tasks = [
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
	}
]

# Once a task is completed it gets pushed in "task_completed"
var tasks_completed = []
var TASKS_PER_PAGE = 4
var resource_manager = null

func _ready():
	set_resource_manager()
	
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

func set_task_as_done(task_uid):
	var task = tasks[task_uid]
	tasks_completed.push_back(task)
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
		
func load_tasks_page(page):
	var tasks_in_page = []
	var index_of_first_element_in_page = page * TASKS_PER_PAGE
	
	if index_of_first_element_in_page > len(tasks):
		return []
		
	var upper_limit = min(index_of_first_element_in_page + TASKS_PER_PAGE, len(tasks))
	
	for i in range(index_of_first_element_in_page, upper_limit):
		if tasks[i] != null:
			tasks_in_page.push_back(tasks[i])	
	
	return tasks_in_page
	
func get_completed_tasks(page):
	if page == -1:
		return tasks_completed
	else:
		return load_tasks_from_completed_tasks(page)	
	
func load_tasks_from_completed_tasks(page):
	var tasks_in_page = []
	var index_of_first_element_in_page = page * TASKS_PER_PAGE
	
	if index_of_first_element_in_page > len(tasks_completed):
		return []
		
	var upper_limit = min(index_of_first_element_in_page + TASKS_PER_PAGE, len(tasks_completed))
	
	for i in range(index_of_first_element_in_page, upper_limit):
		if tasks_completed[i] != null:
			tasks_in_page.push_back(tasks_completed[i])	
	
	return tasks_in_page
	
func get_page_limit():
	return TASKS_PER_PAGE
