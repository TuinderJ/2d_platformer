extends State

class_name EnemyAggressiveState

@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"


func state_process(_delta: float) -> void:
	var player_is_to_the_left: bool = owner.player.global_position.x - owner.global_position.x < -3
	var player_is_to_the_right: bool = owner.player.global_position.x - owner.global_position.x > 3
	# Player chasing mechanism
	if player_is_to_the_left:
		owner.velocity.x = abs(owner.speed) * owner.sprint_modifier * -1
	elif player_is_to_the_right:
		owner.velocity.x = abs(owner.speed) * owner.sprint_modifier
	else:
		owner.velocity.x = 0

	# If the enemy is about to walk off of an edge
	if not ray_cast_2d.is_colliding() and owner.facing_right and player_is_to_the_right:
		owner.velocity.x = 0
		return
	if not ray_cast_2d.is_colliding() and not owner.facing_right and player_is_to_the_left:
		owner.velocity.x = 0
		return
