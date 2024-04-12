extends Control

func _ready() -> void:
	Pause.game_paused.connect(open_pause_menu)
	Pause.game_unpaused.connect(close_pause_menu)

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_stats_button_pressed() -> void:
	hide()
	get_node("../StatScreen").show()

func _on_save_button_pressed() -> void:
	pass # Replace with function body.

func _on_load_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func open_pause_menu() -> void:
	show()
	$PanelContainer/PanelContainer/MarginContainer/VBoxContainer/resume_button.grab_focus()

func close_pause_menu() -> void:
	hide()
