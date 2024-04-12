extends State

class_name AirState

@onready var ground_state: GroundState = $"../Ground"
@onready var wall_state: WallState = $"../Wall"
@onready var animation_tree: AnimationTree = $"../../AnimationTree"


func state_process(_delta: float) -> void:
	if owner.is_on_floor():
		next_state = ground_state
		return
	if owner.is_on_wall_only():
		next_state = wall_state
		return


func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && owner.jumps_taken < owner.max_jumps:
		PlayerStats.update_stats("Jumps", 1)
		owner.velocity.y = owner.jump_velocity
		owner.jumps_taken += 1
		playback.travel("double_jump")


func on_enter() -> void:
	playback.travel("Air")
	owner.wall_hanging = false

	owner.wall_hang_delay_timer = Timer.new()
	owner.wall_hang_delay_timer.name = "WallHangDelayTimer"
	owner.add_child(owner.wall_hang_delay_timer)

	owner.wall_hang_delay_timer.one_shot = true
	owner.wall_hang_delay_timer.connect("timeout", owner._on_wall_hang_delay_timer_timeout)
	owner.wall_hang_delay_timer.start(owner.wall_hang_delay)
	owner.can_wall_hang = false
