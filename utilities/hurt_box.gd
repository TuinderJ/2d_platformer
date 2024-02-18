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
	if get_parent() == area.get_parent():
		return

	if area.get_parent().get_parent() is Player:
		area.get_parent().get_parent().bounce_on_enemy()

	if get_parent().get_parent().has_method("take_damage"):
		get_parent().get_parent().take_damage(area.get_parent().get_parent().damage)
