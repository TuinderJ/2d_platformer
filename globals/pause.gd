extends Node

var can_pause := true

signal game_paused
signal game_unpaused

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func toggle_pause_game() -> void:
	if not can_pause:
		return
	for child in get_tree().root.get_children():
		if child is Level:
			if get_tree().is_paused():
				game_unpaused.emit()
			else:
				game_paused.emit()
			get_tree().paused = !get_tree().paused

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		toggle_pause_game()
	if event.is_action_pressed("debug_close_game"):
		get_tree().quit()
