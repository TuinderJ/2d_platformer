extends State

class_name GroundState

@onready var air_state: AirState = $"../Air"
@onready var hit: HitState = $"../Hit"


func state_input(_event: InputEvent) -> void:
	if next_state:
		return
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		owner.velocity.y = owner.jump_velocity
		owner.jumps_taken += 1

		next_state = air_state
		return

func on_enter() -> void:
	playback.travel("Run")
	owner.jumps_taken = 0
	owner.wall_jumps_taken = 0

	if owner.wall_hang_delay_timer:
		owner.can_wall_hang = false
		owner.wall_hang_delay_timer.queue_free()
		owner.wall_hang_delay_timer = null

	if owner.wall_hang_timer:
		owner.wall_hang_timer.queue_free()
		owner.wall_hang_timer = null

