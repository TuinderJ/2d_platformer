extends NPC


func interact() -> void:
	get_tree().paused = true
	var wise_old_man_dialogue = load("res://dialogue/wise_old_man.dialogue")
	DialogueManager.show_dialogue_balloon(wise_old_man_dialogue, "first_contact")
