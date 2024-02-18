extends State

@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"


func on_enter() -> void:
	print_debug("Wandering")


func on_exit() -> void:
	print_debug("Not Wandering")


func state_process(delta: float) -> void:
	if not ray_cast_2d.is_colliding():
		flip()

	owner.velocity.x = owner.speed


func flip() -> void:
	owner.speed = owner.speed * -1
