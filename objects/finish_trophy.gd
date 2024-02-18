extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	animation_player.play("pressed")
