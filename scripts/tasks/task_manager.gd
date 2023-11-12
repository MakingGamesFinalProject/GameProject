extends Node

signal task_completed(task)

# Complete array of all the tasks in our game, it doesn't get modified
# The uid reflects the index of the task, this makes more easy to identify tasks
# uid stands for "Unique id"
const tasks = [
	{
		"uid": 0,
		"name": "Christmas holiday",
		"description": "Pick up the gift"
	},
	{
		"uid": 1,
		"name": "Christmas holiday 2",
		"description": "Pick up the gift"
	},
	{
		"uid": 2,
		"name": "Christmas holiday 3",
		"description": "Pick up the gift"
	},
	{
		"uid": 3,
		"name": "Christmas holiday 4",
		"description": "Pick up the gift"
	},
	{
		"uid": 4,
		"name": "Christmas holiday 5",
		"description": "Pick up the gift"
	},
	{
		"uid": 5,
		"name": "Christmas holiday 6",
		"description": "Pick up the gift"
	},
]

# Once a task is completed it gets pushed in "task_completed"
var tasks_completed = []
var TASKS_PER_PAGE = 4

func is_task_completed(task_uid):
	for t in tasks_completed:
		if t.uid == task_uid:
			return true
	return false

func _on_gift_box_gift_box_picked_up(player_number):
	set_task_as_done(0)

func set_task_as_done(task_uid):
	tasks_completed.push_back(tasks[task_uid])
	task_completed.emit(tasks[task_uid])

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
		assert(false, "Index out of bound")	
		
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
		assert(false, "Index out of bound")	
		
	var upper_limit = min(index_of_first_element_in_page + TASKS_PER_PAGE, len(tasks_completed))
	
	for i in range(index_of_first_element_in_page, upper_limit):
		if tasks_completed[i] != null:
			tasks_in_page.push_back(tasks_completed[i])	
	
	return tasks_in_page
	
func get_page_limit():
	return TASKS_PER_PAGE
