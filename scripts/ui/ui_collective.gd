extends CanvasLayer

# Create references to the resource labels
@onready var water_label : Label = $MarginContainer/Control/WaterResourceCounter/WaterLabel
@onready var energy_label : Label = $MarginContainer/Control/EnergyResourceCounter/EnergyLabel
@onready var scraps_label : Label = $MarginContainer/Control/ScrapsResourceCounter/ScrapsLabel
@onready var water_animation_counter_timer: Timer = $MarginContainer/Control/WaterResourceCounter/WaterAnimationTimer
@onready var energy_animation_counter_timer: Timer = $MarginContainer/Control/EnergyResourceCounter/EnergyAnimationTimer
@onready var scraps_animation_counter_timer: Timer = $MarginContainer/Control/ScrapsResourceCounter/ScrapsAnimationTimer
@export var delay_to_increase_resource_during_animation_in_seconds = 0.02
var is_options_open = false
func _ready():
	ResourceManager.on_resource_increased.connect(animate_resource_incrase)
	water_animation_counter_timer.wait_time = $MarginContainer/Control/WaterResourceCounter/WaterTexture2/AnimationPlayer.get_animation("resource_up").length - 0.2
	water_animation_counter_timer.timeout.connect(animate_resource_block_water)
	energy_animation_counter_timer.wait_time = $MarginContainer/Control/EnergyResourceCounter/EnergyTexture2/AnimationPlayer.get_animation("resource_up").length - 0.2
	energy_animation_counter_timer.timeout.connect(animate_resource_block_energy)
	scraps_animation_counter_timer.wait_time = $MarginContainer/Control/ScrapsResourceCounter/ScrapsTexture2/AnimationPlayer.get_animation("resource_up").length - 0.2
	scraps_animation_counter_timer.timeout.connect(animate_resource_block_scraps)
	water_label.text = "0"
	energy_label.text = "0"
	scraps_label.text = "0"

func _process(delta):
	if(Input.is_action_just_pressed("toggle_pause")):
		if is_options_open:
			is_options_open = false
			$DarkBackgroundForPause.set_visible(false)
			$options_ui.set_visible(false)
		else:
			is_options_open = true
			$DarkBackgroundForPause.set_visible(true)
			$options_ui.set_visible(true)
	
func _on_task_manager_task_completed(task):
	var grid_container_for_tasks = $Sprite2D/Control/GridContainer
	var task_cards = grid_container_for_tasks.get_children()
	for t in task_cards:
		if t.name == task.name:
			print("found task completed among cards")

func animate_resource_incrase(resource, amount_increased):
	if resource == "water":
		$MarginContainer/Control/WaterResourceCounter/WaterTexture2/AnimationPlayer.play("resource_up")
		water_animation_counter_timer.start()
		var current_water_resource = int(water_label.text)
		var new_value = current_water_resource + amount_increased
		
		while(current_water_resource < new_value):
			current_water_resource += 1
			water_label.text = str(current_water_resource)
			await get_tree().create_timer(delay_to_increase_resource_during_animation_in_seconds).timeout
	elif resource == "energy":
		$MarginContainer/Control/EnergyResourceCounter/EnergyTexture2/AnimationPlayer.play("resource_up")
		energy_animation_counter_timer.start()
		var current_resource = int(energy_label.text)
		var new_value = current_resource + amount_increased
		
		while(current_resource < new_value):
			current_resource += 1
			energy_label.text = str(current_resource)
			await get_tree().create_timer(delay_to_increase_resource_during_animation_in_seconds).timeout
		
	elif resource == "scraps":
		$MarginContainer/Control/ScrapsResourceCounter/ScrapsTexture2/AnimationPlayer.play("resource_up")
		scraps_animation_counter_timer.start()
		var current_resource = int(scraps_label.text)
		var new_value = current_resource + amount_increased
		
		while(current_resource < new_value):
			current_resource += 1
			scraps_label.text = str(current_resource)
			await get_tree().create_timer(delay_to_increase_resource_during_animation_in_seconds).timeout
	else:
		assert(false, "Resource not valid, please pass one of the following strings [water, scraps, energy]")


func animate_resource_block_water():
	$MarginContainer/Control/WaterResourceCounter/AnimationPlayer.play("resource_counter_up")

func animate_resource_block_energy():
	print("Animating enegy")
	$MarginContainer/Control/EnergyResourceCounter/AnimationPlayer.play("resource_counter_up")

func animate_resource_block_scraps():
	$MarginContainer/Control/ScrapsResourceCounter/AnimationPlayer.play("resource_counter_up")
