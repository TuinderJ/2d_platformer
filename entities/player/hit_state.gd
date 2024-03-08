extends State

class_name HitState

@onready var ground_state: GroundState = $"../Ground"
@onready var air_state: AirState = $"../Air"
@onready var wall_state: WallState = $"../Wall"



func on_enter() -> void:
	playback.travel("take_damage")


func on_take_damage_animation_end() -> void:
	if owner.is_on_floor():
		next_state = ground_state
		return
	if owner.is_on_wall_only():
		next_state = wall_state
		return
	# The only other option is being in the air.
	next_state = air_state
