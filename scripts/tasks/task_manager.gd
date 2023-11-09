extends Node

signal task_completed

# Dizionario delle task
var tasks = [
	{
		"uid": 0,
		"name": "The most wonderful time of the year",
		"description": "Pick up the gift"
	}
]

# Once a task is completed it gets pushed in "task_completed"
var tasks_completed = []

func set_task_as_done(task_uid):
	tasks_completed.push_back(tasks[task_uid])
	task_completed.emit(tasks[task_uid])

func is_task_completed(task_uid):
	for t in tasks_completed:
		if t.uid == task_uid:
			return true
	return false

func get_completed_tasks():
	return tasks_completed

func _on_gift_box_gift_box_picked_up(player_number):
	set_task_as_done(0)

func get_tasks():
	return tasks
