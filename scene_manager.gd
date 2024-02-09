extends Node

var current_level: Level


func transition_to_level(level_to: String, player: Player = null) -> void:
	for child in get_tree().root.get_children():
		if child is Level:
			print(child)

	var new_level = load(level_to).instantiate()
	get_tree().root.add_child(new_level)
