extends State

class_name WallState

@onready var ground_state: GroundState = $"../Ground"
@onready var air_state: AirState = $"../Air"
@onready var hit_state: HitState = $"../Hit"


func on_enter() -> void:
	playback.travel("wall_jump")


func state_process(_delta: float) -> void:
	# Handle wall hang time.
	if not owner.wall_hang_timer and owner.can_wall_hang and owner.wall_jumps_taken < PlayerStats.movement.max_wall_jumps:
		owner.wall_hanging = true
		owner.can_wall_hang = true
		owner.velocity.y = 0
		owner.wall_hang_timer = Timer.new()
		owner.add_child(owner.wall_hang_timer)
		owner.wall_hang_timer.one_shot = true
		owner.wall_hang_timer.connect("timeout", owner._on_wall_hang_timer_timeout)
		owner.wall_hang_timer.start(owner.wall_hang_time)
	if owner.is_on_floor():
		next_state = ground_state
		return
	if not owner.is_on_wall_only():
		next_state = air_state
		return



func state_input(_event: InputEvent) -> void:
	if next_state:
		return
	# Handle wall jump.
	if Input.is_action_just_pressed("jump") and owner.wall_jumps_taken < PlayerStats.movement.max_wall_jumps:
		owner.velocity.y = owner.jump_velocity
		owner.wall_jumps_taken += 1
		owner.wall_hanging = false
		if owner.left_wall_detection.is_colliding():
			owner.velocity.x = owner.speed
		elif owner.right_wall_detection.is_colliding():
			owner.velocity.x = -owner.speed
		next_state = air_state
