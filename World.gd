extends Node2D

func toggle_pause_game() -> void:
	if get_tree().is_paused():
		close_pause_menu()
	else:
		open_pause_menu()
	get_tree().paused = !get_tree().paused

func open_pause_menu() -> void:
	$Pause_Menu.show()
	pass

func close_pause_menu() -> void:
	$Pause_Menu.hide()
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Toggle Pause"):
		toggle_pause_game()
