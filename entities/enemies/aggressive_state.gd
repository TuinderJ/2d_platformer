extends State

class_name EnemyAggressiveState

@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"
@onready var my_owner := owner

func state_process(_delta: float) -> void:
	if not ray_cast_2d.is_colliding() or owner.is_on_wall():
		owner.speed = owner.speed * -1

	owner.velocity.x = owner.speed * owner.sprint_modifier
