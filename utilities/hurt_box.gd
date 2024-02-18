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

	if area.owner is Player:
		area.owner.bounce_on_enemy()
		owner.player = area.owner

	if owner.has_method("take_damage"):
		owner.take_damage(area.owner.damage)
