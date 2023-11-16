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

# Boolean that freezes the player
var frozen := false
@export var freeze_time := 2.0

var screen_size # Size of the game window.

@onready var animation_tree = $AnimationTree
@export var starting_direction : Vector2 = Vector2(0,0.2)

func _ready():
	animation_tree.set("parameters/p1_idle/blend_position", starting_direction)
	animation_tree.set("parameters/p1_walk/blend_position", starting_direction)

func _physics_process(delta):
	# Call the overarching movement function
	checkIfPlayerIsMoving()

	# The following utilizes correct CharacterBody2D movement and enables collisions
	# Update built in velocity property and call built in move_and_collide method
	# Note, there's also a move_and_slide method, which feels less sticky in collisions
	velocity = direction * speed * delta
	update_animation_directions(velocity)
	if velocity != Vector2.ZERO:
		sprite_visibility_update()
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
	if !frozen:
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

func show_helper_button(message):
	print("Showing helper button")
	$InteractibleButtonHelper/Label.text = message
	$InteractibleButtonHelper.show()
	
func hide_helper_button():
	$InteractibleButtonHelper/Label.text = ""
	$InteractibleButtonHelper.hide()
	
# Function called by other objects to freeze the player when the player interacts with something
func player_interaction():
	frozen = true
	await get_tree().create_timer(2.0).timeout
	frozen = false
	
	
func sprite_visibility_update():
	
	hide_all_player_sprites()
	if velocity.x == 0: # no horizontal input
		if velocity.y < 0: # input up
			if is_player_with_keyboard:
				$walk_n_player1.visible = true
			else:
				$walk_n_player2.visible = true
		if 0 < velocity.y: # input down
			if is_player_with_keyboard:
				$walk_s_player1.visible = true
			else:
				$walk_s_player2.visible = true
	if velocity.x < 0: # input left
		if velocity.y == 0: # no vertical input
			if is_player_with_keyboard:
				$walk_w_player1.visible = true
			else:
				$walk_w_player2.visible = true
		if velocity.y < 0: # input up
			if is_player_with_keyboard:
				$walk_nw_player1.visible = true
			else:
				$walk_nw_player2.visible = true
		if 0 < velocity.y: # input down
			if is_player_with_keyboard:
				$walk_sw_player1.visible = true
			else:
				$walk_sw_player2.visible = true
	elif 0 < velocity.x: # input right
		if velocity.y == 0: # no vertical input
			if is_player_with_keyboard:
				$walk_e_player1.visible = true
			else:
				$walk_e_player2.visible = true
		if velocity.y < 0: # input up
			if is_player_with_keyboard:
				$walk_ne_player1.visible = true
			else:
				$walk_ne_player2.visible = true
		if 0 < velocity.y: # input down
			if is_player_with_keyboard:
				$walk_se_player1.visible = true
			else:
				$walk_se_player2.visible = true
	else:
		print("Error: Unable to read inputs")

func hide_all_player_sprites():
	# use is_player_with_keyboard to hide all sprites of that character
	if is_player_with_keyboard:
		$walk_s_player1.visible = false
		$walk_se_player1.visible = false
		$walk_e_player1.visible = false
		$walk_ne_player1.visible = false
		$walk_n_player1.visible = false
		$walk_nw_player1.visible = false
		$walk_w_player1.visible = false
		$walk_sw_player1.visible = false
	else:
		$walk_s_player2.visible = false
		$walk_se_player2.visible = false
		$walk_e_player2.visible = false
		$walk_ne_player2.visible = false
		$walk_n_player2.visible = false
		$walk_nw_player2.visible = false
		$walk_w_player2.visible = false
		$walk_sw_player2.visible = false
	
func update_animation_directions(movement : Vector2):
	if movement != Vector2.ZERO:
		if is_player_with_keyboard:
			animation_tree.set("parameters/p1_idle/blend_position", movement)
			animation_tree.set("parameters/p1_walk/blend_position", movement)
		else:
			animation_tree.set("parameters/p2_idle/blend_position", movement)
			animation_tree.set("parameters/p2_walk/blend_position", movement)
		
		
		
		
		
		
		
		
		
		
		
		
