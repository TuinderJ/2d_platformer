extends CharacterBody2D

class_name Player
## Player character class
##
## This is a class for the player character.

@export_group("Movement")
@export var speed := 250.0 ## Player movement speed.
@export var arial_speed := 8.0 ## Player movement speed while in the air.
@export var sprint_speed_modifier := 1.4 ## Player speed movement while sprint button is pressed.
@export var jump_velocity := -400.0 ## Strength of the jump.
@export var max_jumps := 2 ## Maximum number of jumps, this includes the first jump from the floor.
@export var max_wall_jumps := 2 ## Maximum number of wall jumps before touching the ground again.
@export var wall_hang_time := .25 ## Time that the player will stick to the wall before sliding down.

var can_move := true ## True if the player is allowed to move.

var jumps_taken: int ## Number of jumps taken since leaving the ground.
var wall_jumps_taken: int ## Number of wall jumps taken since leaving the ground.
var speed_modifier := 1.0 ## Base speed modifier.

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity") ## Gravity
var has_gravity := true

var wall_hang_timer: Timer = null ## Timer that's created for sticking to the wall when first colliding with the wall.
var wall_hanging := false ## Boolean stating whether or not the player is currently sticking to the wall before sliding down.
var can_wall_hang := false ## Boolean stating whether or not the player can stick to the wall. This is controlled by the wall_hang_delay and wall_hang_delay timer.

var wall_hang_delay_timer: Timer = null ## Timer that's responsible for not wall grabbing immediately after jumping.
var wall_hang_delay := .2 ## Delay time from leaving the ground before the player can hang on a wall.

var interactables: Array[StaticBody2D]

@export_group("Combat")
@export_range(1, 50, 1, "or_greater") var max_health: int = 1 ## Total health.
@export var damage: int ## Damage dealt to enemies.
@export var invincibility_frames_active: bool ## Controlled by hit animation.

var health: int: ## Current health
	set(new_value):
		health = new_value
		health_updated.emit(health)

@onready var animation_player: AnimationPlayer = $AnimationPlayer ## Animation player for the player.
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D ## Player sprite
@onready var left_wall_detection: RayCast2D = $LeftWallDetection ## Raycast to detect if the player is colliding with the left wall.
@onready var right_wall_detection: RayCast2D = $RightWallDetection ## Raycast to detect if the player is colliding with the right wall.
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var air_state: AirState = $PlayerStateMachine/Air
@onready var hit_state: HitState = $PlayerStateMachine/Hit

signal max_health_updated(new_max_health: int)
signal health_updated(new_health: int)


func _ready() -> void:
	health = max_health

	max_health_updated.emit(max_health)
	health_updated.emit(health)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not wall_hanging and has_gravity:
		velocity.y += gravity * delta

	if not has_gravity:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := 0.0
	if can_move:
		direction = Input.get_axis("move_left", "move_right")

	handle_movement(direction)

	handle_state(direction)

	animation_tree.set("parameters/Run/blend_position", direction)
	animation_tree.set("parameters/Air/blend_position", velocity.y)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sprint"):
		speed_modifier = sprint_speed_modifier
	if event.is_action_released("sprint"):
		speed_modifier = 1
	if event.is_action_pressed("disable_gravity"):
		has_gravity = not has_gravity
	if event.is_action_pressed("interact"):
		if interactables.size() > 0:
			interactables[0].interact()


func handle_movement(direction: float) -> void: ## Handles Velocity based on input direction and current player state.
	# Handle standard movement.
	if direction and not wall_hanging and state_machine.can_move():
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * speed * speed_modifier, speed / 2)
		else:
			velocity.x = move_toward(velocity.x, direction * speed * speed_modifier, arial_speed)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed)


func handle_state(direction: float) -> void: ## handles the state of the player. This controlls animations, i-frames and other things like that.
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


func bounce_on_enemy() -> void: ## If a player's hurtbox contacts an enemy hitbox, this function is called to cause the player to bounce.
	velocity.y = jump_velocity
	state_machine.current_state.next_state = air_state


func take_damage(_damage: int) -> void: ## Take damage when a hitbox (that's not your own) enters your hurtbox.a
	if not _damage or invincibility_frames_active:
		return

	if health > 0:
		health -= _damage
		invincibility_frames_active = true
		state_machine.current_state.next_state = hit_state

	if health < 0:
		health = 0
	if health == 0:
		die()


func die() -> void: ## This gets called when hp is set to 0 or less.
	print_debug("die")
	for i in get_tree().root.get_children():
		for child in i.get_children():
			if child is SceneManager:
				child.transition_to_level("res://levels/level_1.tscn", "fade_to_black", self)
				health = max_health
				return


func _on_wall_hang_timer_timeout() -> void:
	wall_hanging = false
	can_wall_hang = false
	wall_hang_timer.queue_free()
	wall_hang_timer = null


func _on_wall_hang_delay_timer_timeout() -> void:
	can_wall_hang = true
	if wall_hang_delay_timer:
		wall_hang_delay_timer.queue_free()
		wall_hang_delay_timer = null


func _on_interact_area_body_entered(body: Node2D) -> void:
	interactables.push_back(body)
	print_debug(interactables)


func _on_interact_area_body_exited(body: Node2D) -> void:
	for index in interactables.size():
		if interactables[index] == body:
			interactables.pop_at(index)
	print_debug(interactables)
