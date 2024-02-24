extends State

class_name EnemyWanderState

@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"


func state_process(_delta: float) -> void:
	if not ray_cast_2d.is_colliding() or owner.is_on_wall():
		owner.speed = owner.speed * -1

	owner.velocity.x = owner.speed
