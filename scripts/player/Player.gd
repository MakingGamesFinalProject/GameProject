extends CharacterBody2D

# Keep track if this is player 1 or 2
@export var is_player_with_keyboard := true;

# Speed can be adjusted at will
@export var speed := 8000
# Direction is set by input
var direction := Vector2.ZERO

func _physics_process(delta):
	# Call the overarching movement function
	checkIfPlayerIsMoving()

	# The following utilizes correct CharacterBody2D movement and enables collisions
	# Update built in velocity property and call built in move_and_collide method
	# Note, there's also a move_and_slide method, which feels less sticky in collisions
	velocity = direction * speed * delta
	move_and_slide()

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
