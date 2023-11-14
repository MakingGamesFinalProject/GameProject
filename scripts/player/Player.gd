extends CharacterBody2D
signal toggle_task_list
signal player_2_changes_tab_in_task_list_ui
signal player_2_changes_page_in_task_list_ui

# Keep track if this is player 1 or 2
@export var is_player_with_keyboard := true;

# Speed can be adjusted at will
@export var speed := 8000
# Direction is set by input
var direction := Vector2.ZERO

var screen_size # Size of the game window.

func _physics_process(delta):
	# Call the overarching movement function
	checkIfPlayerIsMoving()

	# The following utilizes correct CharacterBody2D movement and enables collisions
	# Update built in velocity property and call built in move_and_collide method
	# Note, there's also a move_and_slide method, which feels less sticky in collisions
	velocity = direction * speed * delta
	move_and_slide()

	check_if_player_toggles_task_list()
	handle_tab_change_task_list()
	handle_page_change_in_task_list()
	
func check_if_player_toggles_task_list():
	toggle_task_list.emit(is_player_with_keyboard)

func handle_tab_change_task_list():
	var first_tab_opened = Input.is_action_just_pressed("open_first_tab_task_list_p2")
	var second_tab_opened = Input.is_action_just_pressed("open_second_tab_task_list_p2")
	
	if first_tab_opened:
		player_2_changes_tab_in_task_list_ui.emit(1)
	elif second_tab_opened:
		player_2_changes_tab_in_task_list_ui.emit(2)
	
func handle_page_change_in_task_list():
	var next_page = Input.is_action_just_pressed("go_next_page_task_list_p2")
	var prev_page = Input.is_action_just_pressed("go_prev_page_task_list_p2")
	
	if next_page:
		player_2_changes_page_in_task_list_ui.emit("next")
	elif prev_page:
		player_2_changes_page_in_task_list_ui.emit("prev")

func checkIfPlayerIsMoving() -> void:
	if is_player_with_keyboard:
		checkIfPlayerIsMovingWithKeyboard()
	else:
		checkIfPlayerIsMovingWithController()

func checkIfPlayerIsMovingWithKeyboard() -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("move_up_p1"):
		direction.y -= 1
	if Input.is_action_pressed("move_down_p1"):
		direction.y += 1
	if Input.is_action_pressed("move_right_p1"):
		direction.x += 1
	if Input.is_action_pressed("move_left_p1"):
		direction.x -= 1

func checkIfPlayerIsMovingWithController() -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("move_up_p2"):
		direction.y -= 1
	if Input.is_action_pressed("move_down_p2"):
		direction.y += 1
	if Input.is_action_pressed("move_right_p2"):
		direction.x += 1
	if Input.is_action_pressed("move_left_p2"):
		direction.x -= 1
