extends Control

var focusing := false

func _ready() -> void:
	$PanelContainer/PanelContainer/MarginContainer/VBoxContainer/NewGameButton.grab_focus()

func _on_new_game_button_pressed() -> void: ## Load Level 1
	hide()

	var new_game_path = "res://ui/new_game_menu.tscn"
	get_node("/root/SceneManager").transition_to_level(new_game_path, "none")

func _on_continue_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()

