extends Node

signal task_completed(task)

# Complete array of all the tasks in our game, it doesn't get modified
# The uid reflects the index of the task, this makes more easy to identify tasks
const tasks = [
	{
		"uid": 0,
		"name": "The most wonderful time of the year",
		"description": "Pick up the gift"
	}
]

# Once a task is completed it gets pushed in "task_completed"
var tasks_completed = []

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
	

func get_tasks():
	return tasks

func get_completed_tasks():
	return tasks_completed
