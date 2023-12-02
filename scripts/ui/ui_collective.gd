extends CanvasLayer

# Create references to the resource labels
@onready var water_label : Label = $MarginContainer/Control/WaterResourceCounter/WaterLabel
@onready var energy_label : Label = $MarginContainer/Control/EnergyResourceCounter/EnergyLabel
@onready var scraps_label : Label = $MarginContainer/Control/ScrapsResourceCounter/ScrapsLabel
@onready var water_animation_counter_timer: Timer = $MarginContainer/Control/WaterResourceCounter/WaterAnimationTimer
@onready var energy_animation_counter_timer: Timer = $MarginContainer/Control/EnergyResourceCounter/EnergyAnimationTimer
@onready var scraps_animation_counter_timer: Timer = $MarginContainer/Control/ScrapsResourceCounter/ScrapsAnimationTimer

func _ready():
	ResourceManager.on_resource_increased.connect(animate_resource_incrase)
	water_animation_counter_timer.wait_time = $MarginContainer/Control/WaterResourceCounter/WaterTexture2/AnimationPlayer.get_animation("resource_up").length - 0.2
	water_animation_counter_timer.timeout.connect(animate_resource_block_water)
	energy_animation_counter_timer.wait_time = $MarginContainer/Control/EnergyResourceCounter/EnergyTexture2/AnimationPlayer.get_animation("resource_up").length - 0.2
	energy_animation_counter_timer.timeout.connect(animate_resource_block_energy)
	scraps_animation_counter_timer.wait_time = $MarginContainer/Control/ScrapsResourceCounter/ScrapsTexture2/AnimationPlayer.get_animation("resource_up").length - 0.2
	scraps_animation_counter_timer.timeout.connect(animate_resource_block_scraps)

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

func animate_resource_incrase(resource):
	if resource == "water":
		$MarginContainer/Control/WaterResourceCounter/WaterTexture2/AnimationPlayer.play("resource_up")
		water_animation_counter_timer.start()
	elif resource == "energy":
		$MarginContainer/Control/EnergyResourceCounter/EnergyTexture2/AnimationPlayer.play("resource_up")
		energy_animation_counter_timer.start()
	elif resource == "scraps":
		$MarginContainer/Control/ScrapsResourceCounter/ScrapsTexture2/AnimationPlayer.play("resource_up")
		scraps_animation_counter_timer.start()
	else:
		assert(false, "Resource not valid, please pass one of the following strings [water, scraps, energy]")

func animate_resource_block_water():
	$MarginContainer/Control/WaterResourceCounter/AnimationPlayer.play("resource_counter_up")

func animate_resource_block_energy():
	print("Animating enegy")
	$MarginContainer/Control/EnergyResourceCounter/AnimationPlayer.play("resource_counter_up")

func animate_resource_block_scraps():
	$MarginContainer/Control/ScrapsResourceCounter/AnimationPlayer.play("resource_counter_up")
