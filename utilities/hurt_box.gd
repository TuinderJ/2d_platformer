extends Area2D

class_name HurtBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 0
	collision_mask = 4
	connect("area_entered", _on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if not area is HitBox:
		return
	if owner == area.owner:
		return

	if area.owner is Player and area.owner.velocity.y < 0:
		return

	# If the player is above the centerpoint of the enemy hitbox.
	if area.owner is Player and area.owner.global_position.y < global_position.y and owner.has_method("take_damage"):
		area.owner.bounce_on_enemy()
		owner.player = area.owner
		owner.take_damage(area.owner.damage)

	# If the enemy hit the player.
	if owner is Player and area.owner is Enemy and area.global_position.y <= owner.global_position.y:
		owner.take_damage(area.owner.damage)
