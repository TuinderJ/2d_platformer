extends CharacterBody2D

class_name Player
## Player character class
##
## This is a class for the player character.

@export_group("Movement")
@export var speed := 250.0 ## Player movement speed.
@export var arial_speed := 12.0 ## Player movement speed while in the air.
@export var sprint_speed_modifier := 1.2 ## Player movement speed while sprint button is pressed.
@export var jump_velocity := -400.0 ## Strength of the jump.
@export var max_jumps := 2 ## Maximum number of jumps, this includes the first jump from the floor.
@export var max_wall_jumps := 1 ## Maximum number of wall jumps before touching the ground again.
@export var wall_hang_time := .25 ## Time that the player will stick to the wall before sliding down.

var jumps_taken := max_jumps ## Number of jumps taken since leaving the ground.
var wall_jumps_taken := max_wall_jumps ## Number of wall jumps taken since leaving the ground.
var speed_modifier := 1.0 ## Base speed modifier.

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity") ## Gravity

var wall_hang_timer: Timer = null ## Timer that's created for sticking to the wall when first colliding with the wall.
var wall_hanging := false ## Boolean stating whether or not the player is currently sticking to the wall before sliding down.
var can_wall_hang := false ## Boolean stating whether or not the player can stick to the wall. This is controlled by the wall_hang_delay and wall_hang_delay timer.

var wall_hang_delay_timer: Timer = null ## Timer that's responsible for not wall grabbing immediately after jumping.
var wall_hang_delay: float = .2 ## Delay time from leaving the ground before the player can hang on a wall.

@onready var animation_player: AnimationPlayer = $AnimationPlayer ## Animation player for the player.
@onready var sprite: Sprite2D = $Sprite2D ## Player sprite
@onready var left_wall_detection: RayCast2D = $LeftWallDetection ## Raycast to detect if the player is colliding with the left wall.
@onready var right_wall_detection: RayCast2D = $RightWallDetection ## Raycast to detect if the player is colliding with the right wall.


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not wall_hanging:
		velocity.y += gravity * delta
	if is_on_floor():
		jumps_taken = 0
		wall_jumps_taken = 0
	if not is_on_wall_only():
		if wall_hang_timer:
			wall_hanging = false
			wall_hang_timer.queue_free()
			wall_hang_timer = null
	if is_on_floor() and wall_hang_delay_timer:
			can_wall_hang = false
			wall_hang_delay_timer.queue_free()
			wall_hang_delay_timer = null

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")

	handle_movement(direction)

	handle_animations(direction)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sprint"):
		speed_modifier = sprint_speed_modifier
	if event.is_action_released("sprint"):
		speed_modifier = 1


func handle_movement(direction: float) -> void: ## Handles Velocity based on input direction and current player state.
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jumps_taken < max_jumps and not wall_hanging:
		velocity.y = jump_velocity
		jumps_taken += 1
		wall_hang_delay_timer = Timer.new()
		add_child(wall_hang_delay_timer)
		wall_hang_delay_timer.one_shot = true
		wall_hang_delay_timer.connect("timeout", _on_wall_hang_delay_timer_timeout)
		wall_hang_delay_timer.start(wall_hang_delay)
		can_wall_hang = false

	# Handle wall hang time.
	if is_on_wall_only() and not wall_hang_timer and not wall_hanging and can_wall_hang and wall_jumps_taken < max_wall_jumps and direction:
		wall_hanging = true
		can_wall_hang = true
		velocity.y = 0
		wall_hang_timer = Timer.new()
		add_child(wall_hang_timer)
		wall_hang_timer.one_shot = true
		wall_hang_timer.connect("timeout", _on_wall_hang_timer_timeout)
		wall_hang_timer.start(wall_hang_time)

	# Handle wall jump.
	if is_on_wall_only() and Input.is_action_just_pressed("jump") and wall_jumps_taken < max_wall_jumps:
		velocity.y = jump_velocity
		wall_jumps_taken += 1
		if left_wall_detection.is_colliding():
			velocity.x = speed
		elif right_wall_detection.is_colliding():
			velocity.x = -speed

	# Handle standard movement.
	if direction and not wall_hanging:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * speed * speed_modifier, speed / 2)
		else:
			velocity.x = move_toward(velocity.x, direction * speed * speed_modifier, arial_speed)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, speed)


func handle_animations(direction: float) -> void: ## Given an input direction, updates the animation of the player based on the players current state.
	# Direction to face based on input direction or direction moving
	if direction and not wall_hanging:
		if direction < 0:
			sprite.flip_h = true
		elif direction > 0:
			sprite.flip_h = false
	else:
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true

	# Animations
	if is_on_wall_only() and can_wall_hang and direction:
		if left_wall_detection.is_colliding():
			sprite.flip_h = true
		elif right_wall_detection.is_colliding():
			sprite.flip_h = false
		animation_player.play("wall_jump")
		return
	if is_on_floor() and not direction:
		animation_player.play("idle")
		return
	if is_on_floor() and direction:
		animation_player.play("run")
		return
	if velocity.y <= 0 and jumps_taken > 1:
		animation_player.play("double_jump")
		return
	if velocity.y <= 0:
		animation_player.play("jump")
		return
	if velocity.y > 0:
		animation_player.play("fall")
		return


func _on_wall_hang_timer_timeout() -> void:
	wall_hanging = false


func _on_wall_hang_delay_timer_timeout() -> void:
	can_wall_hang = true
