extends Panel

class_name EnemyHealthBar

@onready var current_health: Panel = $CurrentHealth


func _ready() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			size = Vector2(get_parent().get_child(0).shape.size.x, 3)
			return


func update_health(max_health: int, health: int) -> void:
	@warning_ignore("narrowing_conversion")
	var width: int = health * size.x / max_health
	current_health.size.x = width
	if hidden:
		show()
