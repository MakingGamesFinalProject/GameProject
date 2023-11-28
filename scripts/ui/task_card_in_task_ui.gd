extends Control

var task_manager = null
var assign_task_p1_button_ref = null
var assign_task_p2_button_ref = null
var goal_text_ref = null
var task_name = ""
@export var task_completed = false

func _ready():
	task_manager = get_tree().get_first_node_in_group("task_manager")
	assign_task_p1_button_ref = $Panel/Button
	assign_task_p2_button_ref = $Panel/Button2
	goal_text_ref = $Panel/VBoxContainer/GoalLabel
	assert(assign_task_p1_button_ref != null, "Button 1 not found");
	assert(assign_task_p2_button_ref != null, "Button 2 not found");
	assign_task_p1_button_ref.set_visible(false)
	assign_task_p2_button_ref.set_visible(false)

func _process(delta):
	if !goal_text_ref.text.is_empty():
		assign_task_p1_button_ref.set_visible(true)
		assign_task_p2_button_ref.set_visible(true)
	if !task_completed:
		disable_buttons_if_task_is_completed()
		
func disable_buttons_if_task_is_completed():
	var task = task_manager.get_task_by_name(task_name)
	if task != null && task_manager.is_task_completed(task.uid):
		task_completed = true
		assign_task_p1_button_ref.set_disabled(true)
		assign_task_p2_button_ref.set_disabled(true)
		$Panel/CompletedSprite.set_visible(true)

#Set this task active for player 1
func _on_button_pressed():
	var task_name = $Panel/VBoxContainer/Goal.text
	var task = task_manager.get_task_by_name(task_name)
	
	#we need to check if the task is already assigned to the other user
	if task != null && task_manager.get_current_task(2) != task.uid:
		task_manager.set_current_task(task.uid, 1)
		var current_task_ui_p1 = get_tree().get_nodes_in_group("current_task_ui")[0]
		current_task_ui_p1.text = task.name
		$Panel/Button2.set_disabled(true)

#Set this task active for player 2
func _on_button_2_pressed():
	var task_name = $Panel/VBoxContainer/Goal.text
	var task = task_manager.get_task_by_name(task_name)
	#we need to check if the task is already assigned to the other user
	if task != null && task_manager.get_current_task(1) != task.uid:
		task_manager.set_current_task(task.uid, 2)
		var current_task_ui_p1 = get_tree().get_nodes_in_group("current_task_ui")[1]
		current_task_ui_p1.text = task.name
		$Panel/Button2.set_disabled(true)
