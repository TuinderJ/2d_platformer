extends NPC

@export_file(".dialogue") var dialogue_file
@export var dialogue_node_title: String

func _ready() -> void:
	DialogueGlobals.wise_old_man_disappear.connect(disappear)

func interact() -> void:
	var wise_old_man_dialogue = load(dialogue_file)
	DialogueManager.show_dialogue_balloon(wise_old_man_dialogue, dialogue_node_title)

func disappear() -> void:
	queue_free()
