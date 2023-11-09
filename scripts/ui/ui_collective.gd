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
