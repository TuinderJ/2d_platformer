extends Node2D

class_name World

@onready var scene_manager: Node = $SceneManager
@onready var pause_menu: Control = $UI/PauseMenu


func toggle_pause_game() -> void:
	for child in get_children():
		if child is Level:
			if get_tree().is_paused():
				pause_menu.close_pause_menu()
			else:
				pause_menu.open_pause_menu()
			get_tree().paused = !get_tree().paused


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		toggle_pause_game()
	if event.is_action_pressed("debug_close_game"):
		get_tree().quit()


func _on_main_menu_new_game() -> void:
	scene_manager.transition_to_level("res://levels/level_1.tscn")
