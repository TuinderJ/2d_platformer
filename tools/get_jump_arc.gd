@tool
extends Node

var arc = preload("res://tools/jump_arc.tscn").instantiate()
var arc_is_being_used: bool = false

func _process(delta: float) -> void:
	if arc_is_being_used:
		arc.global_position = Vector2(get_viewport().get_mouse_position())

func _input(event: InputEvent) -> void:
	print("event")
	if event.is_action_pressed("jump"):
		print("pressed")
		arc_is_being_used = true
