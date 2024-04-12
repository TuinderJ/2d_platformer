extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_scene
var new_scene
var animation: String
var player: Player
var can_play := true

func _ready() -> void:
	if not current_scene and get_tree().current_scene is Level:
		current_scene = get_tree().current_scene

func transition_to_level(new_scene_path: String, _animation: String = "fade_to_black", _player: Player = null) -> void:
	if animation_player.is_playing():
		return
	# Load the new level from the path provided

	new_scene = load(new_scene_path).instantiate()

	if _player:
		player = _player
	elif new_scene is Level:
		player = preload("res://entities/player/player.tscn").instantiate()

	if player:
		player.can_move = false
		new_scene.player = player
	animation = _animation
	animation_player.play(animation)

func on_to_animation_finished() -> void:
	# If you passed in a player, remove it from the previous level and apply it to the new level.
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	# If you're coming from a level, remove that level.
	if current_scene:
		current_scene.free()

	# Set the current level to the incoming level.
	current_scene = new_scene
	get_parent().call_deferred_thread_group("add_child", new_scene)

	animation_player.play(animation.replace("to", "from"))

func on_from_animation_finished() -> void:
	# After the level comes back in, let the player move
	if player:
		player.can_move = true
