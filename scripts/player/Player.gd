extends CharacterBody2D
signal toggle_task_list
signal player_2_changes_tab_in_task_list_ui
signal player_2_changes_page_in_task_list_ui
# How fast the player moves in meters per second.
@export var speed = 400
@export var is_player_with_keyboard = true; 

var screen_size # Size of the game window.

func _physics_process(delta):
	checkIfPlayerIsMoving(delta)
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

func checkIfPlayerIsMoving(delta):
	# We create a local variable to store the input direction.
	var velocity = Vector2.ZERO
	
	if is_player_with_keyboard:
		velocity = checkIfPlayerIsMovingWithKeyboard()
	else:
		velocity = checkIfPlayerIsMovingWithController()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta	

func checkIfPlayerIsMovingWithKeyboard():
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right_p1"):
		velocity.x += 1
	if Input.is_action_pressed("move_left_p1"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down_p1"):
		velocity.y += 1
	if Input.is_action_pressed("move_up_p1"):
		velocity.y -= 1 
	
	return velocity
		
func checkIfPlayerIsMovingWithController():
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right_p2"):
		velocity.x += 1
	if Input.is_action_pressed("move_left_p2"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down_p2"):
		velocity.y += 1
	if Input.is_action_pressed("move_up_p2"):
		velocity.y -= 1 
	return velocity

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(_body):
	print("on body entered")
