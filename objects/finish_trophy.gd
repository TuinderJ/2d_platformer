extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var identifier = "Trophy"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Player or animation_player.current_animation == "pressed":
		return

	animation_player.play("pressed")
	PlayerStats.update_stats(identifier, 1)
	
