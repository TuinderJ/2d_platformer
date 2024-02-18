extends Node

class_name SceneManager

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hud: Control = $"../UI/HUD"

var current_level: Level
var new_level: Level
var animation: String
var player: Player
var can_play := true


func transition_to_level(new_level_path: String, _animation: String = "fade_to_black", _player: Player = null) -> void:
	# Load the new level from the path provided
	new_level = load(new_level_path).instantiate()

	if _player:
		player = _player
	else:
		player = preload("res://entities/player/player.tscn").instantiate()
		player.connect("health_updated", hud.update_health)
		player.connect("max_health_updated", hud.update_max_health)

	#hud.show()
	player.can_move = false
	new_level.player = player
	animation = _animation
	animation_player.play(animation)


func on_to_animation_finished() -> void:
	# If you passed in a player, remove it from the previous level and apply it to the new level.
	if player.get_parent():
		player.get_parent().remove_child(player)

	# If you're coming from a level, remove that level.
	if current_level:
		current_level.queue_free()

	# Set the current level to the incoming level.
	current_level = new_level
	get_parent().call_deferred_thread_group("add_child", new_level)

	animation_player.play(animation.replace("to", "from"))

func on_from_animation_finished() -> void:
	# After the level comes back in, let the player move
	player.can_move = true
