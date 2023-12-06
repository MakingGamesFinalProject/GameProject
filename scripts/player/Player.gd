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
@onready var state_machine = animation_tree.get("parameters/playback")
@export var starting_direction : Vector2 = Vector2(0,0.2)

var last_dir := "s"

func _ready():
	update_animation_directions(Vector2(0, 0.2))
	sprite_visibility_update()
	
	if is_player_with_keyboard:
		$walk_s_player1.visible = true
		state_machine.travel("p1_idle")
	else:
		$walk_s_player2.visible = true
		state_machine.travel("p2_idle")

func _physics_process(delta):
	# Limit player positioning
	if global_position.x <= -3424:
		global_position.x = -3424
	elif global_position.x >= 3424:
		global_position.x = 3424
	if global_position.y <= -2411:
		global_position.y = -2411
	elif global_position.y >= 2561:
		global_position.y = 2561

	# Call the overarching movement function
	checkIfPlayerIsMoving()

	# The following utilizes correct CharacterBody2D movement and enables collisions
	# Update built in velocity property and call built in move_and_collide method
	# Note, there's also a move_and_slide method, which feels less sticky in collisions
	velocity = direction * speed * delta
	update_animation_directions(direction)
	sprite_visibility_update()
	move_and_slide()
	walk_and_idle_input()

	check_if_player_toggles_task_list()
	handle_tab_change_task_list()
	handle_page_change_in_task_list()
	
func check_if_player_toggles_task_list():
	var toggle_button_pressed_p1 = Input.is_action_just_pressed("toggle_task_list_p1")
	var toggle_button_pressed_p2 = Input.is_action_just_pressed("toggle_task_list_p2")
	if toggle_button_pressed_p1 || toggle_button_pressed_p2:
		toggle_task_list.emit(is_player_with_keyboard == true)

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
	direction = direction.normalized()

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
	direction = direction.normalized()

func show_helper_button(message):
	print("Showing helper button")
	$InteractibleButtonHelper/Label.text = message
	$InteractibleButtonHelper.show()
	
func hide_helper_button():
	$InteractibleButtonHelper/Label.text = ""
	$InteractibleButtonHelper.hide()
	
func player_freeze():
	frozen = true
	direction = Vector2.ZERO

func player_unfreeze():
	frozen = false
	
# Function called by other objects to freeze the player when the player interacts with something
func player_interaction():
	player_freeze()
	play_interaction_animation()
	await get_tree().create_timer(2.0).timeout
	player_unfreeze()
	
	#######################################################################################################################################
	##################### ANIMATION RELATED ###############################################################################################
	#######################################################################################################################################
	
func sprite_visibility_update():
	
	hide_all_player_sprites()
	if (direction.x == 0) && (direction != Vector2.ZERO): # no horizontal input but there is vertical input
		if direction.y < 0: # input up
			last_dir = "n"
			if is_player_with_keyboard:
				$walk_n_player1.visible = true
			else:
				$walk_n_player2.visible = true
		if 0 < velocity.y: # input down
			last_dir = "s"
			if is_player_with_keyboard:
				$walk_s_player1.visible = true
			else:
				$walk_s_player2.visible = true
	elif direction.x < 0: # input left
		if direction.y == 0: # no vertical input
			last_dir = "w"
			if is_player_with_keyboard:
				$walk_w_player1.visible = true
			else:
				$walk_w_player2.visible = true
		if direction.y < 0: # input up
			last_dir = "nw"
			if is_player_with_keyboard:
				$walk_nw_player1.visible = true
			else:
				$walk_nw_player2.visible = true
		if 0 < direction.y: # input down
			last_dir = "sw"
			if is_player_with_keyboard:
				$walk_sw_player1.visible = true
			else:
				$walk_sw_player2.visible = true
	elif 0 < direction.x: # input right
		if direction.y == 0: # no vertical input
			last_dir = "e"
			if is_player_with_keyboard:
				$walk_e_player1.visible = true
			else:
				$walk_e_player2.visible = true
		if direction.y < 0: # input up
			last_dir = "ne"
			if is_player_with_keyboard:
				$walk_ne_player1.visible = true
			else:
				$walk_ne_player2.visible = true
		if 0 < direction.y: # input down
			last_dir = "se"
			if is_player_with_keyboard:
				$walk_se_player1.visible = true
			else:
				$walk_se_player2.visible = true
	else:	#idle
		if is_player_with_keyboard:
			match last_dir:
				"s":
					$idle_s_player1.visible = true
				"se":
					$idle_se_player1.visible = true
				"e":
					$idle_e_player1.visible = true
				"ne":
					$idle_ne_player1.visible = true
				"n":
					$idle_n_player1.visible = true
				"nw":
					$idle_nw_player1.visible = true
				"w":
					$idle_w_player1.visible = true
				"sw":
					$idle_sw_player1.visible = true
				_:
					print("ERROR: no idle player sprite found in player")
		else:
			match last_dir:
				"s":
					$idle_s_player2.visible = true
				"se":
					$idle_se_player2.visible = true
				"e":
					$idle_e_player2.visible = true
				"ne":
					$idle_ne_player2.visible = true
				"n":
					$idle_n_player2.visible = true
				"nw":
					$idle_nw_player2.visible = true
				"w":
					$idle_w_player2.visible = true
				"sw":
					$idle_sw_player2.visible = true
				_:
					print("ERROR: no idle player sprite found in player")
		

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
		$idle_s_player1.visible = false
		$idle_se_player1.visible = false
		$idle_e_player1.visible = false
		$idle_ne_player1.visible = false
		$idle_n_player1.visible = false
		$idle_nw_player1.visible = false
		$idle_w_player1.visible = false
		$idle_sw_player1.visible = false
	else:
		$walk_s_player2.visible = false
		$walk_se_player2.visible = false
		$walk_e_player2.visible = false
		$walk_ne_player2.visible = false
		$walk_n_player2.visible = false
		$walk_nw_player2.visible = false
		$walk_w_player2.visible = false
		$walk_sw_player2.visible = false
		$idle_s_player2.visible = false
		$idle_se_player2.visible = false
		$idle_e_player2.visible = false
		$idle_ne_player2.visible = false
		$idle_n_player2.visible = false
		$idle_nw_player2.visible = false
		$idle_w_player2.visible = false
		$idle_sw_player2.visible = false
	
func update_animation_directions(move_input):
	if move_input != Vector2.ZERO:
		if is_player_with_keyboard:
			animation_tree.set("parameters/p1_idle/blend_position", move_input)
			animation_tree.set("parameters/p1_walk/blend_position", move_input)
		else:
			animation_tree.set("parameters/p2_idle/blend_position", move_input)
			animation_tree.set("parameters/p2_walk/blend_position", move_input)
		
func walk_and_idle_input():
	if frozen:
		return

	if direction != Vector2.ZERO:
		if is_player_with_keyboard:
			state_machine.travel("p1_walk")
		else:
			state_machine.travel("p2_walk")
	else:
		if is_player_with_keyboard:
			state_machine.travel("p1_idle")
		else:
			state_machine.travel("p2_idle")
			
func play_interaction_animation():
	if is_player_with_keyboard:
		state_machine.travel("interaction_p1")
	else:
		state_machine.travel("interaction_p2")
		
		
		
		
		
		
		
		
