extends Area2D

class_name Door

@export_file(".tscn") var level_path: String
@export_enum("fade_to_black", "swipe_to_left", "swipe_to_right") var animation: String

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	get_node("/root/SceneManager").transition_to_level(level_path, animation, body)
