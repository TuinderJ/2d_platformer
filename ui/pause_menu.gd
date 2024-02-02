extends Control


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_save_button_pressed() -> void:
	pass # Replace with function body.


func _on_load_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_secret_button_pressed() -> void:
	pass # Replace with function body.
