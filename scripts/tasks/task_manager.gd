extends Node

# We should move this to a separate gd script / json file
var map_of_tasks = [
	{
		"uid": "0x00",
		"name": "Bring the objective from A to B",
		"description": "Go from A to B",
		"objectives": [
			{"type": "position_reached", "position": "A"},
			{"type": "position_reached", "position": "B"}
		]
	}
]

var tasks_completed = []
var tasks = []

func _ready():
	load_tasks()
	
func load_tasks():
	tasks = map_of_tasks
	

	

	
