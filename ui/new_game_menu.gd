extends Control

func _ready() -> void:
	$PanelContainer/PanelContainer/MarginContainer/VBoxContainer/SpeedrunTimer.grab_focus()


func _on_start_button_pressed() -> void:
	PlayerStats.speedrun_timer_enabled = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/SpeedrunTimer.button_pressed
	get_node("/root/SceneManager").transition_to_level("res://levels/level_1.tscn", "none")
