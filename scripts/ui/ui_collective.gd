extends CanvasLayer

# Create references to the resource labels
@onready var water_label : Label = $MarginContainer/Control/WaterLabel
@onready var energy_label : Label = $MarginContainer/Control/EnergyLabel
@onready var scraps_label : Label = $MarginContainer/Control/ScrapsLabel

func _process(_delta):
	# Update the labels using the autoloaded ResourceManager
	water_label.text = str(ResourceManager.water)
	energy_label.text = str(ResourceManager.energy)
	scraps_label.text = str(ResourceManager.scraps)


func _on_task_manager_task_completed(task):
	var grid_container_for_tasks = $Sprite2D/Control/GridContainer
	var task_cards = grid_container_for_tasks.get_children()
	for t in task_cards:
		if t.name == task.name:
			print("found task completed among cards")
