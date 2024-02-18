extends State

@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"


func state_process(_delta: float) -> void:
	if not ray_cast_2d.is_colliding():
		owner.velocity.x = 0
		return
	if owner.player.global_position.x - owner.global_position.x < -3:
		owner.velocity.x = abs(owner.speed) * owner.sprint_modifier * -1
	elif owner.player.global_position.x - owner.global_position.x > 3:
		owner.velocity.x = abs(owner.speed) * owner.sprint_modifier
	else:
		owner.velocity.x = 0
